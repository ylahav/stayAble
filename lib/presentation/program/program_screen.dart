import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:plinth_blocks/plinth_blocks.dart';

import '../../l10n/app_localizations.dart';
import '../../core/l10n/labels.dart';
import '../../core/widgets/language_toggle.dart';
import '../../core/widgets/stayable_async.dart';
import '../../data/remote/session_store.dart';
import '../../domain/domain.dart';
import '../exercises/exercise_preview_sheet.dart';
import '../profile/birthday_prompt.dart';
import '../providers.dart';

class ProgramScreen extends ConsumerStatefulWidget {
  const ProgramScreen({super.key});

  @override
  ConsumerState<ProgramScreen> createState() => _ProgramScreenState();
}

class _ProgramScreenState extends ConsumerState<ProgramScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final async = ref.watch(programSnapshotProvider);
    final isLocal = ref.watch(appModeProvider) == AppMode.local;

    return StayAblePage(
      title: l10n.myPrograms,
      actions: [
        const LanguageToggle(),
        if (isLocal)
          PlinthActionIcon(
            semanticLabel: l10n.createProgram,
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/program/new'),
          ),
      ],
      body: async.when(
        loading: () => const StayAbleLoading(),
        error: (e, _) => StayAbleError(message: e),
        data: (snap) {
          if (snap.programs.isEmpty) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(
                PlinthSpacing.lg,
                PlinthSpacing.sm,
                PlinthSpacing.lg,
                PlinthSpacing.xl,
              ),
              children: [
                PlinthEmptyState(
                  title: isLocal ? l10n.noProgramLocal : l10n.noProgramAssigned,
                ),
                if (isLocal) ...[
                  const PlinthSpace(h: PlinthSize.md),
                  _CreateProgramButton(l10n: l10n),
                ],
              ],
            );
          }
          final todayWeekday = DateTime.now().weekday;
          final initialProgram = snap.programs
                  .where(
                    (view) => view.days.any(
                      (day) =>
                          day.weekday == todayWeekday || day.weekday == null,
                    ),
                  )
                  .map((view) => view.program.id)
                  .firstOrNull ??
              snap.programs.first.program.id;

          return ListView(
            padding: const EdgeInsets.fromLTRB(
              PlinthSpacing.lg,
              PlinthSpacing.sm,
              PlinthSpacing.lg,
              PlinthSpacing.xl,
            ),
            children: [
              if (isLocal) ...[
                _CreateProgramButton(l10n: l10n),
                const PlinthSpace(h: PlinthSize.lg),
              ],
              PlinthAccordion(
                multiple: true,
                initiallyOpen: {initialProgram},
                items: [
                  for (final view in snap.programs)
                    PlinthAccordionItem(
                      value: view.program.id,
                      title: view.program.name,
                      content: _ProgramPanel(
                        view: view,
                        locale: locale,
                        l10n: l10n,
                        todayWeekday: todayWeekday,
                        canEdit:
                            isLocal && isLocalProgramId(view.program.id),
                        onEdit: () =>
                            context.push('/program/edit/${view.program.id}'),
                        onDelete: () => _deleteProgram(view.program.id),
                        onStart: (dayId) => _startDay(view, dayId),
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _startDay(AssignedProgramView view, String dayId) {
    return startProgramDay(
      context: context,
      ref: ref,
      dayId: dayId,
      resumeSessionId: view.inProgressByDayId[dayId],
    );
  }

  Future<void> _deleteProgram(String id) async {
    final l10n = AppLocalizations.of(context);
    final controller = PlinthDisclosureController();
    var confirmed = false;
    await PlinthModal(
      controller: controller,
      title: l10n.deleteProgram,
      size: PlinthSize.sm,
      child: Builder(
        builder: (modalContext) {
          return PlinthStack(
            children: [
              PlinthText(l10n.deleteProgramConfirm),
              PlinthGroup(
                children: [
                  PlinthButton(
                    variant: PlinthVariant.subtle,
                    onPressed: () => Navigator.of(modalContext).pop(),
                    child: Text(l10n.cancel),
                  ),
                  PlinthButton(
                    onPressed: () {
                      confirmed = true;
                      Navigator.of(modalContext).pop();
                    },
                    child: Text(l10n.deleteProgram),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    ).show(context);
    controller.dispose();
    if (!confirmed || !mounted) return;
    await ref.read(repositoryProvider).deleteLocalProgram(id);
    ref.invalidate(homeSnapshotProvider);
    ref.invalidate(programSnapshotProvider);
    ref.invalidate(historySnapshotProvider);
  }
}

class _CreateProgramButton extends StatelessWidget {
  const _CreateProgramButton({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return PlinthButton(
      fullWidth: true,
      onPressed: () => context.push('/program/new'),
      child: Text(l10n.createProgram),
    );
  }
}

class _ProgramPanel extends StatelessWidget {
  const _ProgramPanel({
    required this.view,
    required this.locale,
    required this.l10n,
    required this.todayWeekday,
    required this.canEdit,
    required this.onEdit,
    required this.onDelete,
    required this.onStart,
  });

  final AssignedProgramView view;
  final Locale locale;
  final AppLocalizations l10n;
  final int todayWeekday;
  final bool canEdit;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Future<void> Function(String dayId) onStart;

  @override
  Widget build(BuildContext context) {
    final openDays = {
      for (final day in view.days)
        if (day.weekday == todayWeekday || day.weekday == null) day.id,
    };

    return PlinthStack(
      children: [
        PlinthText(
          '${programVenueLabel(l10n, view.program.venue)} · ${scheduleTypeLabel(l10n, view.program.scheduleType)}',
          color: 'gray',
        ),
        if (canEdit)
          PlinthGroup(
            children: [
              PlinthButton(
                variant: PlinthVariant.outline,
                onPressed: onEdit,
                child: Text(l10n.editProgram),
              ),
              PlinthButton(
                variant: PlinthVariant.subtle,
                onPressed: onDelete,
                child: Text(l10n.deleteProgram),
              ),
            ],
          ),
        if (view.days.isNotEmpty)
          PlinthAccordion(
            multiple: true,
            initiallyOpen: openDays,
            items: [
              for (final day in view.days)
                PlinthAccordionItem(
                  value: day.id,
                  title: _dayTitle(day),
                  content: _DayPanel(
                    view: view,
                    day: day,
                    locale: locale,
                    l10n: l10n,
                    onStart: () => onStart(day.id),
                  ),
                ),
            ],
          ),
      ],
    );
  }

  String _dayTitle(ProgramDay day) {
    final label = programDayLabel(l10n, day.weekday);
    final status = _dayTrailing(day);
    final count = view.exercisesByDay[day.id]?.length ?? 0;
    return '$label · ${l10n.exerciseCount(count)} · $status';
  }

  String _dayTrailing(ProgramDay day) {
    if (view.completedDayIds.contains(day.id)) return l10n.completed;
    if (view.inProgressByDayId.containsKey(day.id)) return l10n.inProgress;
    if (day.weekday == null || day.weekday == todayWeekday) return l10n.today;
    return l10n.upcoming;
  }
}

class _DayPanel extends StatelessWidget {
  const _DayPanel({
    required this.view,
    required this.day,
    required this.locale,
    required this.l10n,
    required this.onStart,
  });

  final AssignedProgramView view;
  final ProgramDay day;
  final Locale locale;
  final AppLocalizations l10n;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final items = view.exercisesByDay[day.id] ?? const <ProgramExerciseItem>[];
    return PlinthStack(
      children: [
        PlinthButton(
          fullWidth: true,
          onPressed: onStart,
          child: Text(
            view.inProgressByDayId.containsKey(day.id)
                ? l10n.resumeWorkout
                : l10n.start,
          ),
        ),
        if (items.isNotEmpty)
          PlinthAccordion(
            multiple: true,
            items: [
              for (final item in items)
                PlinthAccordionItem(
                  value: item.assignment.id,
                  title: localizedName(item.exercise.name, locale),
                  content: PlinthStack(
                    children: [
                      PlinthText(
                        prescriptionLabel(l10n, item.assignment),
                        color: 'gray',
                      ),
                      PlinthButton(
                        variant: PlinthVariant.outline,
                        fullWidth: true,
                        onPressed: () => showExercisePreview(
                          context: context,
                          item: item,
                        ),
                        child: Text(l10n.description),
                      ),
                    ],
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
