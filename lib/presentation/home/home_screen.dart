import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:plinth_blocks/plinth_blocks.dart';

import '../../l10n/app_localizations.dart';
import '../../core/l10n/labels.dart';
import '../../core/widgets/app_version_label.dart';
import '../../core/widgets/language_toggle.dart';
import '../../core/widgets/stayable_async.dart';
import '../../domain/domain.dart';
import '../auth/auth_controller.dart';
import '../providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(homeSnapshotProvider);
    return StayAblePage(
      title: l10n.appTitle,
      subtitle: greeting(l10n, DateTime.now()),
      actions: [
        const LanguageToggle(),
        PlinthActionIcon(
          semanticLabel: l10n.settingsTitle,
          icon: const Icon(Icons.settings_outlined),
          onPressed: () => context.push('/settings'),
        ),
        PlinthActionIcon(
          semanticLabel: l10n.logOut,
          icon: const Icon(Icons.logout),
          onPressed: () => ref.read(authProvider.notifier).logout(),
        ),
      ],
      body: async.when(
        loading: () => const StayAbleLoading(),
        error: (e, _) => StayAbleError(message: e),
        data: (snap) => _HomeBody(snapshot: snap),
      ),
    );
  }
}

class _HomeBody extends ConsumerWidget {
  const _HomeBody({required this.snapshot});

  final HomeSnapshot snapshot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final inProgressId = snapshot.inProgress?.session.id;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        PlinthSpacing.lg,
        PlinthSpacing.sm,
        PlinthSpacing.lg,
        PlinthSpacing.xl,
      ),
      children: [
        if (snapshot.hasInProgress) _ContinueCard(info: snapshot.inProgress!),
        if (snapshot.hasInProgress) const PlinthSpace(h: PlinthSize.md),
        if (snapshot.isRestDay)
          PlinthHeroBlock(
            headline: l10n.restDay,
            subhead: l10n.restDayMessage,
            headlineOrder: 3,
            padding: const EdgeInsets.all(PlinthSpacing.lg),
            actions: [
              PlinthButton(
                variant: PlinthVariant.outline,
                onPressed: () => context.go('/program'),
                child: Text(l10n.viewProgram),
              ),
            ],
          )
        else
          for (var i = 0; i < snapshot.todayWorkouts.length; i++) ...[
            if (i > 0) const PlinthSpace(h: PlinthSize.md),
            _TodayCard(
              l10n: l10n,
              locale: locale,
              workout: snapshot.todayWorkouts[i],
              showPrimaryAction: inProgressId == null ||
                  inProgressId != snapshot.todayWorkouts[i].session?.id,
              onStart: () async {
                final session = await ref
                    .read(repositoryProvider)
                    .startOrResumeSession(snapshot.todayWorkouts[i].day.id);
                if (!context.mounted) return;
                ref.invalidate(homeSnapshotProvider);
                context.push('/workout/${session.id}');
              },
            ),
          ],
        const PlinthSpace(h: PlinthSize.lg),
        PlinthTitle(l10n.thisWeek, order: 3),
        const PlinthSpace(h: PlinthSize.sm),
        PlinthStatGrid(
          columns: 3,
          minColWidth: 96,
          tiles: [
            PlinthStatTile(
              label: l10n.workouts,
              value: snapshot.weekStats.workouts.toString(),
            ),
            PlinthStatTile(
              label: l10n.minutesShort,
              value: '${snapshot.weekStats.minutes}',
            ),
            PlinthStatTile(
              label: l10n.completion,
              value: l10n.percent((snapshot.weekStats.completion * 100).round()),
            ),
          ],
        ),
        const AppVersionLabel(),
      ],
    );
  }
}

class _ContinueCard extends ConsumerWidget {
  const _ContinueCard({required this.info});

  final InProgressInfo info;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final current = info.completedExercises + 1;
    final progressIndex =
        current > info.totalExercises ? info.totalExercises : current;

    return PlinthCard(
      withBorder: true,
      header: PlinthBadge(l10n.inProgress, color: 'green'),
      footer: PlinthButton(
        fullWidth: true,
        onPressed: () async {
          final session =
              await ref.read(repositoryProvider).resumeSession(info.session.id);
          if (!context.mounted) return;
          ref.invalidate(homeSnapshotProvider);
          ref.invalidate(programSnapshotProvider);
          ref.invalidate(historySnapshotProvider);
          context.push('/workout/${session.id}');
        },
        child: Text(l10n.resumeWorkout),
      ),
      child: PlinthStack(
        gap: PlinthSize.xs,
        children: [
          PlinthTitle(localizedName(info.day.title, locale), order: 3),
          PlinthText(
            l10n.exerciseProgress(progressIndex, info.totalExercises),
            color: 'gray',
          ),
          PlinthProgress(
            value: info.totalExercises == 0
                ? 0
                : (progressIndex / info.totalExercises).clamp(0.0, 1.0),
          ),
        ],
      ),
    );
  }
}

class _TodayCard extends StatelessWidget {
  const _TodayCard({
    required this.l10n,
    required this.locale,
    required this.workout,
    required this.showPrimaryAction,
    required this.onStart,
  });

  final AppLocalizations l10n;
  final Locale locale;
  final TodayWorkout workout;
  final bool showPrimaryAction;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final session = workout.session;
    final completed = session?.status == WorkoutStatus.completed;
    final started = session?.status == WorkoutStatus.started;
    final title = localizedName(workout.day.title, locale);
    final minutes = workout.exercises.isEmpty
        ? 0
        : (estimatedWorkoutSeconds(
                workout.exercises.map((e) => e.assignment),
              ) /
              60)
            .round();
    final venue = programVenueLabel(l10n, workout.program.venue);

    return PlinthCard(
      withBorder: true,
      header: PlinthText('${workout.program.name} · $venue', color: 'gray'),
      footer: showPrimaryAction
          ? PlinthButton(
              fullWidth: true,
              onPressed: onStart,
              child: Text(
                started
                    ? l10n.resumeWorkout
                    : completed
                        ? l10n.startAgain
                        : l10n.startWorkout,
              ),
            )
          : null,
      child: PlinthStack(
        gap: PlinthSize.xs,
        children: [
          PlinthTitle(title, order: 3),
          PlinthText('$minutes ${l10n.minutes}'),
          PlinthText(l10n.exerciseCount(workout.exercises.length), color: 'gray'),
          if (completed)
            PlinthText(l10n.alreadyCompletedToday, color: 'green'),
        ],
      ),
    );
  }
}
