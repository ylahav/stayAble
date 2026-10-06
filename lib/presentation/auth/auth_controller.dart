import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:uuid/uuid.dart';

import '../../data/remote/catalog_check.dart';
import '../../data/remote/local_accounts.dart';
import '../../data/remote/payload_api.dart';
import '../../data/remote/payload_config.dart';
import '../../data/remote/session_store.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/entities/trainee_assessment.dart';
import '../../domain/entities/training_program.dart';
import '../providers.dart';

const _uuid = Uuid();

class BackendUrlController extends AsyncNotifier<String> {
  @override
  Future<String> build() {
    return ref.read(sessionStoreProvider).readBaseUrl();
  }

  Future<void> save(String raw) async {
    try {
      final url = normalizePayloadUrl(raw);
      await ref.read(sessionStoreProvider).saveBaseUrl(url);
      final previous = state.value;
      state = AsyncData(url);
      if (previous != null && previous != url) {
        final session = ref.read(authProvider).value;
        if (session != null && !session.isLocal) {
          await ref.read(authProvider.notifier).logout();
        }
      }
    } on FormatException catch (error) {
      throw AuthException(AuthFailure.invalidServer, error.message);
    }
  }
}

final backendUrlProvider =
    AsyncNotifierProvider<BackendUrlController, String>(BackendUrlController.new);

class CatalogUpdateController extends Notifier<CatalogUpdate> {
  @override
  CatalogUpdate build() => const CatalogUpdate();

  void show(CatalogUpdate update) => state = update;

  void clear() => state = const CatalogUpdate();
}

final catalogUpdateProvider =
    NotifierProvider<CatalogUpdateController, CatalogUpdate>(
  CatalogUpdateController.new,
);

class AuthController extends AsyncNotifier<AuthSession?> {
  @override
  Future<AuthSession?> build() async {
    final session = await _restore();
    if (session != null) {
      if (session.isLocal) {
        unawaited(_checkCatalogUpdates());
      } else {
        unawaited(_sync(session));
      }
    }
    return session;
  }

  Future<PayloadApi> _api() async {
    final url = await ref.read(sessionStoreProvider).readBaseUrl();
    return PayloadApi(baseUrl: url);
  }

  Future<void> login(String email, String password) async {
    final store = ref.read(sessionStoreProvider);
    final local = ref.read(appModeProvider) == AppMode.local ||
        await store.readLocalLogin() == true;
    if (local) {
      final account = await store.findLocalAccount(email);
      if (account == null || !account.matches(password)) {
        throw const AuthException(AuthFailure.invalidCredentials);
      }
      await _activateLocalAccount(account);
      return;
    }
    final api = await _api();
    final session = await api.login(email, password);
    await store.saveMode(AppMode.cloud);
    await store.saveLocalLogin(false);
    ref.read(appModeProvider.notifier).setMode(AppMode.cloud);
    ref.read(localLoginProvider.notifier).setChoice(false);
    await store.saveToken(session.token);
    await _bindCloudUser(session.user);
    await _applyLanguage(session.user.language);
    state = AsyncData(session);
    unawaited(_sync(session));
  }

  Future<void> registerLocal({
    required String name,
    required String email,
    required String password,
    required String language,
  }) async {
    final store = ref.read(sessionStoreProvider);
    final existing = await store.findLocalAccount(email);
    if (existing != null) {
      throw const AuthException(AuthFailure.emailTaken);
    }
    final salt = _uuid.v4();
    final account = LocalAccountRecord(
      id: 'local-user-${_uuid.v4()}',
      name: name.trim(),
      email: normalizeLocalEmail(email),
      salt: salt,
      hash: hashLocalPassword(password, salt),
    );
    await store.saveLocalAccount(account);
    await _activateLocalAccount(account, language: language);
  }

