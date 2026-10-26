import 'package:flutter_test/flutter_test.dart';
import 'package:stayable/data/remote/catalog_sync.dart';
import 'package:stayable/data/remote/cms_exercises.dart';
import 'package:stayable/domain/domain.dart';
import 'package:stayable/payload/models.dart';

/// The typed reader has to produce exactly what the map-based one does,
/// so switching fetchExercises over changes nothing on screen.
void main() {
  const baseUrl = 'https://api.example.com';

  final doc = <String, dynamic>{
    'id': '66f0c1',
    'clientId': 'ex-squat',
    'name': {'en': 'Squat', 'he': 'סקוואט'},
    'description': {'en': 'Lower body', 'he': 'פלג גוף תחתון'},
    'instructions': {
      'en': {
        'root': {
          'type': 'root',
          'children': [
            {
              'type': 'paragraph',
              'children': [
                {'type': 'text', 'text': 'Sit back', 'format': 1},
              ],
            },
          ],
        },
      },
      'he': null,
    },
    'safetyNotes': {'en': 'Knees out', 'he': 'ברכיים החוצה'},
    'image': {
      'id': 'm1',
      'url': 'http://localhost:3000/api/media/file/squat.jpg',
    },
    'category': 'strength',
    'difficulty': 'beginner',
    'venue': 'gym',
    'workoutType': 'strength',
    'gymNumber': 7,
    'duration': 45.6,
    'repetitions': 12,
    'targetMuscles': ['quads', 'glutes'],
    'equipment': 'barbell',
    'active': true,
    'createdAt': '2026-09-01T08:00:00.000Z',
    'updatedAt': '2026-10-01T08:00:00.000Z',
  };

  void expectSame(Exercise a, Exercise b) {
    expect(b.id, a.id);
    expect([b.name.en, b.name.he], [a.name.en, a.name.he]);
    expect(
      [b.description.en, b.description.he],
      [a.description.en, a.description.he],
    );
    expect(
      [b.instructions.en, b.instructions.he],
      [a.instructions.en, a.instructions.he],
    );
    expect(
      [b.safetyNotes.en, b.safetyNotes.he],
      [a.safetyNotes.en, a.safetyNotes.he],
    );
    expect(b.photo, a.photo);
    expect(b.category, a.category);
    expect(b.difficulty, a.difficulty);
    expect(b.venue, a.venue);
    expect(b.workoutType, a.workoutType);
    expect(b.gymNumber, a.gymNumber);
    expect(b.duration, a.duration);
    expect(b.repetitions, a.repetitions);
    expect(b.targetMuscles, a.targetMuscles);
    expect(b.equipment, a.equipment);
    expect(b.active, a.active);
    expect(b.createdAt, a.createdAt);
    expect(b.updatedAt, a.updatedAt);
  }

  test('a full exercise reads the same both ways', () {
    final old = exerciseFromPayload(doc, baseUrl);
    final typed = exerciseFromCms(CmsExercise.fromJson(doc), baseUrl);
    expectSame(old, typed);
    // Spot checks, so the comparison isn't only "both equally wrong".
    expect(typed.photo, '$baseUrl/api/media/file/squat.jpg');
    expect(typed.duration, 46);
    expect(typed.instructions.en, contains('<strong>Sit back</strong>'));
  });

  test('a sparse exercise falls back the same way', () {
    final sparse = <String, dynamic>{
      'id': '66f0c2',
      'clientId': 'ex-plank',
      'category': 'cardio',
      'equipment': 'trampoline', // not an EquipmentKind
      'photoPath': 'assets/exercises/plank.png',
      'createdAt': '2026-09-01T08:00:00.000Z',
      'updatedAt': '2026-09-01T08:00:00.000Z',
    };
    final old = exerciseFromPayload(sparse, baseUrl);
    final typed = exerciseFromCms(CmsExercise.fromJson(sparse), baseUrl);
    expectSame(old, typed);
    expect(typed.workoutType, WorkoutType.aerobic);
    expect(typed.equipment, EquipmentKind.none);
    expect(typed.photo, 'assets/exercises/plank.png');
  });
}
