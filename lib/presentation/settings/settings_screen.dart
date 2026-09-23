import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:plinth_blocks/plinth_blocks.dart';

import '../../domain/entities/auth_session.dart';
import '../../l10n/app_localizations.dart';
import '../../core/widgets/language_toggle.dart';
import '../../core/widgets/stayable_async.dart';
import '../auth/auth_controller.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _url = TextEditingController();
  var _seeded = false;
  String? _error;
  String? _saved;

  @override
  void dispose() {
    _url.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _error = null;
      _saved = null;
    });
    try {
      await ref.read(backendUrlProvider.notifier).save(_url.text);
      if (!mounted) return;
      setState(() => _saved = l10n.serverSaved);
    } on AuthException catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.failure == AuthFailure.invalidServer
            ? l10n.loginErrorServer
            : (error.detail ?? l10n.loginErrorUnknown);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final url = ref.watch(backendUrlProvider);
    if (!_seeded && url.hasValue) {
      _url.text = url.requireValue;
      _seeded = true;
    }

    return StayAblePage(
      title: l10n.settingsTitle,
      leading: PlinthActionIcon(
        semanticLabel: MaterialLocalizations.of(context).backButtonTooltip,
        icon: const Icon(Icons.arrow_back),
        onPressed: () => context.pop(),
      ),
      actions: const [LanguageToggle()],
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          PlinthSpacing.lg,
          PlinthSpacing.md,
          PlinthSpacing.lg,
          PlinthSpacing.xl,
        ),
        children: [
          PlinthAuthCard(
            title: l10n.serverUrl,
            subtitle: l10n.serverUrlHint,
            width: null,
            fields: [
              if (_error != null)
                PlinthAlert(color: 'red', child: Text(_error!)),
              if (_saved != null)
                PlinthAlert(color: 'green', child: Text(_saved!)),
              PlinthTextInput(
                controller: _url,
                label: l10n.serverUrl,
                placeholder: 'https://gym.example.com',
                keyboardType: TextInputType.url,
              ),
            ],
            action: PlinthAsyncButton(
              fullWidth: true,
              onPressed: _save,
              doneLabel: l10n.serverSaved,
              child: Text(l10n.serverSave),
            ),
          ),
        ],
      ),
    );
  }
}
