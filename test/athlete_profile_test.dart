import 'package:flutter_test/flutter_test.dart';
import 'package:stayable/data/remote/athlete_profile.dart';
import 'package:stayable/domain/entities/auth_session.dart';
import 'package:stayable/domain/entities/enums.dart';
import 'package:stayable/domain/entities/trainee_assessment.dart';

void main() {
  test('RemoteUser reads athlete profile fields from Payload', () {
    final user = RemoteUser.fromJson({
      'id': 'u1',
      'email': 'pat@example.com',
      'name': 'Pat',
      'roles': ['trainee'],
      'language': 'he',
      'active': true,
      'birthDate': '1986-09-25T00:00:00.000Z',
      'fitnessLevel': 'beginner',
      'goals': ['generalFitness', 'bodyToning'],
      'trainingVenue': 'home',
      'assessment': {
        'injuries': ['knees'],
        'goals': ['bodyToning'],
        'background': 'starting',
        'venue': 'home',
        'workoutType': 'strength',
        'period': 'weekly',
      },
    });

    expect(user.birthDate, DateTime(1986, 9, 25));
    expect(user.fitnessLevel, FitnessLevel.beginner);
    expect(user.goals, [FitnessGoal.generalFitness, FitnessGoal.bodyToning]);
    expect(user.trainingVenue, ExerciseVenue.home);
    expect(user.assessment?.injuries, {InjuryArea.knees});
    expect(user.assessment?.goals, [FitnessGoal.bodyToning]);
    expect(user.isTrainee, isTrue);
  });

  test('legacy athlete role still counts as trainee', () {
    final user = RemoteUser.fromJson({
      'id': 'u2',
      'email': 'pat@example.com',
      'name': 'Pat',
      'roles': ['athlete'],
      'language': 'en',
      'active': true,
    });
    expect(user.isTrainee, isTrue);
  });

  test('athlete profile PATCH body stores assessment and birthday', () {
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
      goals: const [FitnessGoal.bodyToning],
      trainingVenue: ExerciseVenue.home,
    );

    expect(body['birthDate'], '1986-09-25');
    expect(body['age'], isNotNull);
    expect(body['goals'], ['bodyToning']);
    expect(body['assessment'], assessment.toJson());
    expect(body['conditionNotes'], contains('knees'));
    expect(body['conditionNotes'], contains('heart'));
    expect(body['conditionNotes'], contains('clearance'));
  });
}
