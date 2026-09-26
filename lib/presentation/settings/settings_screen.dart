import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:plinth_blocks/plinth_blocks.dart';

import 'package:intl/intl.dart';

import '../../data/remote/session_store.dart';
import '../../domain/entities/auth_session.dart';
import '../../l10n/app_localizations.dart';
import '../../core/widgets/language_toggle.dart';
import '../../core/widgets/stayable_async.dart';
import '../auth/auth_controller.dart';
import '../profile/birthday_prompt.dart';
import '../providers.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _url = TextEditingController();
  var _seeded = false;
  DateTime? _birthDate;
  var _birthLoaded = false;
  String? _error;
  String? _saved;

  @override
  void initState() {
    super.initState();
    _loadBirthDate();
  }

  @override
  void dispose() {
    _url.dispose();
    super.dispose();
  }

  Future<void> _loadBirthDate() async {
    final user = await ref.read(repositoryProvider).getCurrentUser();
    if (!mounted) return;
    setState(() {
      _birthDate = user.birthDate;
      _birthLoaded = true;
    });
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
    final isLocal = ref.watch(appModeProvider) == AppMode.local;
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
      body: StayAbleScrollBody(
        children: [
          Row(
            children: [
              PlinthBadge(isLocal ? l10n.appModeLocal : l10n.appModeCloud),
              const Spacer(),
              const LanguageToggle(),
            ],
          ),
          const PlinthSpace(h: PlinthSize.md),
          if (_error != null) PlinthAlert(color: 'red', child: Text(_error!)),
          if (_saved != null) PlinthAlert(color: 'green', child: Text(_saved!)),
          PlinthCard(
            withBorder: true,
            header: PlinthTitle(l10n.birthday, order: 3),
            footer: PlinthButton(
              fullWidth: true,
              variant: PlinthVariant.outline,
              onPressed: () async {
                final saved = await editUserBirthDate(
                  context: context,
                  ref: ref,
                  initial: _birthDate,
                );
                if (!mounted || saved == null) return;
                setState(() => _birthDate = saved);
              },
              child: Text(
                _birthDate == null ? l10n.birthdaySave : l10n.birthdayChange,
              ),
            ),
            child: PlinthText(
              !_birthLoaded
                  ? ''
                  : _birthDate == null
                      ? l10n.birthdayUnset
                      : DateFormat.yMMMd(
                          Localizations.localeOf(context).toLanguageTag(),
                        ).format(_birthDate!),
              color: 'gray',
            ),
          ),
          const PlinthSpace(h: PlinthSize.lg),
          PlinthCard(
            withBorder: true,
            header: PlinthTitle(l10n.assessTitle, order: 3),
            footer: PlinthButton(
              fullWidth: true,
              variant: PlinthVariant.outline,
              onPressed: () => context.push('/profile'),
              child: Text(l10n.assessChange),
            ),
            child: PlinthText(l10n.wizardLead, color: 'gray'),
          ),
          const PlinthSpace(h: PlinthSize.lg),
          if (!isLocal) ...[
            PlinthAuthCard(
              title: l10n.serverUrl,
              subtitle: l10n.serverUrlHint,
              width: null,
              fields: [
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
            const PlinthSpace(h: PlinthSize.lg),
          ],
          PlinthCard(
            withBorder: true,
            header: PlinthTitle(l10n.changeSetup, order: 3),
            footer: PlinthButton(
              fullWidth: true,
              variant: PlinthVariant.outline,
              onPressed: () => ref.read(authProvider.notifier).resetSetup(),
              child: Text(l10n.changeSetup),
            ),
            child: PlinthText(l10n.changeSetupHint, color: 'gray'),
          ),
          const PlinthSpace(h: PlinthSize.lg),
          PlinthCard(
            withBorder: true,
            header: PlinthTitle(l10n.exercisesLabel, order: 3),
            footer: PlinthAsyncButton(
              fullWidth: true,
              onPressed: () async {
                setState(() {
                  _error = null;
                  _saved = null;
                });
                try {
                  await ref.read(authProvider.notifier).refreshCatalog();
                  if (!mounted) return;
                  setState(() => _saved = l10n.catalogRefreshed);
                } catch (_) {
                  if (!mounted) return;
                  setState(() => _error = l10n.catalogRefreshFailed);
                }
              },
              doneLabel: l10n.catalogRefreshed,
              child: Text(l10n.catalogRefresh),
            ),
            child: PlinthText(
              isLocal ? l10n.catalogWeeklyHint : l10n.serverUrlHint,
              color: 'gray',
            ),
          ),
          if ((ref.watch(authProvider).value?.token.isNotEmpty ?? false)) ...[
            const PlinthSpace(h: PlinthSize.lg),
            PlinthButton(
              fullWidth: true,
              variant: PlinthVariant.outline,
              onPressed: () => ref.read(authProvider.notifier).logout(),
              child: Text(l10n.logOut),
            ),
          ],
        ],
      ),
    );
  }
}
