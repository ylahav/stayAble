import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:stayable/data/remote/athlete_profile.dart';
import 'package:stayable/data/remote/payload_api.dart';
import 'package:stayable/domain/domain.dart';

/// The workout and profile uploads are built with the generated input
/// builders. The expected JSON below was recorded from the hand-built maps
/// they replaced, so the server receives exactly what it did before.
void main() {
  final now = DateTime.utc(2026, 10, 26, 9, 30);
  final playback = WorkoutPlayback(
    session: WorkoutSession(
      id: 'sess-1',
      userId: 'local',
      programDayId: 'day-mon',
      startedAt: now,
      completedAt: now.add(const Duration(minutes: 42)),
      duration: 2520,
      status: WorkoutStatus.completed,
      notes: 'Felt strong',
      totalVolumeKg: 1234.5,
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
    results: const [
      WorkoutExerciseResult(
        id: 'r1',
        workoutSessionId: 'sess-1',
        exerciseId: 'ex-squat',
        programExerciseId: 'slot-1',
        order: 1,
        plannedSets: 3,
        actualSets: 3,
        plannedRepetitions: 10,
        actualRepetitions: 9,
        completed: true,
        effort: PerceivedEffort.difficult,
        notes: 'Last set hard',
        personalRecord: true,
      ),
      WorkoutExerciseResult(
        id: 'r2',
        workoutSessionId: 'sess-1',
        exerciseId: 'ex-plank',
        programExerciseId: 'slot-2',
        order: 2,
        plannedSets: 2,
        actualSets: 1,
        plannedDuration: 45,
        actualDuration: 40,
        completed: false,
      ),
      // Not on the server: left out.
      WorkoutExerciseResult(
        id: 'r3',
        workoutSessionId: 'sess-1',
        exerciseId: 'ex-unknown',
        programExerciseId: 'slot-3',
        order: 3,
        plannedSets: 1,
        actualSets: 1,
        completed: true,
      ),
    ],
    setsByResult: const {
      'r1': [
        WorkoutSetResult(
          id: 's1',
          workoutExerciseResultId: 'r1',
          setNumber: 1,
          plannedReps: 10,
          actualReps: 10,
          plannedLoadKg: 40,
          actualLoadKg: 42.5,
          completed: true,
        ),
        WorkoutSetResult(
          id: 's2',
          workoutExerciseResultId: 'r1',
          setNumber: 2,
          plannedReps: 10,
          actualReps: 8,
          completed: true,
        ),
      ],
      'r2': [
        WorkoutSetResult(
          id: 's3',
          workoutExerciseResultId: 'r2',
          setNumber: 1,
          plannedDuration: 45,
          actualDuration: 40,
          completed: false,
        ),
      ],
    },
  );

  test('a full workout goes up exactly as before', () async {
    Object? posted;
    final api = PayloadApi(
      baseUrl: 'http://cms.test',
      client: MockClient((request) async {
        final path = request.url.path;
        final Object body;
        if (request.method == 'POST' && path == '/api/workout-sessions') {
          posted = jsonDecode(request.body);
          body = {
            'doc': {'id': 'w1'},
          };
        } else if (path == '/api/exercises') {
          body = {
            'docs': [
              {'id': 'e1', 'clientId': 'ex-squat'},
              {'id': 'e2', 'clientId': 'ex-plank'},
            ],
          };
        } else if (path == '/api/programs') {
          body = {
            'docs': [
              {'id': 'p1'},
            ],
          };
        } else {
          body = {'docs': <Object?>[]};
        }
        return http.Response(jsonEncode(body), 200);
      }),
    );
    await api.upsertWorkoutSession(token: 't', playback: playback);
    expect(posted, {
      'clientId': 'sess-1',
      'deleted': false,
      'program': 'p1',
      'programDayClientId': 'day-mon',
      'startedAt': '2026-10-26T09:30:00.000Z',
      'completedAt': '2026-10-26T10:12:00.000Z',
      'duration': 2520,
      'status': 'completed',
      'notes': 'Felt strong',
      'totalVolumeKg': 1234.5,
      'exercises': [
        {
          'clientId': 'r1',
          'exercise': 'e1',
          'programExerciseClientId': 'slot-1',
          'sortOrder': 1,
          'plannedSets': 3,
          'actualSets': 3,
          'plannedRepetitions': 10,
          'actualRepetitions': 9,
          'completed': true,
          'effort': 'difficult',
          'notes': 'Last set hard',
          'personalRecord': true,
          'sets': [
            {
              'clientId': 's1',
              'setNumber': 1,
              'plannedReps': 10,
              'actualReps': 10,
              'plannedLoadKg': 40.0,
              'actualLoadKg': 42.5,
              'completed': true,
            },
            {
              'clientId': 's2',
              'setNumber': 2,
              'plannedReps': 10,
              'actualReps': 8,
              'completed': true,
            },
          ],
        },
        {
          'clientId': 'r2',
          'exercise': 'e2',
          'programExerciseClientId': 'slot-2',
          'sortOrder': 2,
          'plannedSets': 2,
          'actualSets': 1,
          'plannedDuration': 45,
          'actualDuration': 40,
          'completed': false,
          'personalRecord': false,
          'sets': [
            {
              'clientId': 's3',
              'setNumber': 1,
              'plannedDuration': 45,
              'actualDuration': 40,
              'completed': false,
            },
          ],
        },
      ],
    });
  });

  test('the profile update goes up as before', () {
    const assessment = TraineeAssessment(
      injuries: {InjuryArea.knees},
      conditions: {MedicalCondition.heart},
      needsClearance: true,
      goals: [FitnessGoal.bodyToning],
    );
    final body = athleteProfilePayload(
      birthDate: DateTime(1986, 9, 25),
      assessment: assessment,
      fitnessLevel: FitnessLevel.beginner,
      goals: const [FitnessGoal.bodyToning, FitnessGoal.strength],
      trainingVenue: ExerciseVenue.home,
    );
    // Age moves with the calendar, so it's checked against the same helper.
    expect(body['age'], ageYearsFromBirthDate(DateTime(1986, 9, 25)));
    expect(jsonDecode(jsonEncode({...body}..remove('age'))), {
      // Was the date-only '1986-09-25'; Payload stores the same instant.
      'birthDate': '1986-09-25T00:00:00.000Z',
      'fitnessLevel': 'beginner',
      'level': 'beginner',
      'goals': ['bodyToning', 'strength'],
      'trainingVenue': 'home',
      'assessment': {
        'injuries': ['knees'],
        'conditions': ['heart'],
        'medicationsAffecting': false,
        'needsClearance': true,
        'goals': ['bodyToning'],
        'timeline': 'moderate',
        'preferences': ['mixed'],
        'background': 'starting',
        'occupation': 'sedentary',
        'mobility': 'average',
        'weekdays': [1, 3, 5],
        'sessionMinutes': 45,
        'sleepHours': 7,
        'stress': 'moderate',
        'diet': 'regular',
        'habits': 'none',
        'venue': 'home',
        'workoutType': 'strength',
        'period': 'weekly',
      },
      'conditionNotes':
          'Injuries: knees. Conditions: heart. Needs medical clearance',
    });
  });

  test('a profile without a birthday or assessment leaves them out', () {
    final body = athleteProfilePayload(
      birthDate: null,
      assessment: null,
      fitnessLevel: FitnessLevel.advanced,
      goals: const [],
      trainingVenue: ExerciseVenue.gym,
    );
    expect(body.keys, isNot(contains('birthDate')));
    expect(body.keys, isNot(contains('assessment')));
    expect(body.keys, isNot(contains('conditionNotes')));
    expect(body['goals'], <Object?>[]);
  });
}
