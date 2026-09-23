import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plinth_blocks/plinth_blocks.dart';

import '../../l10n/app_localizations.dart';
import '../../core/l10n/labels.dart';
import '../../core/widgets/exercise_photo.dart';
import '../../core/widgets/language_toggle.dart';
import '../../core/widgets/stayable_async.dart';
import '../providers.dart';

class ExerciseDetailsScreen extends ConsumerWidget {
  const ExerciseDetailsScreen({super.key, required this.exerciseId});

  final String exerciseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final async = ref.watch(exerciseByIdProvider(exerciseId));

    return StayAblePage(
      title: l10n.exercisesLabel,
      actions: const [LanguageToggle()],
      body: async.when(
        loading: () => const StayAbleLoading(),
        error: (e, _) => StayAbleError(message: e),
        data: (exercise) {
          if (exercise == null) {
            return PlinthEmptyState(title: l10n.noExercises);
          }
          final steps = localizedName(exercise.instructions, locale)
              .split('\n')
              .where((s) => s.trim().isNotEmpty)
              .toList();
          return ListView(
            padding: const EdgeInsets.fromLTRB(
              PlinthSpacing.lg,
              PlinthSpacing.sm,
              PlinthSpacing.lg,
              PlinthSpacing.xl,
            ),
            children: [
              ExercisePhoto(
                photo: exercise.photo,
                category: exercise.category,
                height: 240,
              ),
              const PlinthSpace(h: PlinthSize.md),
              PlinthTitle(localizedName(exercise.name, locale), order: 2),
              const PlinthSpace(h: PlinthSize.xs),
              PlinthText(
                [
                  difficultyLabel(l10n, exercise.difficulty),
                  venueLabel(l10n, exercise.venue),
                  if (exercise.gymNumber != null)
                    l10n.gymStation(exercise.gymNumber!),
                ].join(' · '),
                color: 'gray',
              ),
              const PlinthSpace(h: PlinthSize.md),
              PlinthTitle(l10n.description, order: 4),
              const PlinthSpace(h: PlinthSize.xs),
              PlinthText(localizedName(exercise.description, locale)),
              const PlinthSpace(h: PlinthSize.md),
              PlinthTitle(l10n.howToPerform, order: 4),
              const PlinthSpace(h: PlinthSize.xs),
              PlinthList(
                type: PlinthListType.ordered,
                items: [
                  for (final step in steps) PlinthListItem(Text(step)),
                ],
              ),
              const PlinthSpace(h: PlinthSize.md),
              PlinthTitle(l10n.targetMuscles, order: 4),
              const PlinthSpace(h: PlinthSize.xs),
              PlinthGroup(
                children: [
                  for (final muscle in exercise.targetMuscles)
                    PlinthBadge(muscleLabel(l10n, muscle)),
                ],
              ),
              const PlinthSpace(h: PlinthSize.md),
              PlinthTitle(l10n.equipment, order: 4),
              const PlinthSpace(h: PlinthSize.xs),
              PlinthText(equipmentLabel(l10n, exercise.equipment)),
              const PlinthSpace(h: PlinthSize.md),
              PlinthTitle(l10n.safetyNotes, order: 4),
              const PlinthSpace(h: PlinthSize.xs),
              PlinthText(localizedName(exercise.safetyNotes, locale)),
            ],
          );
        },
      ),
    );
  }
}
