import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../domain/domain.dart';
import 'athlete_profile.dart';
import 'catalog_check.dart';
import 'catalog_sync.dart';
import 'payload_config.dart';

class PayloadApi {
  PayloadApi({http.Client? client, String? baseUrl})
    : _client = client ?? http.Client(),
      baseUrl = baseUrl ?? resolvePayloadUrl();

  final http.Client _client;
  final String baseUrl;

  Future<AuthSession> login(String email, String password) async {
    final body = await _send(
      () => _client.post(
        _uri('/api/users/login'),
        headers: _jsonHeaders(),
        body: jsonEncode({'email': email.trim(), 'password': password}),
      ),
    );
    if (body.statusCode == 401 || body.statusCode == 400) {
      throw const AuthException(AuthFailure.invalidCredentials);
    }
    if (body.statusCode < 200 || body.statusCode >= 300) {
      throw AuthException(AuthFailure.unknown, _errorMessage(body.body));
    }

    final json = _decode(body.body);
    final token = json['token'] as String?;
    final userJson = json['user'];
    if (token == null || userJson is! Map<String, dynamic>) {
      throw const AuthException(AuthFailure.unknown);
    }
    return _sessionFrom(token, RemoteUser.fromJson(userJson));
  }

  Future<RemoteUser> me(String token) async {
    final body = await _send(
      () => _client.get(
        _uri('/api/users/me'),
        headers: _jsonHeaders(token: token),
      ),
    );
    if (body.statusCode == 401 || body.statusCode == 403) {
      throw const AuthException(AuthFailure.invalidCredentials);
    }
    if (body.statusCode < 200 || body.statusCode >= 300) {
      throw AuthException(AuthFailure.unknown, _errorMessage(body.body));
    }
    final json = _decode(body.body);
    final userJson = json['user'] is Map<String, dynamic>
        ? json['user'] as Map<String, dynamic>
        : json;
    return RemoteUser.fromJson(userJson);
  }

  Future<void> logout(String token) async {
    try {
      await _send(
        () => _client.post(
          _uri('/api/users/logout'),
          headers: _jsonHeaders(token: token),
        ),
      );
    } catch (_) {
      // Local sign-out still proceeds.
    }
  }

