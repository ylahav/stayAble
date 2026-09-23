import 'package:flutter/material.dart';
import 'package:plinth_blocks/plinth_blocks.dart';

import '../../l10n/app_localizations.dart';
import '../../core/l10n/labels.dart';
import '../../core/widgets/exercise_photo.dart';
import '../../core/widgets/language_toggle.dart';
import '../../domain/domain.dart';

Future<void> showExercisePreview({
  required BuildContext context,
  required ProgramExerciseItem item,
}) {
  final locale = Localizations.localeOf(context);
  final controller = PlinthDisclosureController();
  return PlinthModal(
    controller: controller,
    title: localizedName(item.exercise.name, locale),
    size: PlinthSize.lg,
    child: ExercisePreviewSheet(item: item),
  ).show(context).whenComplete(controller.dispose);
}

class ExercisePreviewSheet extends StatelessWidget {
  const ExercisePreviewSheet({super.key, required this.item});

  final ProgramExerciseItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final exercise = item.exercise;
    final description = localizedName(exercise.description, locale);
    final steps = localizedName(exercise.instructions, locale)
        .split('\n')
        .where((s) => s.trim().isNotEmpty)
        .toList();

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.72,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Align(
            alignment: AlignmentDirectional.centerEnd,
            child: LanguageToggle(),
          ),
          Flexible(
            child: SingleChildScrollView(
              child: PlinthStack(
                children: [
                  ExercisePhoto(
                    photo: exercise.photo,
                    category: exercise.category,
                    height: 180,
                  ),
                  PlinthText(
                    prescriptionLabel(l10n, item.assignment),
                    color: 'gray',
                  ),
                  if (description.isNotEmpty) ...[
                    PlinthTitle(l10n.description, order: 5),
                    PlinthText(description),
                  ],
                  if (steps.isNotEmpty) ...[
                    PlinthTitle(l10n.howToPerform, order: 5),
                    PlinthList(
                      type: PlinthListType.ordered,
                      items: [
                        for (final step in steps) PlinthListItem(Text(step)),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          const PlinthSpace(h: PlinthSize.md),
          PlinthButton(
            fullWidth: true,
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }
}
