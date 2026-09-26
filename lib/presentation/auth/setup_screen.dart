import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plinth_blocks/plinth_blocks.dart';

import '../../core/ui/stayable_ui.dart';
import '../../core/widgets/app_version_label.dart';
import '../../core/widgets/language_toggle.dart';
import '../../data/remote/session_store.dart';
import '../../domain/entities/auth_session.dart';
import '../../l10n/app_localizations.dart';
import '../providers.dart';
import 'auth_controller.dart';

enum _SetupPath { choose, network, localLogin }

class SetupScreen extends ConsumerStatefulWidget {
  const SetupScreen({super.key});

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen> {
  final _server = TextEditingController();
  var _seeded = false;
  var _openedPendingLocalLogin = false;
  var _path = _SetupPath.choose;
  String? _error;

  @override
  void dispose() {
    _server.dispose();
    super.dispose();
  }

  Future<void> _backToChoices() async {
    _openedPendingLocalLogin = true;
    await ref.read(authProvider.notifier).returnToSetupChoices();
    if (!mounted) return;
    setState(() {
      _path = _SetupPath.choose;
      _error = null;
    });
  }

  Future<void> _chooseStandalone() async {
    setState(() {
      _error = null;
      _path = _SetupPath.localLogin;
    });
  }

  Future<void> _chooseLocalWithoutLogin() async {
    setState(() => _error = null);
    try {
      await ref.read(authProvider.notifier).enterLocal(
            language: ref.read(localeProvider).languageCode,
          );
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = AppLocalizations.of(context).loginErrorUnknown);
    }
  }

  Future<void> _chooseLocalWithLogin() async {
    setState(() => _error = null);
    try {
      await ref.read(authProvider.notifier).beginLocalLogin();
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = AppLocalizations.of(context).loginErrorUnknown);
    }
  }

  Future<void> _saveNetwork() async {
    final l10n = AppLocalizations.of(context);
    final server = _server.text.trim();
    if (server.isEmpty) {
      setState(() => _error = l10n.serverUrlRequired);
      return;
    }
    setState(() => _error = null);
    try {
      await ref.read(authProvider.notifier).completeCloudSetup(server);
    } on AuthException catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.failure == AuthFailure.invalidServer
            ? l10n.loginErrorServer
            : (error.detail ?? l10n.loginErrorUnknown);
      });
    } on FormatException {
      if (!mounted) return;
      setState(() => _error = AppLocalizations.of(context).loginErrorServer);
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = AppLocalizations.of(context).loginErrorUnknown);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final server = ref.watch(backendUrlProvider);
    if (!_seeded && server.hasValue) {
      _server.text = server.requireValue;
      _seeded = true;
    }
    if (!_openedPendingLocalLogin &&
        _path == _SetupPath.choose &&
        ref.watch(appModeProvider) == AppMode.local &&
        ref.watch(localLoginProvider) == null) {
      _openedPendingLocalLogin = true;
      _path = _SetupPath.localLogin;
    }

    return PlinthAuthScreen(
      accentColor: 'green',
      child: PlinthStack(
        children: [
          const Align(
            alignment: AlignmentDirectional.centerEnd,
            child: LanguageToggle(),
          ),
          PlinthHeroBlock(
            headline: l10n.appTitle,
            subhead: l10n.setupLead,
            headlineOrder: 1,
            eyebrow: const Icon(Icons.fitness_center),
          ),
          const PlinthSpace(h: PlinthSize.lg),
          if (_error != null) PlinthAlert(color: 'red', child: Text(_error!)),
          switch (_path) {
            _SetupPath.choose => PlinthStack(
                gap: PlinthSize.md,
                children: [
                  PlinthTitle(l10n.setupTitle, order: 2),
                  StayAbleChoiceCard(
                    title: l10n.modeLocalTitle,
                    lead: l10n.modeLocalLead,
                    action: PlinthButton(
                      fullWidth: true,
                      onPressed: _chooseStandalone,
                      child: Text(l10n.modeLocalAction),
                    ),
                  ),
                  StayAbleChoiceCard(
                    title: l10n.modeTrainerTitle,
                    lead: l10n.modeTrainerLead,
                    action: PlinthButton(
                      fullWidth: true,
                      variant: PlinthVariant.outline,
                      onPressed: () =>
                          setState(() => _path = _SetupPath.network),
                      child: Text(l10n.modeTrainerAction),
                    ),
                  ),
                ],
              ),
            _SetupPath.localLogin => PlinthStack(
                gap: PlinthSize.md,
                children: [
                  PlinthButton(
                    variant: PlinthVariant.subtle,
                    onPressed: _backToChoices,
                    child: Text(l10n.backToModes),
                  ),
                  PlinthTitle(l10n.setupLocalLoginTitle, order: 2),
                  PlinthText(l10n.setupLocalLoginLead, color: 'gray'),
                  StayAbleChoiceCard(
                    title: l10n.setupLocalLoginYesTitle,
                    lead: l10n.setupLocalLoginYesLead,
                    action: PlinthAsyncButton(
                      fullWidth: true,
                      onPressed: _chooseLocalWithLogin,
                      child: Text(l10n.setupLocalLoginYesAction),
                    ),
                  ),
                  StayAbleChoiceCard(
                    title: l10n.setupLocalLoginNoTitle,
                    lead: l10n.setupLocalLoginNoLead,
                    action: PlinthAsyncButton(
                      fullWidth: true,
                      variant: PlinthVariant.outline,
                      onPressed: _chooseLocalWithoutLogin,
                      child: Text(l10n.setupLocalLoginNoAction),
                    ),
                  ),
                ],
              ),
            _SetupPath.network => PlinthStack(
                children: [
                  PlinthButton(
                    variant: PlinthVariant.subtle,
                    onPressed: _backToChoices,
                    child: Text(l10n.backToModes),
                  ),
                  PlinthAuthCard(
                    title: l10n.modeTrainerTitle,
                    subtitle: l10n.setupServerLead,
                    width: 440,
                    fields: [
                      PlinthTextInput(
                        controller: _server,
                        label: l10n.serverUrl,
                        placeholder: 'https://gym.example.com',
                        keyboardType: TextInputType.url,
                      ),
                    ],
                    action: PlinthAsyncButton(
                      fullWidth: true,
                      onPressed: _saveNetwork,
                      child: Text(l10n.setupContinue),
                    ),
                  ),
                ],
              ),
          },
          const AppVersionLabel(),
        ],
      ),
    );
  }
}
