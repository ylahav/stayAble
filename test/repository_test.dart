import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stayable/data/db/app_database.dart'
    hide TrainingProgram, ProgramDay, ProgramExercise;
import 'package:stayable/data/repositories/drift_stayable_repository.dart';
import 'package:stayable/data/seed/seed_data.dart';
import 'package:stayable/domain/entities/enums.dart';
import 'package:stayable/domain/entities/localized_text.dart';
import 'package:stayable/domain/entities/program_day.dart';
import 'package:stayable/domain/entities/program_exercise.dart';
import 'package:stayable/domain/entities/training_program.dart';
import 'package:stayable/domain/repositories/stayable_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('seeds library and can start a Monday workout', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await SeedRunner(db).runIfNeeded(language: 'he');
    final repo = DriftStayAbleRepository(db);

    final user = await repo.getCurrentUser();
    expect(user.language, 'he');

    final exercises = await repo.getExercises();
    expect(exercises.length, greaterThanOrEqualTo(11));
    expect(exercises.first.name.he, isNotEmpty);

    final restDay = await repo.getHomeSnapshot(DateTime(2026, 8, 29));
    expect(restDay.isRestDay, isTrue);

    final monday = await repo.getHomeSnapshot(DateTime(2026, 8, 31));
    expect(monday.isRestDay, isFalse);
    expect(monday.todayExercises, hasLength(11));

    final session = await repo.startOrResumeSession(monday.todayDay!.id);
    expect(session.status, WorkoutStatus.started);

    final playback = await repo.getPlayback(session.id);
    expect(playback.items, hasLength(11));
    expect(playback.results, hasLength(11));
    expect(playback.setsByResult[playback.results.first.id], hasLength(1));

    final squat = playback.results.firstWhere(
      (r) => r.exerciseId == 'ex-squat',
    );
    expect(playback.setsByResult[squat.id], hasLength(2));

    await repo.finishSession(session.id, partial: true);
    final resumed = await repo.resumeSession(session.id);
    expect(resumed.status, WorkoutStatus.started);
    expect(resumed.id, session.id);

    final history = await repo.getHistorySnapshot(DateTime(2026, 8, 31));
    expect(history.sessions, isNotEmpty);
    expect(history.sessions.first.status, WorkoutStatus.started);
  });

  test('keeps every assigned program active', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await SeedRunner(db).runIfNeeded(language: 'en');
    final repo = DriftStayAbleRepository(db);
    final user = await repo.getCurrentUser();
    final now = DateTime(2026, 8, 31);

    RemoteProgramTree tree({
      required String id,
      required ProgramVenue venue,
      required String dayId,
    }) {
      return RemoteProgramTree(
        program: TrainingProgram(
          id: id,
          userId: user.id,
          name: venue == ProgramVenue.home ? 'Home block' : 'Gym block',
          description: '',
          scheduleType: ScheduleType.weekly,
          venue: venue,
          active: true,
          createdAt: now,
          updatedAt: now,
        ),
        days: [
          ProgramDay(
            id: dayId,
            programId: id,
            weekday: DateTime.monday,
            title: const LocalizedText(en: 'Monday', he: 'שני'),
            description: const LocalizedText(en: '', he: ''),
          ),
        ],
        assignments: [
          ProgramExercise(
            id: '$dayId-ex',
            programDayId: dayId,
            exerciseId: 'ex-squat',
            order: 0,
            sets: 2,
            rest: 30,
          ),
        ],
      );
    }

    await repo.upsertAssignedPrograms([
      tree(id: 'prog-home', venue: ProgramVenue.home, dayId: 'day-home-mon'),
      tree(id: 'prog-gym', venue: ProgramVenue.gym, dayId: 'day-gym-mon'),
    ]);

    final programs = await repo.getProgramSnapshot(now);
    expect(programs.programs, hasLength(2));
    expect(
      programs.programs.map((view) => view.program.venue),
      containsAll([ProgramVenue.home, ProgramVenue.gym]),
    );

    final monday = await repo.getHomeSnapshot(now);
    expect(monday.todayWorkouts, hasLength(2));
    expect(monday.todayWorkouts.map((w) => w.program.id), [
      'prog-home',
      'prog-gym',
    ]);
  });
}
