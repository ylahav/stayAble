import 'package:flutter_test/flutter_test.dart';
import 'package:stayable/data/remote/cms_programs.dart';
import 'package:stayable/domain/domain.dart';
import 'package:stayable/payload/models.dart';

/// Expected values were recorded from the map-based programFromPayload
/// this replaced, so the typed reader keeps building the same trees.
void main() {
  Map<String, dynamic> exercise(String clientId) => {
    'id': 'mongo-$clientId',
    'clientId': clientId,
    'name': {'en': clientId, 'he': ''},
  };

  final program = <String, dynamic>{
    'id': 'p1',
    'clientId': 'prog-strength',
    'name': 'Strength A',
    'description': 'Three days',
    'venue': 'gym',
    'active': true,
    'createdAt': '2026-09-01T08:00:00.000Z',
    'updatedAt': '2026-09-02T08:00:00.000Z',
    'exercises': [
      {
        'id': 'r1',
        'clientId': 'slot-1',
        'exercise': exercise('ex-squat'),
        'sortOrder': 1,
        'sets': 3,
        'repetitions': 10,
        'loadKg': 40,
        'rest': 90,
      },
      {
        'id': 'r2',
        'clientId': 'slot-2',
        'exercise': exercise('ex-plank'),
        'sortOrder': 2,
        'duration': 45.4,
        'notes': 'Brace',
      },
      // Exercise not populated: skipped.
      {'id': 'r3', 'clientId': 'slot-3', 'exercise': 'mongo-ex-row'},
    ],
  };

  RemoteProgramTree read(Map<String, dynamic> extra) => programFromCms(
    CmsProgramAssignment.fromJson({
      'id': 'a1',
      'program': program,
      'athlete': 'u1',
      'active': true,
      'startDate': '2026-10-01T00:00:00.000Z',
      'updatedAt': '2026-10-05T08:00:00.000Z',
      ...extra,
    }),
    'local-user',
  )!;

  test('listed schedule days and refinements', () {
    final tree = read({
      'scheduleType': 'custom',
      'scheduleDays': [
        {'id': 's1', 'clientId': 'mon', 'weekday': 1},
        {'id': 's2', 'weekday': 4},
        {'id': 's3', 'date': '2026-10-20T00:00:00.000Z'},
        {'id': 's4'}, // neither weekday nor date: skipped
      ],
      'refinements': [
        {
          'id': 'f1',
          'programExerciseClientId': 'slot-1',
          'sets': 5,
          'loadKg': 42.5,
        },
        {'id': 'f2', 'programExerciseClientId': '', 'sets': 9},
      ],
    });

    final p = tree.program;
    expect(p.id, 'prog-strength');
    expect(p.userId, 'local-user');
    expect(p.name, 'Strength A');
    expect(p.scheduleType, ScheduleType.custom);
    expect(p.venue, ProgramVenue.gym);
    expect(p.startDate, DateTime.utc(2026, 10, 1));
    expect(p.createdAt, DateTime.utc(2026, 9, 1, 8));
    // The assignment's update time wins over the program's.
    expect(p.updatedAt, DateTime.utc(2026, 10, 5, 8));

    expect(
      [for (final d in tree.days) (d.id, d.weekday, d.date, d.title.en)],
      [
        ('mon', 1, null, 'Monday'),
        ('day-4', 4, null, 'Thursday'),
        ('day-3', null, DateTime.utc(2026, 10, 20), 'Strength A'),
      ],
    );

    // 3 days × 2 populated slots, in day order.
    expect(tree.assignments.map((a) => a.id), [
      'mon-slot-1',
      'mon-slot-2',
      'day-4-slot-1',
      'day-4-slot-2',
      'day-3-slot-1',
      'day-3-slot-2',
    ]);
    final squat = tree.assignments[0];
    expect(
      (squat.exerciseId, squat.order, squat.sets, squat.repetitions),
      ('ex-squat', 1, 5, 10),
    );
    expect((squat.duration, squat.loadKg, squat.rest), (null, 42.5, 90));
    final plank = tree.assignments[1];
    expect(
      (plank.exerciseId, plank.order, plank.sets, plank.repetitions),
      ('ex-plank', 2, 1, null),
    );
    expect(
      (plank.duration, plank.loadKg, plank.rest, plank.notes),
      (45, null, 0, 'Brace'),
    );
  });

  test('weekly default when no days are listed', () {
    final tree = read({'scheduleType': 'weekly'});
    expect(tree.days.map((d) => d.id), ['day-mon', 'day-wed', 'day-fri']);
    expect(tree.days.map((d) => d.weekday), [1, 3, 5]);
  });

  test('daily default', () {
    final tree = read({'scheduleType': 'daily'});
    expect(tree.days.map((d) => d.id), [
      for (var day = 1; day <= 7; day++) 'prog-strength-day-$day',
    ]);
  });

  test('missing scheduleType falls back to weekly', () {
    final tree = read({});
    expect(tree.program.scheduleType, ScheduleType.weekly);
    expect(tree.days.map((d) => d.id), ['day-mon', 'day-wed', 'day-fri']);
  });

  test('an unpopulated program is skipped', () {
    expect(
      programFromCms(
        CmsProgramAssignment.fromJson({'id': 'a1', 'program': 'p1'}),
        'local-user',
      ),
      isNull,
    );
  });
}
