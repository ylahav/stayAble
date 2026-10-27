import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:payload_client/payload_client.dart'
    show CollectionRef, FindOptions, PayloadClient, PayloadException, Ref;

import '../../domain/domain.dart';
import '../../payload/models.dart';
import 'athlete_profile.dart';
import 'catalog_check.dart';
import 'catalog_sync.dart';
import 'cms_exercises.dart';
import 'cms_programs.dart';
import 'cms_users.dart';
import 'payload_config.dart';

class PayloadApi {
  PayloadApi({http.Client? client, String? baseUrl})
    : _client = client ?? http.Client(),
      baseUrl = baseUrl ?? resolvePayloadUrl();

  final http.Client _client;
  final String baseUrl;

  /// A payload_client for one call, on this API's shared http.Client.
  /// Each call carries its own token, as the methods here always have.
  PayloadClient _cms([String? token]) => PayloadClient(
    baseUrl: Uri.parse(baseUrl),
    token: token,
    httpClient: _client,
  );

  /// Runs a payload_client call with the timeout and errors this API has
  /// always had: [AuthException] for auth, network and server failures.
  Future<T> _guard<T>(
    Future<T> Function() call, {
    Set<int> invalidCredentials = const {401, 403},
  }) async {
    try {
      return await call().timeout(const Duration(seconds: 20));
    } on PayloadException catch (e) {
      if (invalidCredentials.contains(e.statusCode)) {
        throw const AuthException(AuthFailure.invalidCredentials);
      }
      throw AuthException(AuthFailure.unknown, e.message);
    } on SocketException {
      throw const AuthException(AuthFailure.network);
    } on TimeoutException {
      throw const AuthException(AuthFailure.network);
    } on http.ClientException {
      throw const AuthException(AuthFailure.network);
    }
  }

  Future<AuthSession> login(String email, String password) async {
    final auth = await _guard(
      () => _cms().login(
        Collections.users.slug,
        email: email.trim(),
        password: password,
      ),
      // A wrong password is a 401; a malformed email is a 400.
      invalidCredentials: const {400, 401},
    );
    final token = auth.token;
    if (token == null || auth.user.isEmpty) {
      throw const AuthException(AuthFailure.unknown);
    }
    return _sessionFrom(token, remoteUserFromCms(CmsUser.fromJson(auth.user)));
  }

  Future<RemoteUser> me(String token) async {
    final auth = await _guard(() => _cms(token).me(Collections.users.slug));
    // Payload answers an expired token with `{user: null}`, not a 401.
    if (auth == null) throw const AuthException(AuthFailure.invalidCredentials);
    return remoteUserFromCms(CmsUser.fromJson(auth.user));
  }

  Future<void> logout(String token) async {
    try {
      await _guard(() => _cms(token).logout(Collections.users.slug));
    } catch (_) {
      // Local sign-out still proceeds.
    }
  }

  Future<List<Exercise>> fetchExercises(String token) async {
    final page = await _guard(
      () => _cms(token).find(
        Collections.exercises,
        options: const FindOptions(
          limit: 300,
          depth: 1,
          pagination: false,
          where: {
            'deleted': {'not_equals': true},
          },
        ),
      ),
    );
    return [
      // The app keys exercises by clientId, so one without it can't be used.
      for (final doc in page.docs)
        if (doc.clientId != null) exerciseFromCms(doc, baseUrl),
    ];
  }

  /// Stays on raw JSON: the public catalog endpoint sends `instructions`
  /// as HTML strings, not the rich text the exercises collection holds, so
  /// it doesn't have CmsExercise's shape.
  Future<List<Exercise>> fetchPublicCatalog() async {
    final body = await _getPublic([
      '/api/public-catalog',
      '/api/exercises/public-catalog',
    ]);
    return _exercisesFrom(_decode(body.body));
  }

  Future<PublicCatalogStatus> fetchPublicCatalogStatus() async {
    final body = await _getPublicOrNull([
      '/api/public-catalog-status',
      '/api/exercises/public-catalog-status',
    ]);
    if (body == null) {
      return PublicCatalogStatus.fromExercises(await fetchPublicCatalog());
    }
    return PublicCatalogStatus.fromJson(_decode(body.body));
  }

