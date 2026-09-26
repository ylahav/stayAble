import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:plinth_blocks/plinth_blocks.dart';

import '../../l10n/app_localizations.dart';
import '../../core/l10n/labels.dart';
import '../../core/widgets/app_version_label.dart';
import '../../core/widgets/stayable_async.dart';
import '../../data/remote/catalog_check.dart';
import '../../domain/domain.dart';
import '../auth/auth_controller.dart';
import '../profile/birthday_prompt.dart';
import '../providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(homeSnapshotProvider);
    return StayAblePage(
      title: greeting(l10n, DateTime.now()),
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
    final catalogUpdate = ref.watch(catalogUpdateProvider);
    final extras = snapshot.todayWorkouts.length > 1
        ? snapshot.todayWorkouts.sublist(1)
        : const <TodayWorkout>[];

    return StayAbleScrollBody(
      children: [
        if (catalogUpdate.available) ...[
          _CatalogUpdateCard(update: catalogUpdate),
          const PlinthSpace(h: PlinthSize.md),
        ],
        if (snapshot.hasInProgress) ...[
          _ContinueCard(info: snapshot.inProgress!),
          const PlinthSpace(h: PlinthSize.md),
        ],
        PlinthPaper(
          withBorder: true,
          p: PlinthSize.lg,
          child: snapshot.isRestDay
              ? PlinthHeroBlock(
                  layout: PlinthHeroLayout.split,
                  eyebrow: PlinthBadge(l10n.restDay, color: 'yellow'),
                  headline: l10n.restDay,
                  subhead: l10n.restDayMessage,
                  headlineOrder: 2,
                  actions: [
                    PlinthButton(
                      onPressed: () => context.go('/program'),
                      child: Text(l10n.viewProgram),
                    ),
                  ],
                  footer: _WeekStrip(snapshot: snapshot, l10n: l10n),
                )
              : snapshot.todayWorkouts.isEmpty
                  ? PlinthHeroBlock(
                      layout: PlinthHeroLayout.split,
                      eyebrow: PlinthBadge(l10n.todaysWorkout, color: 'green'),
                      headline: l10n.todaysWorkout,
                      subhead: l10n.noProgramAssigned,
                      headlineOrder: 2,
                      actions: [
                        PlinthButton(
                          variant: PlinthVariant.outline,
                          onPressed: () => context.go('/program'),
                          child: Text(l10n.viewProgram),
                        ),
                      ],
                      footer: _WeekStrip(snapshot: snapshot, l10n: l10n),
                    )
                  : _TodayHero(
                      l10n: l10n,
                      locale: locale,
                      workout: snapshot.todayWorkouts.first,
                      showPrimaryAction: inProgressId == null ||
                          inProgressId !=
                              snapshot.todayWorkouts.first.session?.id,
                      week: _WeekStrip(snapshot: snapshot, l10n: l10n),
                      onStart: () => startProgramDay(
                        context: context,
                        ref: ref,
                        dayId: snapshot.todayWorkouts.first.day.id,
                      ),
                    ),
        ),
        for (final workout in extras) ...[
          const PlinthSpace(h: PlinthSize.md),
          _TodayCard(
            l10n: l10n,
            locale: locale,
            workout: workout,
            showPrimaryAction: inProgressId == null ||
                inProgressId != workout.session?.id,
            onStart: () => startProgramDay(
              context: context,
              ref: ref,
              dayId: workout.day.id,
            ),
          ),
        ],
        const AppVersionLabel(),
      ],
    );
  }
}

class _WeekStrip extends StatelessWidget {
  const _WeekStrip({required this.snapshot, required this.l10n});

  final HomeSnapshot snapshot;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return PlinthStatStrip(
      divider: true,
      stats: [
        PlinthStat(
          value: snapshot.weekStats.workouts.toString(),
          label: l10n.workouts,
        ),
        PlinthStat(
          value: '${snapshot.weekStats.minutes}',
          label: l10n.minutesShort,
        ),
        PlinthStat(
          value: l10n.percent((snapshot.weekStats.completion * 100).round()),
          label: l10n.completion,
        ),
      ],
    );
  }
}

class _TodayHero extends StatelessWidget {
  const _TodayHero({
    required this.l10n,
    required this.locale,
    required this.workout,
    required this.showPrimaryAction,
    required this.week,
    required this.onStart,
  });

  final AppLocalizations l10n;
  final Locale locale;
  final TodayWorkout workout;
  final bool showPrimaryAction;
  final Widget week;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final session = workout.session;
    final completed = session?.status == WorkoutStatus.completed;
    final started = session?.status == WorkoutStatus.started;
    final minutes = workout.exercises.isEmpty
        ? 0
        : (estimatedWorkoutSeconds(
                workout.exercises.map((e) => e.assignment),
              ) /
              60)
            .round();
    final venue = programVenueLabel(l10n, workout.program.venue);
    final action = started
        ? l10n.resumeWorkout
        : completed
            ? l10n.startAgain
            : l10n.startWorkout;

    return PlinthHeroBlock(
      layout: PlinthHeroLayout.split,
      eyebrow: PlinthBadge(l10n.todaysWorkout, color: 'green'),
      headline: localizedName(workout.day.title, locale),
      subhead: [
        workout.program.name,
        venue,
        '$minutes ${l10n.minutes}',
        l10n.exerciseCount(workout.exercises.length),
        if (completed) l10n.alreadyCompletedToday,
      ].join(' · '),
      headlineOrder: 2,
      actions: [
        if (showPrimaryAction)
          PlinthButton(
            onPressed: onStart,
            child: Text(action),
          ),
      ],
      footer: week,
    );
  }
}

class _CatalogUpdateCard extends ConsumerWidget {
  const _CatalogUpdateCard({required this.update});

  final CatalogUpdate update;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return PlinthBannerBlock(
      width: null,
      color: 'green',
      layout: PlinthBannerLayout.notice,
      title: l10n.catalogUpdateBadge,
      message: update.newCount > 0
          ? l10n.catalogUpdateAvailable(update.newCount)
          : l10n.catalogUpdateChanged,
      actions: [
        PlinthAsyncButton(
          onPressed: () => ref.read(authProvider.notifier).refreshCatalog(),
          doneLabel: l10n.catalogRefreshed,
          child: Text(l10n.catalogSyncNow),
        ),
        PlinthButton(
          variant: PlinthVariant.outline,
          onPressed: () => ref.read(authProvider.notifier).dismissCatalogUpdate(),
          child: Text(l10n.catalogUpdateLater),
        ),
      ],
      onClose: () => ref.read(authProvider.notifier).dismissCatalogUpdate(),
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
        onPressed: () => startProgramDay(
          context: context,
          ref: ref,
          dayId: info.day.id,
          resumeSessionId: info.session.id,
        ),
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
