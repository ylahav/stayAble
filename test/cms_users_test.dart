import 'package:flutter_test/flutter_test.dart';
import 'package:stayable/data/remote/cms_users.dart';
import 'package:stayable/domain/domain.dart';
import 'package:stayable/payload/models.dart';

/// remoteUserFromCms has to read users exactly as RemoteUser.fromJson does.
void main() {
  void expectSame(RemoteUser a, RemoteUser b) {
    expect(b.id, a.id);
    expect(b.email, a.email);
    expect(b.name, a.name);
    expect(b.roles, a.roles);
    expect(b.language, a.language);
    expect(b.active, a.active);
    expect(b.birthDate, a.birthDate);
    expect(b.fitnessLevel, a.fitnessLevel);
    expect(b.goals, a.goals);
    expect(b.trainingVenue, a.trainingVenue);
    expect(b.assessment?.injuries, a.assessment?.injuries);
    expect(b.assessment?.goals, a.assessment?.goals);
    expect(b.isTrainee, a.isTrainee);
  }

  RemoteUser typed(Map<String, dynamic> json) =>
      remoteUserFromCms(CmsUser.fromJson(json));

  test('a full athlete profile', () {
    final json = <String, dynamic>{
      'id': 'u1',
      'email': 'pat@example.com',
      'name': 'Pat',
      'roles': ['trainee', 'instructor'],
      'language': 'he',
      'active': true,
      'birthDate': '1986-09-25T00:00:00.000Z',
      'fitnessLevel': 'beginner',
      'level': 'advanced',
      'goals': ['generalFitness', 'bodyToning', 'notAGoal'],
      'trainingVenue': 'home',
      'assessment': {
        'injuries': ['knees'],
        'goals': ['bodyToning'],
        'background': 'starting',
        'venue': 'home',
        'workoutType': 'strength',
        'period': 'weekly',
      },
    };
    expectSame(RemoteUser.fromJson(json), typed(json));
    expect(typed(json).birthDate, DateTime(1986, 9, 25));
    expect(typed(json).goals, [
      FitnessGoal.generalFitness,
      FitnessGoal.bodyToning,
    ]);
  });

  test('legacy athlete role and level fallback', () {
    final json = <String, dynamic>{
      'id': 'u2',
      'roles': ['athlete'],
      'level': 'intermediate',
    };
    expectSame(RemoteUser.fromJson(json), typed(json));
    expect(typed(json).isTrainee, isTrue);
    expect(typed(json).fitnessLevel, FitnessLevel.intermediate);
    expect(typed(json).language, 'en');
  });
}
