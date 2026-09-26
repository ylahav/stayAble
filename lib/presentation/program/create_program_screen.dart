import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:plinth_blocks/plinth_blocks.dart';

import '../../core/widgets/stayable_async.dart';
import '../../l10n/app_localizations.dart';

class CreateProgramScreen extends ConsumerWidget {
  const CreateProgramScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return StayAblePage(
      title: l10n.createProgram,
      leading: PlinthActionIcon(
        semanticLabel: MaterialLocalizations.of(context).backButtonTooltip,
        icon: const Icon(Icons.arrow_back),
        onPressed: () => context.pop(),
      ),
      body: StayAbleScrollBody(
        children: [
          PlinthText(l10n.createProgramHow, color: 'gray'),
          const PlinthSpace(h: PlinthSize.md),
          StayAbleChoiceCard(
            title: l10n.createProgramManualTitle,
            lead: l10n.createProgramManualLead,
            action: PlinthButton(
              fullWidth: true,
              onPressed: () => context.push('/program/edit'),
              child: Text(l10n.createProgramManualAction),
            ),
          ),
          const PlinthSpace(h: PlinthSize.md),
          StayAbleChoiceCard(
            title: l10n.createProgramWizardTitle,
            lead: l10n.createProgramWizardLead,
            action: PlinthButton(
              fullWidth: true,
              variant: PlinthVariant.outline,
              onPressed: () => context.push('/program/wizard'),
              child: Text(l10n.createProgramWizardAction),
            ),
          ),
        ],
      ),
    );
  }
}