  Future<List<Exercise>> fetchExercises(String token) async {
    return _exercisesFrom(
      await _read(
        token,
        path: '/api/exercises',
        query: {
          'limit': '300',
          'depth': '1',
          'pagination': 'false',
          'where[deleted][not_equals]': 'true',
        },
      ),
    );
  }

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
          items.add(exerciseFromPayload(Map<String, dynamic>.from(doc), baseUrl));
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
    final json = await _read(
      token,
      path: '/api/program-assignments',
      query: {
        'limit': '20',
        'depth': '2',
        'where[athlete][equals]': athleteId,
        'where[active][equals]': 'true',
        'sort': '-updatedAt',
      },
    );
    final docs = json['docs'];
    if (docs is! List || docs.isEmpty) return const [];
    final trees = <RemoteProgramTree>[];
    final seen = <String>{};
    for (final doc in docs) {
      if (doc is! Map) continue;
      final assignment = Map<String, dynamic>.from(doc);
      final program = assignment['program'];
      if (program is! Map) continue;
      final tree = programFromPayload(
        Map<String, dynamic>.from(program),
        localUserId,
        assignment: assignment,
      );
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
    await _write(
      token,
      method: 'PATCH',
      path: '/api/users/$userId',
      body: athleteProfilePayload(
        birthDate: birthDate,
        assessment: assessment,
        fitnessLevel: fitnessLevel,
        goals: goals,
        trainingVenue: trainingVenue,
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
      collection: 'programs',
      clientId: playback.day.programId,
    );
    final payload = _sessionPayload(playback, exerciseIds, programId);
    final existingId = await _findId(
      token,
      collection: 'workout-sessions',
      clientId: playback.session.id,
    );
    if (existingId == null) {
      await _write(
        token,
        method: 'POST',
        path: '/api/workout-sessions',
        body: payload,
      );
      return;
    }
    await _write(
      token,
      method: 'PATCH',
      path: '/api/workout-sessions/$existingId',
      body: payload,
    );
  }

  Map<String, dynamic> _sessionPayload(
    WorkoutPlayback playback,
    Map<String, String> exerciseIds,
    String? programId,
  ) {
    final session = playback.session;
    return {
      'clientId': session.id,
      'deleted': false,
      'program': ?programId,
      'programDayClientId': playback.day.id,
      'startedAt': session.startedAt.toUtc().toIso8601String(),
      if (session.completedAt != null)
        'completedAt': session.completedAt!.toUtc().toIso8601String(),
      if (session.duration != null) 'duration': session.duration,
      'status': session.status.name,
      if (session.notes != null) 'notes': session.notes,
      if (session.totalVolumeKg != null) 'totalVolumeKg': session.totalVolumeKg,
      'exercises': [
        for (final result in playback.results)
          if (exerciseIds[result.exerciseId] != null)
            {
              'clientId': result.id,
              'exercise': exerciseIds[result.exerciseId],
              'programExerciseClientId': result.programExerciseId,
              'sortOrder': result.order,
              'plannedSets': result.plannedSets,
              'actualSets': result.actualSets,
              if (result.plannedRepetitions != null)
                'plannedRepetitions': result.plannedRepetitions,
              if (result.actualRepetitions != null)
                'actualRepetitions': result.actualRepetitions,
              if (result.plannedDuration != null)
                'plannedDuration': result.plannedDuration,
              if (result.actualDuration != null)
                'actualDuration': result.actualDuration,
              'completed': result.completed,
              if (result.effort != null) 'effort': result.effort!.name,
              if (result.notes != null) 'notes': result.notes,
              'personalRecord': result.personalRecord,
              'sets': [
                for (final set
                    in playback.setsByResult[result.id] ??
                        const <WorkoutSetResult>[])
                  {
                    'clientId': set.id,
                    'setNumber': set.setNumber,
                    if (set.plannedReps != null) 'plannedReps': set.plannedReps,
                    if (set.actualReps != null) 'actualReps': set.actualReps,
                    if (set.plannedDuration != null)
                      'plannedDuration': set.plannedDuration,
                    if (set.actualDuration != null)
                      'actualDuration': set.actualDuration,
                    if (set.plannedLoadKg != null)
                      'plannedLoadKg': set.plannedLoadKg,
                    if (set.actualLoadKg != null)
                      'actualLoadKg': set.actualLoadKg,
                    'completed': set.completed,
                  },
              ],
            },
      ],
    };
  }

  Future<Map<String, String>> _exerciseIdMap(String token) async {
    final json = await _read(
      token,
      path: '/api/exercises',
      query: {'limit': '100', 'depth': '0', 'pagination': 'false'},
    );
    final docs = json['docs'];
    final map = <String, String>{};
    if (docs is List) {
      for (final doc in docs) {
        if (doc is Map<String, dynamic>) {
          final clientId = doc['clientId'] as String?;
          final id = doc['id'] as String?;
          if (clientId != null && id != null) map[clientId] = id;
        }
      }
    }
    return map;
  }

  Future<String?> _findId(
    String token, {
    required String collection,
    required String clientId,
  }) async {
    final json = await _read(
      token,
      path: '/api/$collection',
      query: {'limit': '1', 'depth': '0', 'where[clientId][equals]': clientId},
    );
    final docs = json['docs'];
    if (docs is List && docs.isNotEmpty && docs.first is Map<String, dynamic>) {
      return (docs.first as Map<String, dynamic>)['id'] as String?;
    }
    return null;
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
        () => _client.get(_uri(path), headers: const {'Accept': 'application/json'}),
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

  Future<Map<String, dynamic>> _read(
    String token, {
    required String path,
    Map<String, String>? query,
  }) async {
    final uri = _uri(path).replace(queryParameters: query);
    final body = await _send(
      () => _client.get(uri, headers: _jsonHeaders(token: token)),
    );
    _throwIfFailed(body);
    return _decode(body.body);
  }

  Future<void> _write(
    String token, {
    required String method,
    required String path,
    required Map<String, dynamic> body,
  }) async {
    final encoded = jsonEncode(body);
    final response = await _send(() {
      if (method == 'PATCH') {
        return _client.patch(
          _uri(path),
          headers: _jsonHeaders(token: token),
          body: encoded,
        );
      }
      return _client.post(
        _uri(path),
        headers: _jsonHeaders(token: token),
        body: encoded,
      );
    });
    _throwIfFailed(response);
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

  Map<String, String> _jsonHeaders({String? token}) {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'JWT $token',
    };
  }

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
