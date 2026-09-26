import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:plinth_blocks/plinth_blocks.dart';

import '../../l10n/app_localizations.dart';
import '../../core/l10n/labels.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/exercise_photo.dart';
import '../../core/widgets/gym_clock.dart';
import '../../core/widgets/language_toggle.dart';
import '../../core/widgets/note_composer.dart';
import '../../core/widgets/stayable_async.dart';
import '../../core/widgets/stayable_html.dart';
import '../../domain/domain.dart';
import '../auth/auth_controller.dart';
import '../providers.dart';
import 'workout_controller.dart';

class WorkoutScreen extends ConsumerWidget {
  const WorkoutScreen({super.key, required this.sessionId});

  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(workoutControllerProvider(sessionId));
    final l10n = AppLocalizations.of(context);

    return async.when(
      loading: () => StayAblePage(
        title: l10n.appTitle,
        body: const StayAbleLoading(),
      ),
      error: (e, _) => StayAblePage(
        title: l10n.appTitle,
        actions: const [LanguageToggle()],
        body: StayAbleError(message: e),
      ),
      data: (state) {
        final controller = ref.read(workoutControllerProvider(sessionId).notifier);

        void leaveWorkout() {
          ref.invalidate(homeSnapshotProvider);
          ref.invalidate(programSnapshotProvider);
          ref.invalidate(historySnapshotProvider);
          context.go('/program');
        }

        void onBack() {
          if (state.phase == WorkoutPhase.finished) {
            leaveWorkout();
            return;
          }
          if (state.phase != WorkoutPhase.picking) {
            controller.backToPicker();
            return;
          }
          leaveWorkout();
        }

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            onBack();
          },
          child: StayAblePage(
            title: localizedName(
              state.playback.day.title,
              Localizations.localeOf(context),
            ),
            leading: state.phase == WorkoutPhase.finished
                ? null
                : PlinthActionIcon(
                    semanticLabel:
                        MaterialLocalizations.of(context).backButtonTooltip,
                    icon: const Icon(Icons.arrow_back),
                    onPressed: onBack,
                  ),
            actions: [
              const LanguageToggle(),
              if (state.phase != WorkoutPhase.finished)
                PlinthButton(
                  variant: PlinthVariant.subtle,
                  onPressed: () async {
                    final leave = await _confirmEndWorkout(context, l10n);
                    if (leave && context.mounted) {
                      await ref
                          .read(workoutControllerProvider(sessionId).notifier)
                          .finishPartial();
                      if (context.mounted) context.go('/history');
                    }
                  },
                  child: Text(l10n.endWorkout),
                ),
            ],
            body: state.phase == WorkoutPhase.finished
                ? _Finished(l10n: l10n, sessionId: sessionId)
                : state.phase == WorkoutPhase.picking
                    ? _ExercisePicker(sessionId: sessionId, state: state)
                    : _Player(sessionId: sessionId, state: state),
          ),
        );
      },
    );
  }
}

class _Finished extends ConsumerStatefulWidget {
  const _Finished({required this.l10n, required this.sessionId});

  final AppLocalizations l10n;
  final String sessionId;

  @override
  ConsumerState<_Finished> createState() => _FinishedState();
}

class _FinishedState extends ConsumerState<_Finished> {
  String? _savedNote;

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    final sessionNote = _savedNote;
    final hasNote = sessionNote != null && sessionNote.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.all(PlinthSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: PlinthHeroBlock(
              headline: l10n.workoutComplete,
              subhead: hasNote ? sessionNote : null,
              headlineOrder: 2,
              padding: const EdgeInsets.all(PlinthSpacing.lg),
            ),
          ),
          if (!hasNote) ...[
            NoteComposer(
              onSave: (notes) async {
                final trimmed = notes.trim();
                await ref
                    .read(repositoryProvider)
                    .saveSessionNotes(widget.sessionId, trimmed);
                await ref
                    .read(authProvider.notifier)
                    .pushSession(widget.sessionId);
                ref.invalidate(historySnapshotProvider);
                if (mounted) setState(() => _savedNote = trimmed);
              },
            ),
            const PlinthSpace(h: PlinthSize.sm),
          ],
          PlinthButton(
            fullWidth: true,
            onPressed: () => context.go('/history'),
            child: Text(l10n.seeHistory),
          ),
        ],
      ),
    );
  }
}

class _ExercisePicker extends ConsumerWidget {
  const _ExercisePicker({required this.sessionId, required this.state});

  final String sessionId;
  final WorkoutViewState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final controller = ref.read(workoutControllerProvider(sessionId).notifier);
    final order = [
      for (var i = 0; i < state.playback.items.length; i++) i,
    ]..sort((a, b) {
        final gymA = state.playback.items[a].exercise.gymNumber ?? 100000;
        final gymB = state.playback.items[b].exercise.gymNumber ?? 100000;
        if (gymA != gymB) return gymA.compareTo(gymB);
        return a.compareTo(b);
      });