  List<Exercise> _exercisesFrom(Map<String, dynamic> json) {
    final docs = json['docs'];
    final items = <Exercise>[];
    if (docs is List) {
      for (final doc in docs) {
        if (doc is Map && doc['clientId'] is String) {
          items.add(
            exerciseFromPayload(Map<String, dynamic>.from(doc), baseUrl),
          );
        }
      }
    }
    return items;
  }

  Future<List<RemoteProgramTree>> fetchAssignedPrograms({
    required String token,
    required String athleteId,
    required String localUserId,
  }) async {
    final page = await _guard(
      () => _cms(token).find(
        Collections.programAssignments,
        options: FindOptions(
          limit: 20,
          // assignment → program → exercise
          depth: 2,
          where: {
            'athlete': {'equals': athleteId},
            'active': {'equals': true},
          },
          sort: '-updatedAt',
        ),
      ),
    );
    final trees = <RemoteProgramTree>[];
    final seen = <String>{};
    for (final assignment in page.docs) {
      final tree = programFromCms(assignment, localUserId);
      if (tree == null || !seen.add(tree.program.id)) continue;
      trees.add(tree);
    }
    return trees;
  }

  Future<void> updateAthleteProfile({
    required String token,
    required String userId,
    required DateTime? birthDate,
    required TraineeAssessment? assessment,
    required FitnessLevel fitnessLevel,
    required List<FitnessGoal> goals,
    required ExerciseVenue trainingVenue,
  }) async {
    await _guard(
      () => _cms(token).update(
        CollectionRef.raw(Collections.users.slug),
        userId,
        athleteProfilePayload(
          birthDate: birthDate,
          assessment: assessment,
          fitnessLevel: fitnessLevel,
          goals: goals,
          trainingVenue: trainingVenue,
        ),
      ),
    );
  }

  Future<void> upsertWorkoutSession({
    required String token,
    required WorkoutPlayback playback,
  }) async {
    final exerciseIds = await _exerciseIdMap(token);
    final programId = await _findId(
      token,
      collection: Collections.programs.slug,
      clientId: playback.day.programId,
    );
    final payload = _sessionPayload(playback, exerciseIds, programId);
    final existingId = await _findId(
      token,
      collection: Collections.workoutSessions.slug,
      clientId: playback.session.id,
    );
    final sessions = CollectionRef.raw(Collections.workoutSessions.slug);
    if (existingId == null) {
      await _guard(() => _cms(token).create(sessions, payload));
      return;
    }
    await _guard(() => _cms(token).update(sessions, existingId, payload));
  }

  /// The workout as Payload's workout-sessions collection takes it, built
  /// with the generated input builders so every field name and type is
  /// checked against the schema.
  Map<String, Object?> _sessionPayload(
    WorkoutPlayback playback,
    Map<String, String> exerciseIds,
    String? programId,
  ) {
    final session = playback.session;
    return CmsWorkoutSession.input(
      clientId: session.id,
      deleted: false,
      program: programId == null ? null : Ref.id(programId),
      programDayClientId: playback.day.id,
      startedAt: session.startedAt,
      completedAt: session.completedAt,
      duration: session.duration,
      status: CmsWorkoutSessionStatus(session.status.name),
      notes: session.notes,
      totalVolumeKg: session.totalVolumeKg,
      exercises: [
        for (final result in playback.results)
          // An exercise the server doesn't know can't be referenced.
          if (exerciseIds[result.exerciseId] case final exerciseId?)
            CmsWorkoutSessionExercise(
              clientId: result.id,
              exercise: Ref.id(exerciseId),
              programExerciseClientId: result.programExerciseId,
              sortOrder: result.order,
              plannedSets: result.plannedSets,
              actualSets: result.actualSets,
              plannedRepetitions: result.plannedRepetitions,
              actualRepetitions: result.actualRepetitions,
              plannedDuration: result.plannedDuration,
              actualDuration: result.actualDuration,
              completed: result.completed,
              effort: switch (result.effort) {
                final effort? => CmsWorkoutSessionExerciseEffort(effort.name),
                null => null,
              },
              notes: result.notes,
              personalRecord: result.personalRecord,
              sets: [
                for (final set
                    in playback.setsByResult[result.id] ??
                        const <WorkoutSetResult>[])
                  CmsWorkoutSessionExerciseSet(
                    clientId: set.id,
                    setNumber: set.setNumber,
                    plannedReps: set.plannedReps,
                    actualReps: set.actualReps,
                    plannedDuration: set.plannedDuration,
                    actualDuration: set.actualDuration,
                    plannedLoadKg: set.plannedLoadKg,
                    actualLoadKg: set.actualLoadKg,
                    completed: set.completed,
                  ),
              ],
            ),
      ],
    );
  }

