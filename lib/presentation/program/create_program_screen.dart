import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:plinth_blocks/plinth_blocks.dart';

import '../../core/widgets/language_toggle.dart';
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
      actions: const [LanguageToggle()],
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          PlinthSpacing.lg,
          PlinthSpacing.sm,
          PlinthSpacing.lg,
          PlinthSpacing.xl,
        ),
        children: [
          PlinthText(l10n.createProgramHow, color: 'gray'),
          const PlinthSpace(h: PlinthSize.md),
          PlinthCard(
            withBorder: true,
            header: PlinthTitle(l10n.createProgramManualTitle, order: 3),
            footer: PlinthButton(
              fullWidth: true,
              onPressed: () => context.push('/program/edit'),
              child: Text(l10n.createProgramManualAction),
            ),
            child: PlinthText(l10n.createProgramManualLead, color: 'gray'),
          ),
          const PlinthSpace(h: PlinthSize.md),
          PlinthCard(
            withBorder: true,
            header: PlinthTitle(l10n.createProgramWizardTitle, order: 3),
            footer: PlinthButton(
              fullWidth: true,
              variant: PlinthVariant.outline,
              onPressed: () => context.push('/program/wizard'),
              child: Text(l10n.createProgramWizardAction),
            ),
            child: PlinthText(l10n.createProgramWizardLead, color: 'gray'),
          ),
        ],
      ),
    );
  }
}