  Future<void> enterLocal({required String language}) async {
    final store = ref.read(sessionStoreProvider);
    await store.saveMode(AppMode.local);
    await store.saveLocalLogin(false);
    ref.read(appModeProvider.notifier).setMode(AppMode.local);
    ref.read(localLoginProvider.notifier).setChoice(false);
    await store.clearTokenOnly();
    await store.saveCurrentUserId(anonymousLocalUserId);
    await ref.read(repositoryProvider).useUserId(anonymousLocalUserId);
    await _ensureCatalogUrl();
    final session = AuthSession.local(language: language);
    await _applyLanguage(language);
    state = AsyncData(session);
    await _pullCatalog(session);
  }

  Future<void> returnToSetupChoices() async {
    final store = ref.read(sessionStoreProvider);
    if (await store.readLocalLogin() == null) {
      await store.clearMode();
    }
    ref.read(appModeProvider.notifier).setMode(null);
    ref.read(localLoginProvider.notifier).setChoice(null);
  }

  Future<void> beginLocalLogin() async {
    final store = ref.read(sessionStoreProvider);
    await store.saveMode(AppMode.local);
    await store.saveLocalLogin(true);
    ref.read(appModeProvider.notifier).setMode(AppMode.local);
    ref.read(localLoginProvider.notifier).setChoice(true);
    await store.clearTokenOnly();
    await _ensureCatalogUrl();
    state = const AsyncData(null);
  }

  Future<void> refreshCatalog() async {
    final session = state.value;
    if (session == null) return;
    await _pullCatalog(session, swallowErrors: false);
  }

  Future<void> dismissCatalogUpdate() async {
    await ref.read(sessionStoreProvider).saveCatalogPending(const CatalogUpdate());
    ref.read(catalogUpdateProvider.notifier).clear();
  }

  Future<void> logout() async {
    final token = state.value?.token;
    if (token != null &&
        token.isNotEmpty &&
        !isLocalSessionToken(token)) {
      await (await _api()).logout(token);
    }
    await ref.read(sessionStoreProvider).clear();
    state = const AsyncData(null);
  }

  Future<void> completeCloudSetup(String url) async {
    await ref.read(backendUrlProvider.notifier).save(url);
    final store = ref.read(sessionStoreProvider);
    await store.saveMode(AppMode.cloud);
    await store.saveLocalLogin(false);
    ref.read(appModeProvider.notifier).setMode(AppMode.cloud);
    ref.read(localLoginProvider.notifier).setChoice(false);
  }

  Future<void> resetSetup() async {
    final token = state.value?.token;
    if (token != null &&
        token.isNotEmpty &&
        !isLocalSessionToken(token)) {
      await (await _api()).logout(token);
    }
    await ref.read(sessionStoreProvider).clearSetup();
    ref.read(appModeProvider.notifier).setMode(null);
    ref.read(localLoginProvider.notifier).setChoice(null);
    state = const AsyncData(null);
  }

  Future<void> saveBirthDate(DateTime birthDate) async {
    await ref.read(repositoryProvider).setBirthDate(birthDate);
    await _pushProfileQuietly();
  }

  Future<void> saveAssessment(TraineeAssessment assessment) async {
    await ref.read(repositoryProvider).setAssessment(assessment);
    await _pushProfileQuietly();
  }

  Future<void> pushSession(String sessionId) async {
    final token = state.value?.token;
    if (token == null || token.isEmpty || isLocalSessionToken(token)) return;
    try {
      final playback = await ref.read(repositoryProvider).getPlayback(sessionId);
      await (await _api()).upsertWorkoutSession(token: token, playback: playback);
    } catch (error, stack) {
      debugPrint('Session sync failed: $error\n$stack');
    }
  }