  Future<Map<String, String>> _exerciseIdMap(String token) async {
    final page = await _guard(
      () => _cms(token).find(
        Collections.exercises,
        options: const FindOptions(limit: 100, depth: 0, pagination: false),
      ),
    );
    return {for (final doc in page.docs) ?doc.clientId: doc.id};
  }

  /// The Payload id of the document with [clientId], from any collection
  /// that has one. Raw JSON on purpose: only `id` is read.
  Future<String?> _findId(
    String token, {
    required String collection,
    required String clientId,
  }) async {
    final page = await _guard(
      () => _cms(token).find(
        CollectionRef.raw(collection),
        options: FindOptions(
          limit: 1,
          depth: 0,
          where: {
            'clientId': {'equals': clientId},
          },
        ),
      ),
    );
    return page.docs.isEmpty ? null : page.docs.first['id'] as String?;
  }

  /// Public catalog routes must not send a JWT or `Content-Type` on GET.
  /// `/api/exercises/:id` is a protected document lookup, so a missing custom
  /// collection route comes back as 401/403 instead of 404.
  Future<http.Response> _getPublic(List<String> paths) async {
    final body = await _getPublicOrNull(paths);
    if (body != null) return body;
    throw const AuthException(
      AuthFailure.unknown,
      'Public catalog is not available',
    );
  }

  Future<http.Response?> _getPublicOrNull(List<String> paths) async {
    for (final path in paths) {
      final body = await _send(
        () => _client.get(
          _uri(path),
          headers: const {'Accept': 'application/json'},
        ),
      );
      if (body.statusCode >= 200 && body.statusCode < 300) return body;
      if (!_isMissingPublicRoute(body.statusCode)) {
        _throwIfFailed(body);
      }
    }
    return null;
  }

  bool _isMissingPublicRoute(int statusCode) {
    return statusCode == 401 || statusCode == 403 || statusCode == 404;
  }

  void _throwIfFailed(http.Response body) {
    if (body.statusCode == 401 || body.statusCode == 403) {
      throw const AuthException(AuthFailure.invalidCredentials);
    }
    if (body.statusCode < 200 || body.statusCode >= 300) {
      throw AuthException(AuthFailure.unknown, _errorMessage(body.body));
    }
  }

  AuthSession _sessionFrom(String token, RemoteUser user) {
    if (!user.active) {
      throw const AuthException(AuthFailure.inactive);
    }
    if (!user.isAthlete) {
      throw const AuthException(AuthFailure.notAthlete);
    }
    return AuthSession(token: token, user: user);
  }

  Uri _uri(String path) => Uri.parse('$baseUrl$path');

  Future<http.Response> _send(Future<http.Response> Function() request) async {
    try {
      return await request().timeout(const Duration(seconds: 20));
    } on SocketException {
      throw const AuthException(AuthFailure.network);
    } on TimeoutException {
      throw const AuthException(AuthFailure.network);
    } on http.ClientException {
      throw const AuthException(AuthFailure.network);
    }
  }

  Map<String, dynamic> _decode(String body) {
    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) return decoded;
    return {};
  }

  String? _errorMessage(String body) {
    try {
      final json = _decode(body);
      final errors = json['errors'];
      if (errors is List && errors.isNotEmpty) {
        final first = errors.first;
        if (first is Map && first['message'] is String) {
          return first['message'] as String;
        }
      }
      if (json['message'] is String) return json['message'] as String;
    } catch (_) {}
    return null;
  }
}
