import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:plinth_blocks/plinth_blocks.dart';

import '../../core/l10n/labels.dart';
import '../../core/widgets/stayable_async.dart';
import '../../domain/domain.dart';
import '../../l10n/app_localizations.dart';
import '../providers.dart';

class LocalProgramEditorScreen extends ConsumerStatefulWidget {
  const LocalProgramEditorScreen({super.key, this.programId});

  final String? programId;

  @override
  ConsumerState<LocalProgramEditorScreen> createState() =>
      _LocalProgramEditorScreenState();
}

class _LocalProgramEditorScreenState
    extends ConsumerState<LocalProgramEditorScreen> {
  final _name = TextEditingController();
  var _venue = ProgramVenue.home;
  var _schedule = ScheduleType.weekly;
  final _weekdays = <int>{};
  final _slots = <int, List<_TrackedSlot>>{};
  var _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.programId != null) {
      _load();
    }
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final draft =
        await ref.read(repositoryProvider).getLocalProgram(widget.programId!);
    if (!mounted) return;
    if (draft == null) {
      setState(() {
        _loading = false;
        _error = AppLocalizations.of(context).noProgramAssigned;
      });
      return;
    }
    _name.text = draft.name;
    setState(() {
      _venue = draft.venue;
      _schedule = draft.scheduleType;
      _weekdays
        ..clear()
        ..addAll(
          draft.isOccasional
              ? const <int>{}
              : draft.weekdays.isEmpty && draft.scheduleType == ScheduleType.daily
                  ? {
                      for (var day = DateTime.monday;
                          day <= DateTime.sunday;
                          day++)
                        day,
                    }
                  : draft.weekdays,
        );
      _slots
        ..clear()
        ..addAll({
          for (final entry in draft.slotsByWeekday.entries)
            entry.key: [
              for (final slot in entry.value) _TrackedSlot(slot),
            ],
        });
      _loading = false;
    });
  }

  List<_TrackedSlot> _listFor(int weekday) =>
      _slots.putIfAbsent(weekday, () => <_TrackedSlot>[]);

  Future<void> _addExercise(int weekday) async {
    final id = await context.push<String>('/catalog/pick');
    if (!mounted || id == null || id.isEmpty) return;
    final exercise = await ref.read(repositoryProvider).getExercise(id);
    final duration = exercise?.duration;
    final timed = duration != null && duration > 0;
    final slot = LocalProgramSlot(
      exerciseId: id,
      sets: 3,
      repetitions: timed ? null : (exercise?.repetitions ?? 10),
      duration: timed ? duration : null,
      rest: 30,
    );
    setState(() {
      _listFor(weekday).add(_TrackedSlot(slot));
    });
  }

  void _updateSlot(int weekday, int index, LocalProgramSlot slot) {
    final next = _listFor(weekday);
    if (index < 0 || index >= next.length) return;
    setState(() => next[index].slot = slot);
  }

  void _removeSlot(int weekday, int index) {
    final next = _listFor(weekday);
    if (index < 0 || index >= next.length) return;
    setState(() => next.removeAt(index));
  }

  void _reorderSlot(int weekday, int oldIndex, int newIndex) {
    final next = _listFor(weekday);
    if (oldIndex < 0 || oldIndex >= next.length) return;
    setState(() {
      final item = next.removeAt(oldIndex);
      final index = newIndex.clamp(0, next.length);
      next.insert(index, item);
    });
  }

  void _copySlots(int from, int to) {
    if (_listFor(to).isNotEmpty) return;
    _slots[to] = [
      for (final item in _listFor(from)) _TrackedSlot(item.slot),
    ];
  }

  void _setSchedule(ScheduleType type) {
    setState(() {
      final from = _schedule;
      _schedule = type;
      if (type == ScheduleType.daily) {
        for (var day = DateTime.monday; day <= DateTime.sunday; day++) {
          _weekdays.add(day);
        }
        if (from == ScheduleType.occasional) {
          _copySlots(occasionalSlotKey, DateTime.monday);
        }
        return;
      }
      if (type == ScheduleType.occasional) {
        final source = [..._weekdays]..sort();
        if (source.isNotEmpty) _copySlots(source.first, occasionalSlotKey);
        return;
      }
      if (_weekdays.isEmpty) {
        _weekdays.addAll(const {
          DateTime.monday,
          DateTime.wednesday,
          DateTime.friday,
        });
      }
      if (from == ScheduleType.occasional) {
        _copySlots(occasionalSlotKey, ([..._weekdays]..sort()).first);
      }
    });
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final name = _name.text.trim();
    final occasional = isAnytimeSchedule(_schedule);
    final weekdays = [..._weekdays]..sort();
    if (name.isEmpty) {
      setState(() => _error = l10n.programNameRequired);
      return;
    }
    if (!occasional && weekdays.isEmpty) {
      setState(() => _error = l10n.selectDays);
      return;
    }
    final hasExercise = occasional
        ? _listFor(occasionalSlotKey).isNotEmpty
        : weekdays.any((weekday) => _listFor(weekday).isNotEmpty);
    if (!hasExercise) {
      setState(() => _error = l10n.programNeedsExercise);
      return;
    }
    setState(() => _error = null);
    await ref.read(repositoryProvider).saveLocalProgram(
          LocalProgramDraft(
            id: widget.programId,
            name: name,
            venue: _venue,
            scheduleType: occasional
                ? ScheduleType.occasional
                : _schedule == ScheduleType.daily
                    ? ScheduleType.daily
                    : ScheduleType.weekly,
            weekdays: occasional ? const [] : weekdays,
            slotsByWeekday: occasional
                ? {
                    occasionalSlotKey: [
                      for (final item in _listFor(occasionalSlotKey))
                        item.slot,
                    ],
                  }
                : {
                    for (final weekday in weekdays)
                      weekday: [
                        for (final item in _listFor(weekday)) item.slot,
                      ],
                  },
          ),
        );
    ref.invalidate(homeSnapshotProvider);
    ref.invalidate(programSnapshotProvider);
    ref.invalidate(historySnapshotProvider);
    if (!mounted) return;
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final occasional = isAnytimeSchedule(_schedule);
    final days = [..._weekdays]..sort();
    return StayAblePage(
      title: widget.programId == null ? l10n.createProgram : l10n.editProgram,
      leading: PlinthActionIcon(
        semanticLabel: MaterialLocalizations.of(context).backButtonTooltip,
        icon: const Icon(Icons.arrow_back),
        onPressed: () => context.pop(),
      ),
      body: _loading
          ? const StayAbleLoading()
          : StayAbleScrollBody(
              children: [
                if (_error != null)
                  PlinthAlert(color: 'red', child: Text(_error!)),
                PlinthTextInput(
                  controller: _name,
                  label: l10n.programName,
                ),
                const PlinthSpace(h: PlinthSize.md),
                PlinthText(programVenueLabel(l10n, _venue), color: 'gray'),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: PlinthGroup(
                    children: [
                      for (final venue in ProgramVenue.values)
                        PlinthChip(
                          label: programVenueLabel(l10n, venue),
                          selected: _venue == venue,
                          onSelected: (_) => setState(() => _venue = venue),
                        ),
                    ],
                  ),
                ),
                const PlinthSpace(h: PlinthSize.md),
                PlinthText(l10n.wizardPeriod, color: 'gray'),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: PlinthGroup(
                    children: [
                      PlinthChip(
                        label: l10n.wizardPeriodWeekly,
                        selected: _schedule == ScheduleType.weekly,
                        onSelected: (_) => _setSchedule(ScheduleType.weekly),
                      ),
                      PlinthChip(
                        label: l10n.wizardPeriodDaily,
                        selected: _schedule == ScheduleType.daily,
                        onSelected: (_) => _setSchedule(ScheduleType.daily),
                      ),
                      PlinthChip(
                        label: l10n.wizardPeriodOccasional,
                        selected: occasional,
                        onSelected: (_) =>
                            _setSchedule(ScheduleType.occasional),
                      ),
                    ],
                  ),
                ),
                PlinthText(
                  switch (_schedule) {
                    ScheduleType.daily => l10n.wizardPeriodDailyHint,
                    ScheduleType.occasional =>
                      l10n.wizardPeriodOccasionalHint,
                    _ => l10n.wizardPeriodWeeklyHint,
                  },
                  color: 'gray',
                ),
                if (!occasional && _schedule == ScheduleType.weekly) ...[
                  const PlinthSpace(h: PlinthSize.md),
                  PlinthText(l10n.wizardDays, color: 'gray'),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: PlinthGroup(
                      children: [
                        for (var weekday = DateTime.monday;
                            weekday <= DateTime.sunday;
                            weekday++)
                          PlinthChip(
                            label: weekdayLabel(l10n, weekday),
                            selected: _weekdays.contains(weekday),
                            onSelected: (_) {
                              setState(() {
                                if (_weekdays.contains(weekday)) {
                                  _weekdays.remove(weekday);
                                } else {
                                  _weekdays.add(weekday);
                                }
                              });
                            },
                          ),
                      ],
                    ),
                  ),
                ],
                if (!occasional && days.isNotEmpty) ...[
                  const PlinthSpace(h: PlinthSize.lg),
                  PlinthAccordion(
                    multiple: true,
                    initiallyOpen: {days.first.toString()},
                    items: [
                      for (final weekday in days)
                        PlinthAccordionItem(
                          value: weekday.toString(),
                          title: weekdayLabel(l10n, weekday),
                          content: _DayEditor(
                            slots: _listFor(weekday),
                            onAdd: () => _addExercise(weekday),
                            onChanged: (index, slot) =>
                                _updateSlot(weekday, index, slot),
                            onRemove: (index) => _removeSlot(weekday, index),
                            onReorder: (oldIndex, newIndex) =>
                                _reorderSlot(weekday, oldIndex, newIndex),
                          ),
                        ),
                    ],
                  ),
                ] else if (occasional) ...[
                  const PlinthSpace(h: PlinthSize.lg),
                  _DayEditor(
                    slots: _listFor(occasionalSlotKey),
                    onAdd: () => _addExercise(occasionalSlotKey),
                    onChanged: (index, slot) =>
                        _updateSlot(occasionalSlotKey, index, slot),
                    onRemove: (index) => _removeSlot(occasionalSlotKey, index),
                    onReorder: (oldIndex, newIndex) => _reorderSlot(
                      occasionalSlotKey,
                      oldIndex,
                      newIndex,
                    ),
                  ),
                ],
                const PlinthSpace(h: PlinthSize.lg),
                PlinthAsyncButton(
                  fullWidth: true,
                  onPressed: _save,
                  doneLabel: l10n.programSaved,
                  child: Text(l10n.saveProgram),
                ),
              ],
            ),
    );
  }
}