  Future<AuthSession?> _restore() async {
    final store = ref.read(sessionStoreProvider);
    final mode = await store.readMode();
    if (mode == AppMode.local) {
      final useLogin = await store.readLocalLogin();
      ref.read(localLoginProvider.notifier).setChoice(useLogin);
      if (useLogin == null) {
        ref.read(appModeProvider.notifier).setMode(AppMode.local);
        return null;
      }
      ref.read(appModeProvider.notifier).setMode(AppMode.local);
      await _ensureCatalogUrl();
      if (useLogin) {
        final token = await store.readToken();
        if (token == null) return null;
        final localId = localUserIdFromToken(token);
        if (localId != null) {
          await ref.read(repositoryProvider).useUserId(localId);
          final user = await ref.read(repositoryProvider).getCurrentUser();
          await store.saveCurrentUserId(user.id);
          await _applyLanguage(user.language);
          return AuthSession(
            token: token,
            localMode: true,
            user: RemoteUser(
              id: user.id,
              email: user.email ?? '',
              name: user.name,
              roles: const ['trainee'],
              language: user.language,
              active: user.active,
            ),
          );
        }
        await store.clearTokenOnly();
        return null;
      }
      await store.saveCurrentUserId(anonymousLocalUserId);
      await ref.read(repositoryProvider).useUserId(anonymousLocalUserId);
      return AuthSession.local(
        language: ref.read(localeProvider).languageCode,
      );
    }
    ref.read(appModeProvider.notifier).setMode(mode);
    final token = await store.readToken();
    if (token == null) return null;
    try {
      final user = await (await _api()).me(token);
      if (!user.active || !user.isAthlete) {
        await store.clear();
        return null;
      }
      await _bindCloudUser(user);
      await _applyLanguage(user.language);
      if (mode == null) {
        await store.saveMode(AppMode.cloud);
        ref.read(appModeProvider.notifier).setMode(AppMode.cloud);
      }
      return AuthSession(token: token, user: user);
    } catch (_) {
      await store.clear();
      return null;
    }
  }

  Future<void> _pullCatalog(
    AuthSession session, {
    bool swallowErrors = true,
  }) async {
    try {
      final api = await _api();
      final exercises = session.isLocal
          ? await api.fetchPublicCatalog()
          : await api.fetchExercises(session.token);
      await ref.read(repositoryProvider).upsertExercises(exercises);
      final store = ref.read(sessionStoreProvider);
      final status = PublicCatalogStatus.fromExercises(exercises);
      await store.saveCatalogLastCheck(DateTime.now());
      await store.saveCatalogSignature(status.signature);
      await store.saveCatalogPending(const CatalogUpdate());
      ref.read(catalogUpdateProvider.notifier).clear();
      ref.invalidate(filteredExercisesProvider);
      ref.invalidate(homeSnapshotProvider);
      ref.invalidate(programSnapshotProvider);
    } catch (error, stack) {
      debugPrint('Catalog refresh failed: $error\n$stack');
      if (!swallowErrors) rethrow;
    }
  }

  Future<void> _ensureCatalogUrl() async {
    final store = ref.read(sessionStoreProvider);
    if (await store.hasSavedBaseUrl()) return;
    await store.saveBaseUrl(resolvePayloadUrl());
    ref.invalidate(backendUrlProvider);
  }

  Future<void> _checkCatalogUpdates() async {
    final store = ref.read(sessionStoreProvider);
    await _ensureCatalogUrl();
    final pending = await store.readCatalogPending();
    if (pending.available) {
      ref.read(catalogUpdateProvider.notifier).show(pending);
    }
    if (!catalogCheckDue(
      now: DateTime.now(),
      lastCheck: await store.readCatalogLastCheck(),
    )) {
      return;
    }
    try {
      final remote = await (await _api()).fetchPublicCatalogStatus();
      final update = CatalogUpdate.compare(
        localIds: await ref.read(repositoryProvider).getExerciseIds(),
        remote: remote,
        lastSignature: await store.readCatalogSignature(),
      );
      await store.saveCatalogLastCheck(DateTime.now());
      await store.saveCatalogPending(update);
      ref.read(catalogUpdateProvider.notifier).show(update);
    } catch (error, stack) {
      debugPrint('Catalog check failed: $error\n$stack');
    }
  }

  Future<void> _sync(AuthSession session) async {
    await _pullRemote(session);
    await _pushLocalSessions(session.token);
  }

