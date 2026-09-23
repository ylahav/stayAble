import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plinth_blocks/plinth_blocks.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_version_label.dart';
import '../../core/widgets/language_toggle.dart';
import '../../domain/entities/auth_session.dart';
import '../../l10n/app_localizations.dart';
import 'auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _server = TextEditingController();
  var _serverSeeded = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _server.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final server = _server.text.trim();
    final email = _email.text.trim();
    final password = _password.text;
    if (server.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() {
        _error = server.isEmpty
            ? l10n.serverUrlRequired
            : email.isEmpty
                ? l10n.loginEmailRequired
                : l10n.loginPasswordRequired;
      });
      return;
    }
    setState(() => _error = null);
    try {
      await ref.read(backendUrlProvider.notifier).save(server);
      await ref.read(authProvider.notifier).login(email, password);
    } on AuthException catch (error) {
      if (!mounted) return;
      setState(() => _error = _message(AppLocalizations.of(context), error));
    } on FormatException {
      if (!mounted) return;
      setState(() => _error = AppLocalizations.of(context).loginErrorServer);
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = AppLocalizations.of(context).loginErrorUnknown);
    }
  }

  String _message(AppLocalizations l10n, AuthException error) {
    switch (error.failure) {
      case AuthFailure.invalidCredentials:
        return l10n.loginErrorCredentials;
      case AuthFailure.notAthlete:
        return l10n.loginErrorNotAthlete;
      case AuthFailure.inactive:
        return l10n.loginErrorInactive;
      case AuthFailure.network:
        return l10n.loginErrorNetwork;
      case AuthFailure.invalidServer:
        return l10n.loginErrorServer;
      case AuthFailure.unknown:
        return error.detail ?? l10n.loginErrorUnknown;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final server = ref.watch(backendUrlProvider);
    if (!_serverSeeded && server.hasValue) {
      _server.text = server.requireValue;
      _serverSeeded = true;
    }

    return Scaffold(
      body: Column(
        children: [
          const ColoredBox(
            color: AppColors.matGreen,
            child: SizedBox(height: 8, width: double.infinity),
          ),
          Expanded(
            child: SafeArea(
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(
                    PlinthSpacing.lg,
                    PlinthSpacing.md,
                    PlinthSpacing.lg,
                    PlinthSpacing.xl,
                  ),
                  children: [
                    const Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: LanguageToggle(),
                    ),
                    const PlinthSpace(h: PlinthSize.md),
                    PlinthTitle(l10n.appTitle, order: 1),
                    PlinthText(l10n.loginLead, color: 'gray'),
                    const PlinthSpace(h: PlinthSize.lg),
                    PlinthAuthCard(
                      title: l10n.loginTitle,
                      subtitle: l10n.loginLead,
                      width: 440,
                      fields: [
                        if (_error != null)
                          PlinthAlert(
                            color: 'red',
                            child: Text(_error!),
                          ),
                        PlinthTextInput(
                          controller: _server,
                          label: l10n.serverUrl,
                          placeholder: 'https://gym.example.com',
                          keyboardType: TextInputType.url,
                        ),
                        PlinthTextInput(
                          controller: _email,
                          label: l10n.loginEmail,
                          placeholder: 'you@example.com',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        PlinthPasswordInput(
                          controller: _password,
                          label: l10n.loginPassword,
                        ),
                      ],
                      action: PlinthAsyncButton(
                        fullWidth: true,
                        onPressed: _submit,
                        child: Text(l10n.loginAction),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const AppVersionLabel(),
        ],
      ),
    );
  }
}
