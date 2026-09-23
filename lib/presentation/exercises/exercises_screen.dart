import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:plinth_blocks/plinth_blocks.dart';

import '../../l10n/app_localizations.dart';
import '../../core/l10n/labels.dart';
import '../../core/widgets/exercise_photo.dart';
import '../../core/widgets/language_toggle.dart';
import '../../core/widgets/stayable_async.dart';
import '../../domain/domain.dart';
import '../providers.dart';

class ExercisesScreen extends ConsumerWidget {
  const ExercisesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final filter = ref.watch(exerciseFilterProvider);
    final async = ref.watch(filteredExercisesProvider);

    return StayAblePage(
      title: l10n.exercisesLabel,
      actions: const [LanguageToggle()],
      below: PlinthStack(
        gap: PlinthSize.sm,
        children: [
          PlinthTextInput(
            placeholder: l10n.search,
            leadingIcon: const Icon(Icons.search, size: 18),
            onChanged: (value) =>
                ref.read(exerciseFilterProvider.notifier).setQuery(value),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: PlinthGroup(
              children: [
                PlinthChip(
                  label: l10n.categoryAll,
                  selected: filter.category == null,
                  onSelected: (_) =>
                      ref.read(exerciseFilterProvider.notifier).setCategory(null),
                ),
                for (final category in ExerciseCategory.values)
                  PlinthChip(
                    label: categoryLabel(l10n, category),
                    selected: filter.category == category,
                    onSelected: (_) => ref
                        .read(exerciseFilterProvider.notifier)
                        .setCategory(category),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: async.when(
        loading: () => const StayAbleLoading(),
        error: (e, _) => StayAbleError(message: e),
        data: (items) {
          if (items.isEmpty) {
            return PlinthEmptyState(
              icon: const Icon(Icons.fitness_center_outlined),
              title: l10n.noExercises,
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(
              PlinthSpacing.lg,
              PlinthSpacing.sm,
              PlinthSpacing.lg,
              PlinthSpacing.xl,
            ),
            itemCount: items.length,
            separatorBuilder: (context, index) =>
                const PlinthSpace(h: PlinthSize.sm),
            itemBuilder: (context, index) {
              final exercise = items[index];
              return PlinthArticleCard(
                title: localizedName(exercise.name, locale),
                excerpt: [
                  if (exercise.gymNumber != null)
                    l10n.gymStation(exercise.gymNumber!),
                  categoryLabel(l10n, exercise.category),
                  difficultyLabel(l10n, exercise.difficulty),
                ].join(' · '),
                layout: PlinthArticleLayout.horizontal,
                image: ExercisePhoto(
                  photo: exercise.photo,
                  category: exercise.category,
                  height: 96,
                ),
                onTap: () => context.push('/exercises/${exercise.id}'),
              );
            },
          );
        },
      ),
    );
  }
}