    return StayAbleScrollBody(
      children: [
        PlinthTitle(l10n.chooseExercise, order: 3),
        const PlinthSpace(h: PlinthSize.xs),
        PlinthText(
          l10n.exercisesDone(
            state.completedExerciseCount,
            state.playback.items.length,
          ),
          color: 'gray',
        ),
        const PlinthSpace(h: PlinthSize.sm),
        PlinthProgress(
          value: state.playback.items.isEmpty
              ? 0
              : (state.completedExerciseCount / state.playback.items.length)
                  .clamp(0.0, 1.0),
        ),
        const PlinthSpace(h: PlinthSize.md),
        for (final index in order) ...[
          _PickerTile(
            item: state.playback.items[index],
            result: state.playback.results[index],
            locale: locale,
            l10n: l10n,
            onTap: state.playback.results[index].completed
                ? null
                : () => controller.selectExercise(index),
          ),
          const PlinthSpace(h: PlinthSize.sm),
        ],
      ],
    );
  }
}

class _PickerTile extends StatelessWidget {
  const _PickerTile({
    required this.item,
    required this.result,
    required this.locale,
    required this.l10n,
    this.onTap,
  });

  final ProgramExerciseItem item;
  final WorkoutExerciseResult result;
  final Locale locale;
  final AppLocalizations l10n;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final done = result.completed;
    return Opacity(
      opacity: done ? 0.55 : 1,
      child: PlinthArticleCard(
        title: localizedName(item.exercise.name, locale),
        excerpt: [
          if (item.exercise.gymNumber != null)
            l10n.gymStation(item.exercise.gymNumber!),
          prescriptionLabel(l10n, item.assignment),
        ].join(' · '),
        layout: PlinthArticleLayout.horizontal,
        imageWidth: 64,
        category: done ? PlinthBadge(l10n.completed, color: 'green') : null,
        image: ExercisePhoto(
          photo: item.exercise.photo,
          category: item.exercise.category,
          height: 64,
        ),
        onTap: onTap,
      ),
    );
  }
}

class _Player extends ConsumerWidget {
  const _Player({required this.sessionId, required this.state});

  final String sessionId;
  final WorkoutViewState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final item = state.currentItem;
    final controller = ref.read(workoutControllerProvider(sessionId).notifier);
    final progress = state.freeOrder
        ? state.completedExerciseCount / state.playback.items.length
        : (state.exerciseIndex + (state.phase == WorkoutPhase.effort ? 1 : 0)) /
            state.playback.items.length;

    final description = localizedName(item.exercise.description, locale);
    final instructions = localizedName(item.exercise.instructions, locale);

    return Padding(
      padding: StayAbleScrollBody.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PlinthText(
            state.freeOrder
                ? l10n.exercisesDone(
                    state.completedExerciseCount,
                    state.playback.items.length,
                  )
                : l10n.exerciseProgress(
                    state.exerciseIndex + 1,
                    state.playback.items.length,
                  ),
            color: 'gray',
          ),
          const PlinthSpace(h: PlinthSize.sm),
          PlinthProgress(
            value: progress.clamp(0.0, 1.0),
            color: state.phase == WorkoutPhase.rest ? 'yellow' : 'green',
          ),
          const PlinthSpace(h: PlinthSize.md),
          Expanded(
            child: SingleChildScrollView(
              child: PlinthStack(
                children: [
                  ExercisePhoto(
                    photo: item.exercise.photo,
                    category: item.exercise.category,
                    height: 160,
                  ),
                  PlinthTitle(
                    localizedName(item.exercise.name, locale),
                    order: 2,
                    textAlign: TextAlign.center,
                  ),
                  PlinthText(
                    prescriptionLabel(l10n, item.assignment),
                    color: 'gray',
                    textAlign: TextAlign.center,
                  ),
                  if (description.isNotEmpty) ...[
                    PlinthTitle(l10n.description, order: 4),
                    PlinthText(description),
                  ],
                  if (instructions.trim().isNotEmpty) ...[
                    PlinthTitle(l10n.howToPerform, order: 4),
                    StayAbleInstructions(text: instructions),
                  ],
                ],
              ),
            ),
          ),
          const PlinthSpace(h: PlinthSize.sm),
          _PhaseBody(
            state: state,
            l10n: l10n,
            controller: controller,
          ),
        ],
      ),
    );
  }
}

class _PhaseBody extends StatelessWidget {
  const _PhaseBody({
    required this.state,
    required this.l10n,
    required this.controller,
  });

  final WorkoutViewState state;
  final AppLocalizations l10n;
  final WorkoutController controller;

