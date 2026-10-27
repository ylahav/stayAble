import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:stayable/data/remote/payload_api.dart';
import 'package:stayable/domain/domain.dart';

/// PayloadApi now talks to Payload through payload_client. These pin down
/// the requests it sends and the errors it throws, which callers rely on.
void main() {
  late List<http.Request> requests;
  late Map<String, (int, Object?)> routes;

  PayloadApi api() => PayloadApi(
    baseUrl: 'http://cms.test',
    client: MockClient((request) async {
      requests.add(request);
      final route = routes['${request.method} ${request.url.path}'];
      if (route == null) {
        return http.Response('{"errors":[{"message":"Not Found"}]}', 404);
      }
      final (status, body) = route;
      return http.Response.bytes(utf8.encode(jsonEncode(body)), status);
    }),
  );

  setUp(() {
    requests = [];
    routes = {};
  });

  Future<AuthFailure?> failureOf(Future<Object?> call) async {
    try {
      await call;
      return null;
    } on AuthException catch (e) {
      return e.failure;
    }
  }

  final trainee = {
    'id': 'u1',
    'email': 'pat@example.com',
    'name': 'פט',
    'roles': ['trainee'],
    'language': 'he',
    'active': true,
  };

  group('auth', () {
    test('login trims the email and returns the session', () async {
      routes['POST /api/users/login'] = (
        200,
        {'token': 'tkn', 'user': trainee},
      );
      final session = await api().login('  pat@example.com ', 'pw');
      expect(session.token, 'tkn');
      expect(session.user.name, 'פט');
      expect(jsonDecode(requests.single.body), {
        'email': 'pat@example.com',
        'password': 'pw',
      });
      expect(requests.single.headers['Authorization'], isNull);
    });

    test(
      'wrong password and malformed email are invalid credentials',
      () async {
        routes['POST /api/users/login'] = (
          401,
          {
            'errors': [
              {'message': 'nope'},
            ],
          },
        );
        expect(
          await failureOf(api().login('a@b.c', 'x')),
          AuthFailure.invalidCredentials,
        );
        routes['POST /api/users/login'] = (
          400,
          {
            'errors': [
              {'message': 'bad email'},
            ],
          },
        );
        expect(
          await failureOf(api().login('a', 'x')),
          AuthFailure.invalidCredentials,
        );
      },
    );

    test('non-trainees and inactive users are refused as before', () async {
      routes['POST /api/users/login'] = (
        200,
        {
          'token': 't',
          'user': {
            ...trainee,
            'roles': ['instructor'],
          },
        },
      );
      expect(
        await failureOf(api().login('a@b.c', 'x')),
        AuthFailure.notAthlete,
      );
      routes['POST /api/users/login'] = (
        200,
        {
          'token': 't',
          'user': {...trainee, 'active': false},
        },
      );
      expect(await failureOf(api().login('a@b.c', 'x')), AuthFailure.inactive);
    });

    test('me sends the token; an expired one is invalid credentials', () async {
      routes['GET /api/users/me'] = (200, {'user': trainee});
      expect((await api().me('tkn')).id, 'u1');
      expect(requests.single.headers['Authorization'], 'JWT tkn');

      routes['GET /api/users/me'] = (200, {'user': null});
      expect(await failureOf(api().me('old')), AuthFailure.invalidCredentials);
    });

    test('logout never throws', () async {
      routes['POST /api/users/logout'] = (
        500,
        {
          'errors': [
            {'message': 'boom'},
          ],
        },
      );
      await api().logout('tkn');
    });
  });

  test('assigned programs: query and result', () async {
    routes['GET /api/program-assignments'] = (
      200,
      {
        'docs': [
          {
            'id': 'a1',
            'scheduleType': 'weekly',
            'program': {
              'id': 'p1',
              'clientId': 'prog-a',
              'name': 'A',
              'exercises': [
                {
                  'clientId': 's1',
                  'exercise': {'id': 'e1', 'clientId': 'ex-squat'},
                  'sets': 3,
                },
              ],
            },
          },
          // Same program again: kept once.
          {
            'id': 'a2',
            'program': {'id': 'p1', 'clientId': 'prog-a', 'name': 'A'},
          },
        ],
      },
    );
    final trees = await api().fetchAssignedPrograms(
      token: 'tkn',
      athleteId: 'u1',
      localUserId: 'local',
    );
    expect(trees, hasLength(1));
    expect(trees.single.assignments, hasLength(3));

    final query = requests.single.url.queryParameters;
    expect(query['where[athlete][equals]'], 'u1');
    expect(query['where[active][equals]'], 'true');
    expect(query['depth'], '2');
    expect(query['limit'], '20');
    expect(query['sort'], '-updatedAt');
  });

  test('profile update PATCHes the user', () async {
    routes['PATCH /api/users/u1'] = (200, {'doc': trainee});
    await api().updateAthleteProfile(
      token: 'tkn',
      userId: 'u1',
      birthDate: DateTime(1986, 9, 25),
      assessment: null,
      fitnessLevel: FitnessLevel.beginner,
      goals: const [FitnessGoal.strength],
      trainingVenue: ExerciseVenue.home,
    );
    final body = jsonDecode(requests.single.body) as Map;
    expect(body['birthDate'], '1986-09-25T00:00:00.000Z');
    expect(body['goals'], ['strength']);
  });

  group('workout session upload', () {
    final now = DateTime.utc(2026, 10, 26, 9);
    final playback = WorkoutPlayback(
      session: WorkoutSession(
        id: 'sess-1',
        userId: 'local',
        programDayId: 'day-mon',
        startedAt: now,
        status: WorkoutStatus.completed,
      ),
      day: const ProgramDay(
        id: 'day-mon',
        programId: 'prog-a',
        title: LocalizedText(en: 'Monday', he: 'שני'),
        description: LocalizedText(en: '', he: ''),
      ),
      program: TrainingProgram(
        id: 'prog-a',
        userId: 'local',
        name: 'A',
        description: '',
        scheduleType: ScheduleType.weekly,
        active: true,
        createdAt: now,
        updatedAt: now,
      ),
      items: const [],
      results: const [],
      setsByResult: const {},
    );

    void lookups({String? existingSession}) {
      routes['GET /api/exercises'] = (
        200,
        {
          'docs': [
            {'id': 'e1', 'clientId': 'ex-squat'},
          ],
        },
      );
      routes['GET /api/programs'] = (
        200,
        {
          'docs': [
            {'id': 'p1'},
          ],
        },
      );
      routes['GET /api/workout-sessions'] = (
        200,
        {
          'docs': [
            if (existingSession != null) {'id': existingSession},
          ],
        },
      );
    }

    test('a new session is created', () async {
      lookups();
      routes['POST /api/workout-sessions'] = (
        201,
        {
          'doc': {'id': 'new'},
        },
      );
      await api().upsertWorkoutSession(token: 'tkn', playback: playback);
      final post = requests.last;
      expect(post.method, 'POST');
      final body = jsonDecode(post.body) as Map;
      expect(body['clientId'], 'sess-1');
      expect(body['program'], 'p1');
      expect(body['status'], 'completed');

      final find = requests.firstWhere(
        (r) => r.url.path == '/api/workout-sessions',
      );
      expect(find.url.queryParameters['where[clientId][equals]'], 'sess-1');
    });

    test('an existing session is updated', () async {
      lookups(existingSession: 'w9');
      routes['PATCH /api/workout-sessions/w9'] = (
        200,
        {
          'doc': {'id': 'w9'},
        },
      );
      await api().upsertWorkoutSession(token: 'tkn', playback: playback);
      expect(requests.last.method, 'PATCH');
      expect(requests.last.url.path, '/api/workout-sessions/w9');
    });
  });

  test('no network is AuthFailure.network', () async {
    final offline = PayloadApi(
      baseUrl: 'http://cms.test',
      client: MockClient((_) async => throw http.ClientException('offline')),
    );
    expect(await failureOf(offline.fetchExercises('tkn')), AuthFailure.network);
    expect(await failureOf(offline.login('a@b.c', 'x')), AuthFailure.network);
  });
}