  Future<void> _pullRemote(AuthSession session) async {
    try {
      final repo = ref.read(repositoryProvider);
      final api = await _api();
      final remote = await api.me(session.token);
      await _bindCloudUser(remote);
      final local = await repo.getCurrentUser();
      if ((remote.assessment == null && local.assessment != null) ||
          (remote.birthDate == null && local.birthDate != null)) {
        await _pushProfile(session);
      }
      final exercises = await api.fetchExercises(session.token);
      await repo.upsertExercises(exercises);
      final programs = await api.fetchAssignedPrograms(
        token: session.token,
        athleteId: session.user.id,
        localUserId: local.id,
      );
      await repo.upsertAssignedPrograms(programs);
      ref.invalidate(homeSnapshotProvider);
      ref.invalidate(programSnapshotProvider);
      ref.invalidate(historySnapshotProvider);
      ref.invalidate(filteredExercisesProvider);
    } catch (error, stack) {
      debugPrint('Catalog sync failed: $error\n$stack');
    }
  }

  Future<void> _pushLocalSessions(String token) async {
    try {
      final repo = ref.read(repositoryProvider);
      final api = await _api();
      final history = await repo.getHistorySnapshot(
        DateTime.now(),
        localOnly: false,
      );
      for (final session in history.sessions) {
        final playback = await repo.getPlayback(session.id);
        await api.upsertWorkoutSession(token: token, playback: playback);
      }
    } catch (error, stack) {
      debugPrint('History sync failed: $error\n$stack');
    }
  }

  Future<void> _bindCloudUser(RemoteUser user) async {
    final repo = ref.read(repositoryProvider);
    await repo.ensureSignedInUser(
      id: user.id,
      name: user.name,
      email: user.email,
      language: user.language,
    );
    await repo.applyRemoteProfile(
      birthDate: user.birthDate,
      assessment: user.assessment,
      fitnessLevel: user.fitnessLevel,
      goals: user.goals.isEmpty ? null : user.goals,
      trainingVenue: user.trainingVenue,
    );
    await ref.read(sessionStoreProvider).saveCurrentUserId(user.id);
  }

  Future<void> _pushProfileQuietly() async {
    try {
      await _pushProfile();
    } catch (error, stack) {
      debugPrint('Profile sync failed: $error\n$stack');
    }
  }

  Future<void> _pushProfile([AuthSession? current]) async {
    final session = current ?? state.value;
    if (session == null || session.isLocal) return;
    final user = await ref.read(repositoryProvider).getCurrentUser();
    await (await _api()).updateAthleteProfile(
      token: session.token,
      userId: session.user.id,
      birthDate: user.birthDate,
      assessment: user.assessment,
      fitnessLevel: user.fitnessLevel,
      goals: user.goals,
      trainingVenue: user.trainingVenue,
    );
  }

  Future<void> _activateLocalAccount(
    LocalAccountRecord account, {
    String? language,
  }) async {
    final store = ref.read(sessionStoreProvider);
    final languageCode = language ?? ref.read(localeProvider).languageCode;
    await store.saveMode(AppMode.local);
    await store.saveLocalLogin(true);
    ref.read(appModeProvider.notifier).setMode(AppMode.local);
    ref.read(localLoginProvider.notifier).setChoice(true);
    await ref.read(repositoryProvider).ensureSignedInUser(
          id: account.id,
          name: account.name,
          email: account.email,
          language: languageCode,
        );
    await store.saveCurrentUserId(account.id);
    await store.saveToken(localSessionToken(account.id));
    await _applyLanguage(languageCode);
    final session = AuthSession(
      token: localSessionToken(account.id),
      localMode: true,
      user: RemoteUser(
        id: account.id,
        email: account.email,
        name: account.name,
        roles: const ['trainee'],
        language: languageCode,
        active: true,
      ),
    );
    state = AsyncData(session);
    ref.invalidate(homeSnapshotProvider);
    ref.invalidate(programSnapshotProvider);
    ref.invalidate(historySnapshotProvider);
    unawaited(_pullCatalog(session));
  }

  Future<void> _applyLanguage(String language) async {
    if (language != 'en' && language != 'he') return;
    await ref.read(localeProvider.notifier).setCode(language);
  }
}

final authProvider = AsyncNotifierProvider<AuthController, AuthSession?>(
  AuthController.new,
);