class _TrackedSlot {
  _TrackedSlot(this.slot) : key = UniqueKey();

  final Key key;
  LocalProgramSlot slot;
}

class _DayEditor extends StatelessWidget {
  const _DayEditor({
    required this.slots,
    required this.onAdd,
    required this.onChanged,
    required this.onRemove,
    required this.onReorder,
  });

  final List<_TrackedSlot> slots;
  final Future<void> Function() onAdd;
  final void Function(int index, LocalProgramSlot slot) onChanged;
  final ValueChanged<int> onRemove;
  final void Function(int oldIndex, int newIndex) onReorder;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PlinthStack(
      children: [
        if (slots.isNotEmpty)
          ReorderableListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            buildDefaultDragHandles: false,
            onReorderItem: onReorder,
            proxyDecorator: (child, index, animation) {
              return Material(
                elevation: 2,
                color: Colors.transparent,
                child: child,
              );
            },
            children: [
              for (var i = 0; i < slots.length; i++)
                _ReorderableExercise(
                  key: slots[i].key,
                  index: i,
                  slot: slots[i].slot,
                  onChanged: (slot) => onChanged(i, slot),
                  onRemove: () => onRemove(i),
                ),
            ],
          ),
        PlinthButton(
          fullWidth: true,
          variant: PlinthVariant.outline,
          onPressed: onAdd,
          child: Text(l10n.addExercise),
        ),
      ],
    );
  }
}

