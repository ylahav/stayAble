import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:plinth_blocks/plinth_blocks.dart';
import 'package:plinth_charts/plinth_charts.dart';

import '../../l10n/app_localizations.dart';
import '../../core/l10n/labels.dart';
import '../../core/widgets/language_toggle.dart';
import '../../core/widgets/note_composer.dart';
import '../../core/widgets/stayable_async.dart';
import '../../domain/domain.dart';
import '../auth/auth_controller.dart';
import '../profile/birthday_prompt.dart';
import '../providers.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final async = ref.watch(historySnapshotProvider);

    return StayAblePage(
      title: l10n.history,
      actions: const [LanguageToggle()],
      body: async.when(
        loading: () => const StayAbleLoading(),
        error: (e, _) => StayAbleError(message: e),
        data: (snap) {
          final format = DateFormat.MMMd(locale.toLanguageTag());
          return ListView(
            padding: const EdgeInsets.fromLTRB(
              PlinthSpacing.lg,
              PlinthSpacing.sm,
              PlinthSpacing.lg,
              PlinthSpacing.xl,
            ),
            children: [
              PlinthTitle(l10n.thisWeek, order: 3),
              const PlinthSpace(h: PlinthSize.sm),
              PlinthStatGrid(
                columns: 2,
                minColWidth: 140,
                tiles: [
                  PlinthStatTile(
                    label: l10n.workouts,
                    value: snap.weekStats.workouts.toString(),
                    visual: PlinthSparkline(
                      label: l10n.workouts,
                      values: _weekMinutes(snap.sessions),
                    ),
                  ),
                  PlinthStatTile(
                    label: l10n.workoutTime,
                    value: formatMinutesTotal(l10n, snap.weekStats.minutes),
                  ),
                  PlinthStatTile(
                    label: l10n.exercisesLabel,
                    value: snap.weekStats.exercises.toString(),
                  ),
                  PlinthStatTile(
                    label: l10n.completion,
                    value: l10n.percent(
                      (snap.weekStats.completion * 100).round(),
                    ),
                  ),
                ],
              ),
              const PlinthSpace(h: PlinthSize.lg),
              PlinthBarChart(
                label: l10n.thisWeek,
                emptyLabel: l10n.noHistory,
                bars: _weekBars(l10n, snap.sessions),
                describeValue: (value) => formatMinutesTotal(l10n, value.round()),
              ),
              const PlinthSpace(h: PlinthSize.lg),
              PlinthTitle(l10n.thisMonth, order: 3),
              const PlinthSpace(h: PlinthSize.sm),
              PlinthStatGrid(
                columns: 2,
                minColWidth: 140,
                tiles: [
                  PlinthStatTile(
                    label: l10n.workouts,
                    value: snap.monthStats.workouts.toString(),
                  ),
                  PlinthStatTile(
                    label: l10n.workoutTime,
                    value: formatMinutesTotal(l10n, snap.monthStats.minutes),
                  ),
                ],
              ),
              const PlinthSpace(h: PlinthSize.lg),
              if (snap.sessions.isEmpty)
                PlinthEmptyState(
                  icon: const Icon(Icons.history_outlined),
                  title: l10n.noHistory,
                )
              else
                for (final session in snap.sessions) ...[
                  _SessionTile(
                    session: session,
                    day: snap.dayTitles[session.programDayId],
                    notes: snap.notesBySessionId[session.id] ?? const [],
                    format: format,
                    locale: locale,
                    l10n: l10n,
                    onResume: _resumable(session.status)
                        ? () => startProgramDay(
                              context: context,
                              ref: ref,
                              dayId: session.programDayId,
                              resumeSessionId: session.id,
                            )
                        : null,
                  ),
                  const PlinthSpace(h: PlinthSize.sm),
                ],
            ],
          );
        },
      ),
    );
  }
}

bool _resumable(WorkoutStatus status) {
  return status == WorkoutStatus.started ||
      status == WorkoutStatus.partiallyCompleted;
}

List<double> _weekMinutes(List<WorkoutSession> sessions) {
  final now = DateTime.now();
  final start = DateTime(now.year, now.month, now.day)
      .subtract(Duration(days: now.weekday - 1));
  return [
    for (var i = 0; i < 7; i++)
      sessions
          .where((session) {
            final day = DateTime(
              session.startedAt.year,
              session.startedAt.month,
              session.startedAt.day,
            );
            return day == start.add(Duration(days: i));
          })
          .fold<double>(0, (sum, session) => sum + ((session.duration ?? 0) / 60)),
  ];
}

List<PlinthBar> _weekBars(AppLocalizations l10n, List<WorkoutSession> sessions) {
  final minutes = _weekMinutes(sessions);
  return [
    for (var i = 0; i < 7; i++)
      PlinthBar(
        label: weekdayLabel(l10n, i + 1),
        value: minutes[i],
      ),
  ];
}

class _SessionTile extends ConsumerWidget {
  const _SessionTile({
    required this.session,
    required this.day,
    required this.notes,
    required this.format,
    required this.locale,
    required this.l10n,
    this.onResume,
  });

  final WorkoutSession session;
  final ProgramDay? day;
  final List<HistoryExerciseNote> notes;
  final DateFormat format;
  final Locale locale;
  final AppLocalizations l10n;
  final VoidCallback? onResume;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final minutes = ((session.duration ?? 0) / 60).round();
    final sessionNote = session.notes?.trim();
    final hasSessionNote = sessionNote != null && sessionNote.isNotEmpty;
    final canAddSessionNote = !hasSessionNote &&
        (session.status == WorkoutStatus.completed ||
            session.status == WorkoutStatus.partiallyCompleted);
    final title = day == null
        ? l10n.todaysWorkout
        : localizedName(day!.title, locale);

    return PlinthCard(
      withBorder: true,
      header: PlinthText(title),
      footer: onResume != null
          ? PlinthButton(
              variant: PlinthVariant.light,
              onPressed: onResume,
              child: Text(l10n.resumeWorkout),
            )
          : PlinthText('$minutes ${l10n.minutesShort}', color: 'gray'),
      child: PlinthStack(
        gap: PlinthSize.xs,
        children: [
          PlinthText(
            '${format.format(session.startedAt)} · ${statusLabel(l10n, session.status)}',
            color: 'gray',
          ),
          if (hasSessionNote) PlinthText(sessionNote, color: 'gray'),
          for (final note in notes) ...[
            PlinthText(localizedName(note.exerciseName, locale), color: 'green'),
            PlinthText(note.note, color: 'gray'),
          ],
          if (canAddSessionNote)
            NoteComposer(
              onSave: (notes) async {
                await ref.read(repositoryProvider).saveSessionNotes(session.id, notes);
                await ref.read(authProvider.notifier).pushSession(session.id);
                ref.invalidate(historySnapshotProvider);
              },
            ),
        ],
      ),
    );
  }
}
