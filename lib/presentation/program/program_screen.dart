import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:plinth_blocks/plinth_blocks.dart';

import '../../l10n/app_localizations.dart';
import '../../core/l10n/labels.dart';
import '../../core/widgets/language_toggle.dart';
import '../../core/widgets/stayable_async.dart';
import '../../domain/domain.dart';
import '../exercises/exercise_preview_sheet.dart';
import '../providers.dart';

class ProgramScreen extends ConsumerStatefulWidget {
  const ProgramScreen({super.key});

  @override
  ConsumerState<ProgramScreen> createState() => _ProgramScreenState();
}

class _ProgramScreenState extends ConsumerState<ProgramScreen> {
  String? _selectedDayId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final async = ref.watch(programSnapshotProvider);

    return StayAblePage(
      title: (async.value?.programs.length ?? 0) > 1
          ? l10n.myPrograms
          : l10n.myProgram,
      actions: const [LanguageToggle()],
      body: async.when(
        loading: () => const StayAbleLoading(),
        error: (e, _) => StayAbleError(message: e),
        data: (snap) {
          if (snap.programs.isEmpty) {
            return PlinthEmptyState(title: l10n.noProgramAssigned);
          }
          final todayWeekday = DateTime.now().weekday;
          final allDays = [
            for (final view in snap.programs) ...view.days,
          ];
          final selectedId = _selectedDayId ??
              allDays
                  .where((d) => d.weekday == todayWeekday)
                  .map((d) => d.id)
                  .firstOrNull ??
              allDays.first.id;

          return ListView(
            padding: const EdgeInsets.fromLTRB(
              PlinthSpacing.lg,
              PlinthSpacing.sm,
              PlinthSpacing.lg,
              PlinthSpacing.xl,
            ),
            children: [
              for (var i = 0; i < snap.programs.length; i++) ...[
                if (i > 0) const PlinthSpace(h: PlinthSize.lg),
                _ProgramSection(
                  view: snap.programs[i],
                  locale: locale,
                  l10n: l10n,
                  todayWeekday: todayWeekday,
                  selectedDayId: selectedId,
                  onSelectDay: (id) => setState(() => _selectedDayId = id),
                  onStart: (dayId) async {
                    final inProgressId =
                        snap.programs[i].inProgressByDayId[dayId];
                    final session = inProgressId != null
                        ? await ref
                            .read(repositoryProvider)
                            .resumeSession(inProgressId)
                        : await ref
                            .read(repositoryProvider)
                            .startOrResumeSession(dayId);
                    if (!context.mounted) return;
                    ref.invalidate(homeSnapshotProvider);
                    ref.invalidate(programSnapshotProvider);
                    ref.invalidate(historySnapshotProvider);
                    context.push('/workout/${session.id}');
                  },
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _ProgramSection extends StatelessWidget {
  const _ProgramSection({
    required this.view,
    required this.locale,
    required this.l10n,
    required this.todayWeekday,
    required this.selectedDayId,
    required this.onSelectDay,
    required this.onStart,
  });

  final AssignedProgramView view;
  final Locale locale;
  final AppLocalizations l10n;
  final int todayWeekday;
  final String selectedDayId;
  final ValueChanged<String> onSelectDay;
  final Future<void> Function(String dayId) onStart;

  @override
  Widget build(BuildContext context) {
    final selected = view.days.where((d) => d.id == selectedDayId).firstOrNull;
    final items = selected == null
        ? const <ProgramExerciseItem>[]
        : (view.exercisesByDay[selected.id] ?? const []);

    return PlinthCard(
      withBorder: true,
      header: PlinthStack(
        gap: PlinthSize.xs,
        children: [
          PlinthTitle(view.program.name, order: 3),
          PlinthText(programVenueLabel(l10n, view.program.venue), color: 'gray'),
        ],
      ),
      footer: selected == null
          ? null
          : PlinthButton(
              fullWidth: true,
              onPressed: () => onStart(selected.id),
              child: Text(
                view.inProgressByDayId.containsKey(selected.id)
                    ? l10n.resumeWorkout
                    : l10n.start,
              ),
            ),
      child: PlinthStack(
        children: [
          for (final day in view.days)
            PlinthNavLink(
              label: weekdayLabel(l10n, day.weekday ?? 0),
              active: day.id == selectedDayId,
              trailing: PlinthText(
                _dayTrailing(l10n, view, day, todayWeekday),
                color: view.completedDayIds.contains(day.id) ||
                        view.inProgressByDayId.containsKey(day.id)
                    ? 'green'
                    : 'gray',
                size: PlinthSize.sm,
              ),
              onTap: () => onSelectDay(day.id),
            ),
          if (selected != null) ...[
            PlinthTitle(
              '${weekdayLabel(l10n, selected.weekday ?? 0)} — ${localizedName(selected.title, locale)}',
              order: 4,
            ),
            for (var i = 0; i < items.length; i++)
              PlinthNavLink(
                label: localizedName(items[i].exercise.name, locale),
                trailing: PlinthText(
                  prescriptionLabel(l10n, items[i].assignment),
                  color: 'gray',
                  size: PlinthSize.sm,
                ),
                onTap: () => showExercisePreview(
                  context: context,
                  item: items[i],
                ),
              ),
          ],
        ],
      ),
    );
  }

  String _dayTrailing(
    AppLocalizations l10n,
    AssignedProgramView view,
    ProgramDay day,
    int todayWeekday,
  ) {
    if (view.completedDayIds.contains(day.id)) return l10n.completed;
    if (view.inProgressByDayId.containsKey(day.id)) return l10n.inProgress;
    if (day.weekday == todayWeekday) return l10n.today;
    return l10n.upcoming;
  }
}
