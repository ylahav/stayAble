import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plinth_blocks/plinth_blocks.dart';

import '../../core/widgets/app_version_label.dart';
import '../../core/widgets/language_toggle.dart';
import '../../data/remote/session_store.dart';
import '../../domain/entities/auth_session.dart';
import '../../l10n/app_localizations.dart';
import 'auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  var _creating = false;
  var _checkedAccounts = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _prepareLocal() async {
    if (_checkedAccounts) return;
    _checkedAccounts = true;
    if (ref.read(appModeProvider) != AppMode.local) return;
    final hasAccounts = await ref.read(sessionStoreProvider).hasLocalAccounts();
    if (!mounted) return;
    setState(() => _creating = !hasAccounts);
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final isLocal = ref.read(appModeProvider) == AppMode.local;
    final name = _name.text.trim();
    final email = _email.text.trim();
    final password = _password.text;
    if (_creating && name.isEmpty) {
      setState(() => _error = l10n.loginNameRequired);
      return;
    }
    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _error = email.isEmpty
            ? l10n.loginEmailRequired
            : l10n.loginPasswordRequired;
      });
      return;
    }
    if (_creating && password.length < 6) {
      setState(() => _error = l10n.loginPasswordShort);
      return;
    }
    setState(() => _error = null);
    try {
      if (isLocal && _creating) {
        await ref.read(authProvider.notifier).registerLocal(
              name: name,
              email: email,
              password: password,
              language: Localizations.localeOf(context).languageCode,
            );
      } else {
        await ref.read(authProvider.notifier).login(email, password);
      }
    } on AuthException catch (error) {
      if (!mounted) return;
      setState(() => _error = _message(AppLocalizations.of(context), error));
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
      case AuthFailure.emailTaken:
        return l10n.loginErrorEmailTaken;
      case AuthFailure.unknown:
        return error.detail ?? l10n.loginErrorUnknown;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final server = ref.watch(backendUrlProvider);
    final isLocal = ref.watch(appModeProvider) == AppMode.local;
    if (isLocal) {
      unawaited(_prepareLocal());
    }
    final lead = isLocal ? l10n.loginLeadLocal : l10n.loginLead;
    final title = isLocal && _creating ? l10n.loginCreateTitle : l10n.loginTitle;

    return PlinthAuthScreen(
      accentColor: 'green',
      child: PlinthStack(
        children: [
          const Align(
            alignment: AlignmentDirectional.centerEnd,
            child: LanguageToggle(),
          ),
          PlinthTitle(l10n.appTitle, order: 1),
          PlinthText(lead, color: 'gray'),
          if (!isLocal && server.hasValue)
            PlinthText(server.requireValue, color: 'gray', size: PlinthSize.sm),
          const PlinthSpace(h: PlinthSize.lg),
          if (isLocal)
            PlinthGroup(
              children: [
                PlinthChip(
                  label: l10n.loginCreateTitle,
                  selected: _creating,
                  onSelected: (_) => setState(() {
                    _creating = true;
                    _error = null;
                  }),
                ),
                PlinthChip(
                  label: l10n.loginAction,
                  selected: !_creating,
                  onSelected: (_) => setState(() {
                    _creating = false;
                    _error = null;
                  }),
                ),
              ],
            ),
          PlinthAuthCard(
            title: title,
            subtitle: isLocal && _creating
                ? l10n.loginCreateLead
                : lead,
            width: 440,
            fields: [
              if (_error != null)
                PlinthAlert(
                  color: 'red',
                  child: Text(_error!),
                ),
              if (isLocal && _creating)
                PlinthTextInput(
                  controller: _name,
                  label: l10n.loginName,
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
              child: Text(
                isLocal && _creating ? l10n.loginCreateAction : l10n.loginAction,
              ),
            ),
          ),
          if (isLocal) ...[
            const PlinthSpace(h: PlinthSize.md),
            PlinthButton(
              variant: PlinthVariant.subtle,
              onPressed: () => ref.read(authProvider.notifier).resetSetup(),
              child: Text(l10n.changeSetup),
            ),
          ],
          const AppVersionLabel(),
        ],
      ),
    );
  }
}
