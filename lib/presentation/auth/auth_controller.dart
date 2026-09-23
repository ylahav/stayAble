import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/remote/payload_api.dart';
import '../../data/remote/payload_config.dart';
import '../../data/remote/session_store.dart';
import '../../domain/entities/auth_session.dart';
import '../providers.dart';

final sessionStoreProvider = Provider<SessionStore>((ref) => SessionStore());

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
        await ref.read(authProvider.notifier).logout();
      }
    } on FormatException catch (error) {
      throw AuthException(AuthFailure.invalidServer, error.message);
    }
  }
}

final backendUrlProvider =
    AsyncNotifierProvider<BackendUrlController, String>(BackendUrlController.new);

class AuthController extends AsyncNotifier<AuthSession?> {
  @override
  Future<AuthSession?> build() async {
    final session = await _restore();
    if (session != null) {
      unawaited(_sync(session));
    }
    return session;
  }

  Future<PayloadApi> _api() async {
    final url = await ref.read(sessionStoreProvider).readBaseUrl();
    return PayloadApi(baseUrl: url);
  }

  Future<void> login(String email, String password) async {
    final store = ref.read(sessionStoreProvider);
    final api = await _api();
    final session = await api.login(email, password);
    await store.saveToken(session.token);
    await _applyLanguage(session.user.language);
    state = AsyncData(session);
    unawaited(_sync(session));
  }

  Future<void> logout() async {
    final token = state.value?.token;
    if (token != null) {
      await (await _api()).logout(token);
    }
    await ref.read(sessionStoreProvider).clear();
    state = const AsyncData(null);
  }

  Future<void> pushSession(String sessionId) async {
    final token = state.value?.token;
    if (token == null) return;
    try {
      final playback = await ref.read(repositoryProvider).getPlayback(sessionId);
      await (await _api()).upsertWorkoutSession(token: token, playback: playback);
    } catch (error, stack) {
      debugPrint('Session sync failed: $error\n$stack');
    }
  }

  Future<AuthSession?> _restore() async {
    final store = ref.read(sessionStoreProvider);
    final token = await store.readToken();
    if (token == null) return null;
    try {
      final user = await (await _api()).me(token);
      if (!user.active || !user.isAthlete) {
        await store.clear();
        return null;
      }
      await _applyLanguage(user.language);
      return AuthSession(token: token, user: user);
    } catch (_) {
      await store.clear();
      return null;
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
      final exercises = await api.fetchExercises(session.token);
      await repo.upsertExercises(exercises);
      final local = await repo.getCurrentUser();
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
      final history = await repo.getHistorySnapshot(DateTime.now());
      for (final session in history.sessions) {
        final playback = await repo.getPlayback(session.id);
        await api.upsertWorkoutSession(token: token, playback: playback);
      }
    } catch (error, stack) {
      debugPrint('History sync failed: $error\n$stack');
    }
  }

  Future<void> _applyLanguage(String language) async {
    if (language != 'en' && language != 'he') return;
    await ref.read(localeProvider.notifier).setCode(language);
  }
}

final authProvider = AsyncNotifierProvider<AuthController, AuthSession?>(
  AuthController.new,
);