class _ReorderableExercise extends ConsumerWidget {
  const _ReorderableExercise({
    super.key,
    required this.index,
    required this.slot,
    required this.onChanged,
    required this.onRemove,
  });

  final int index;
  final LocalProgramSlot slot;
  final ValueChanged<LocalProgramSlot> onChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final exercise = ref.watch(exerciseByIdProvider(slot.exerciseId)).value;
    final name = exercise == null
        ? slot.exerciseId
        : localizedName(exercise.name, locale);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReorderableDragStartListener(
          index: index,
          child: Padding(
            padding: const EdgeInsets.only(top: 10, right: 4),
            child: Icon(
              Icons.drag_handle,
              semanticLabel: l10n.reorderExercise,
            ),
          ),
        ),
        Expanded(
          child: PlinthAccordion(
            items: [
              PlinthAccordionItem(
                value: 'slot-$index',
                title: name,
                content: _SlotFields(
                  slot: slot,
                  l10n: l10n,
                  onChanged: onChanged,
                  onRemove: onRemove,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SlotFields extends StatelessWidget {
  const _SlotFields({
    required this.slot,
    required this.l10n,
    required this.onChanged,
    required this.onRemove,
  });

  final LocalProgramSlot slot;
  final AppLocalizations l10n;
  final ValueChanged<LocalProgramSlot> onChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final timed = slot.duration != null && slot.duration! > 0;
    return PlinthStack(
      gap: PlinthSize.sm,
      children: [
        PlinthGroup(
          children: [
            PlinthChip(
              label: l10n.repsExercise,
              selected: !timed,
              onSelected: (_) => onChanged(
                slot.copyWith(
                  repetitions: slot.repetitions ?? 10,
                  clearDuration: true,
                ),
              ),
            ),
            PlinthChip(
              label: l10n.timedExercise,
              selected: timed,
              onSelected: (_) => onChanged(
                slot.copyWith(
                  duration: slot.duration ?? 30,
                  clearRepetitions: true,
                ),
              ),
            ),
            PlinthActionIcon(
              semanticLabel: l10n.removeExercise,
              icon: const Icon(Icons.delete_outline),
              onPressed: onRemove,
            ),
          ],
        ),
        PlinthNumberInput(
          value: slot.sets,
          min: 1,
          step: 1,
          label: l10n.sets,
          onChanged: (value) => onChanged(slot.copyWith(sets: value.round())),
        ),
        if (timed)
          PlinthNumberInput(
            value: slot.duration ?? 30,
            min: 5,
            step: 5,
            label: l10n.seconds,
            onChanged: (value) =>
                onChanged(slot.copyWith(duration: value.round())),
          )
        else
          PlinthNumberInput(
            value: slot.repetitions ?? 10,
            min: 1,
            step: 1,
            label: l10n.reps,
            onChanged: (value) =>
                onChanged(slot.copyWith(repetitions: value.round())),
          ),
        PlinthNumberInput(
          value: slot.rest,
          min: 0,
          step: 5,
          label: l10n.rest,
          onChanged: (value) => onChanged(slot.copyWith(rest: value.round())),
        ),
        PlinthNumberInput(
          value: slot.loadKg ?? 0,
          min: 0,
          step: 2.5,
          label: '${l10n.load} (${l10n.kg})',
          onChanged: (value) => onChanged(
            slot.copyWith(
              loadKg: value == 0 ? null : value.toDouble(),
              clearLoadKg: value == 0,
            ),
          ),
        ),
      ],
    );
  }
}