  @override
  Widget build(BuildContext context) {
    switch (state.phase) {
      case WorkoutPhase.picking:
        return const SizedBox.shrink();
      case WorkoutPhase.ready:
        return PlinthStack(
          children: [
            if (state.currentSets.length > 1)
              PlinthText(
                l10n.setNumber(state.setIndex + 1),
                textAlign: TextAlign.center,
              ),
            PlinthButton(
              fullWidth: true,
              onPressed: controller.start,
              child: Text(l10n.start),
            ),
            PlinthButton(
              fullWidth: true,
              variant: PlinthVariant.subtle,
              onPressed: controller.backToPicker,
              child: Text(l10n.chooseAnother),
            ),
          ],
        );
      case WorkoutPhase.timed:
        return PlinthStack(
          children: [
            Center(child: GymClock(formatDurationClock(state.remainingSeconds))),
            PlinthProgress(
              value: (1 -
                      (state.remainingSeconds /
                          (state.plannedSeconds == 0
                              ? 1
                              : state.plannedSeconds)))
                  .clamp(0.0, 1.0),
            ),
            PlinthButton(
              fullWidth: true,
              onPressed: () => controller.completeTimedSet(),
              child: Text(l10n.done),
            ),
          ],
        );
      case WorkoutPhase.loggingSet:
        return PlinthStack(
          children: [
            PlinthText(
              l10n.setNumber(state.setIndex + 1),
              textAlign: TextAlign.center,
            ),
            PlinthNumberInput(
              value: state.loggedReps,
              min: 0,
              step: 1,
              label: l10n.reps,
              onChanged: (value) => controller.setReps(value.round()),
            ),
            if (state.currentItem.assignment.loadKg != null)
              PlinthNumberInput(
                value: state.loggedLoadKg,
                min: 0,
                step: 2.5,
                label: '${l10n.load} (${l10n.kg})',
                onChanged: (value) => controller.setLoad(value.toDouble()),
              ),
            PlinthButton(
              fullWidth: true,
              onPressed: controller.logRepSet,
              child: Text(
                state.isLastSet ? l10n.confirmSet : l10n.nextSet,
              ),
            ),
          ],
        );
      case WorkoutPhase.rest:
        return PlinthStack(
          children: [
            PlinthText(l10n.rest, color: 'yellow', textAlign: TextAlign.center),
            Center(
              child: GymClock(
                formatDurationClock(state.remainingSeconds),
                color: AppColors.restAmber,
              ),
            ),
            PlinthButton(
              fullWidth: true,
              variant: PlinthVariant.outline,
              onPressed: controller.skipRest,
              child: Text(l10n.continueLabel),
            ),
          ],
        );
      case WorkoutPhase.effort:
        return PlinthStack(
          children: [
            PlinthTitle(
              l10n.howDidYouDo,
              order: 3,
              textAlign: TextAlign.center,
            ),
            for (final effort in PerceivedEffort.values)
              PlinthChip(
                label: switch (effort) {
                  PerceivedEffort.easy => l10n.effortEasy,
                  PerceivedEffort.good => l10n.effortGood,
                  PerceivedEffort.difficult => l10n.effortDifficult,
                },
                selected: state.selectedEffort == effort,
                onSelected: (_) => controller.selectEffort(effort),
              ),
            _EndExerciseActions(
              l10n: l10n,
              canComplete: state.selectedEffort != null,
              onComplete: controller.confirmEffort,
            ),
          ],
        );
      case WorkoutPhase.finished:
        return const SizedBox.shrink();
    }
  }
}

class _EndExerciseActions extends StatefulWidget {
  const _EndExerciseActions({
    required this.l10n,
    required this.canComplete,
    required this.onComplete,
  });

  final AppLocalizations l10n;
  final bool canComplete;
  final Future<void> Function({String? notes}) onComplete;

  @override
  State<_EndExerciseActions> createState() => _EndExerciseActionsState();
}

class _EndExerciseActionsState extends State<_EndExerciseActions> {
  bool _addingNote = false;
  late final TextEditingController _note;

  @override
  void initState() {
    super.initState();
    _note = TextEditingController();
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_addingNote) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PlinthTextarea(
            controller: _note,
            placeholder: widget.l10n.exerciseNoteHint,
            minLines: 2,
            maxLines: 4,
          ),
          PlinthButton(
            fullWidth: true,
            onPressed: widget.canComplete
                ? () => widget.onComplete(notes: _note.text)
                : null,
            child: Text(widget.l10n.completed),
          ),
        ],
      );
    }

    return PlinthGroup(
      wrap: false,
      grow: true,
      children: [
        PlinthButton(
          onPressed: widget.canComplete ? () => widget.onComplete() : null,
          child: Text(widget.l10n.completeExercise),
        ),
        PlinthButton(
          variant: PlinthVariant.outline,
          onPressed: () => setState(() => _addingNote = true),
          child: Text(widget.l10n.addNote),
        ),
      ],
    );
  }
}

Future<bool> _confirmEndWorkout(
  BuildContext context,
  AppLocalizations l10n,
) async {
  final controller = PlinthDisclosureController();
  var confirmed = false;
  await PlinthModal(
    controller: controller,
    title: l10n.exitWorkoutTitle,
    size: PlinthSize.sm,
    child: Builder(
      builder: (modalContext) {
        return PlinthStack(
          children: [
            PlinthText(l10n.exitWorkoutBody),
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
                  child: Text(l10n.savePartial),
                ),
              ],
            ),
          ],
        );
      },
    ),
  ).show(context);
  controller.dispose();
  return confirmed;
}

