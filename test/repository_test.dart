import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stayable/data/db/app_database.dart'
    hide TrainingProgram, ProgramDay, ProgramExercise;
import 'package:stayable/data/repositories/drift_stayable_repository.dart';
import 'package:stayable/data/seed/seed_data.dart';
import 'package:stayable/domain/entities/enums.dart';
import 'package:stayable/domain/entities/trainee_assessment.dart';
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

    final seed = SeedRunner(db);
    await seed.runIfNeeded(language: 'he');
    await seed.seedDemoProgram();
    final repo = DriftStayAbleRepository(db);

    final user = await repo.getCurrentUser();
    expect(user.language, 'he');

    final exercises = await repo.getExercises();
    expect(exercises.length, greaterThanOrEqualTo(11));
    expect(await repo.getExerciseIds(), contains('ex-squat'));
    expect(exercises.first.name.he, isNotEmpty);
    expect(
      exercises.firstWhere((exercise) => exercise.id == 'ex-squat').workoutType,
      WorkoutType.strength,
    );
    expect(
      exercises.firstWhere((exercise) => exercise.id == 'ex-shadow-boxing').workoutType,
      WorkoutType.hiit,
    );

    final homeStrength = await repo.getExercises(
      workoutType: WorkoutType.strength,
      homeCapable: true,
    );
    expect(homeStrength, isNotEmpty);
    expect(
      homeStrength.every(
        (exercise) =>
            exercise.workoutType == WorkoutType.strength && exercise.canDoAtHome,
      ),
      isTrue,
    );
    expect(homeStrength.any((exercise) => exercise.id == 'ex-leg-press'), isFalse);
    expect(homeStrength.any((exercise) => exercise.id == 'ex-squat'), isTrue);

    final restDay = await repo.getHomeSnapshot(
      DateTime(2026, 8, 29),
      localOnly: false,
    );
    expect(restDay.isRestDay, isTrue);

    final monday = await repo.getHomeSnapshot(
      DateTime(2026, 8, 31),
      localOnly: false,
    );
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

    final history = await repo.getHistorySnapshot(
      DateTime(2026, 8, 31),
      localOnly: false,
    );
    expect(history.sessions, isNotEmpty);
    expect(history.sessions.first.status, WorkoutStatus.started);
  });

  test('first run does not create a demo program', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await SeedRunner(db).runIfNeeded(language: 'en');
    final repo = DriftStayAbleRepository(db);
    final monday = await repo.getHomeSnapshot(
      DateTime(2026, 8, 31),
      localOnly: false,
    );
    expect(monday.todayWorkouts, isEmpty);
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

    final programs = await repo.getProgramSnapshot(now, localOnly: false);
    expect(programs.programs, hasLength(2));
    expect(
      programs.programs.map((view) => view.program.venue),
      containsAll([ProgramVenue.home, ProgramVenue.gym]),
    );

    final monday = await repo.getHomeSnapshot(now, localOnly: false);
    expect(monday.todayWorkouts, hasLength(2));
    expect(monday.todayWorkouts.map((w) => w.program.id), [
      'prog-home',
      'prog-gym',
    ]);
  });

  test('keeps local programs off trainer snapshots', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await SeedRunner(db).runIfNeeded(language: 'en');
    final repo = DriftStayAbleRepository(db);
    final now = DateTime(2026, 8, 31);

    final id = await repo.saveLocalProgram(
      const LocalProgramDraft(
        name: 'My block',
        venue: ProgramVenue.home,
        weekdays: [DateTime.monday],
        slotsByWeekday: {
          DateTime.monday: [
            LocalProgramSlot(
              exerciseId: 'ex-squat',
              sets: 2,
              repetitions: 10,
            ),
          ],
        },
      ),
    );
    expect(isLocalProgramId(id), isTrue);

    final cloudHome = await repo.getHomeSnapshot(now, localOnly: false);
    expect(
      cloudHome.todayWorkouts.map((workout) => workout.program.id),
      isNot(contains(id)),
    );

    final localHome = await repo.getHomeSnapshot(now, localOnly: true);
    expect(localHome.todayWorkouts.map((workout) => workout.program.id), [id]);

    final loaded = await repo.getLocalProgram(id);
    expect(loaded?.name, 'My block');
    expect(loaded?.slotsByWeekday[DateTime.monday], hasLength(1));

    await repo.deleteLocalProgram(id);
    final afterDelete = await repo.getProgramSnapshot(now, localOnly: true);
    expect(afterDelete.programs, isEmpty);
  });

  test('occasional local program is available any day', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await SeedRunner(db).runIfNeeded(language: 'en');
    final repo = DriftStayAbleRepository(db);
    final saturday = DateTime(2026, 8, 29);
    final monday = DateTime(2026, 8, 31);

    final id = await repo.saveLocalProgram(
      const LocalProgramDraft(
        name: 'When I want',
        venue: ProgramVenue.home,
        scheduleType: ScheduleType.occasional,
        weekdays: [],
        slotsByWeekday: {
          occasionalSlotKey: [
            LocalProgramSlot(
              exerciseId: 'ex-squat',
              sets: 2,
              repetitions: 10,
            ),
          ],
        },
      ),
    );

    final loaded = await repo.getLocalProgram(id);
    expect(loaded?.scheduleType, ScheduleType.occasional);
    expect(loaded?.weekdays, isEmpty);
    expect(loaded?.slotsByWeekday[occasionalSlotKey], hasLength(1));

    final restDay = await repo.getHomeSnapshot(saturday, localOnly: true);
    expect(restDay.isRestDay, isFalse);
    expect(restDay.todayWorkouts.map((workout) => workout.program.id), [id]);
    expect(restDay.todayWorkouts.first.day.weekday, isNull);

    final weekdayHome = await repo.getHomeSnapshot(monday, localOnly: true);
    expect(weekdayHome.todayWorkouts.map((workout) => workout.program.id), [id]);

    final programs = await repo.getProgramSnapshot(monday, localOnly: true);
    expect(programs.programs, hasLength(1));
    expect(programs.programs.first.days, hasLength(1));
    expect(programs.programs.first.days.first.weekday, isNull);
  });

  test('stores birthday on the current user', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await SeedRunner(db).runIfNeeded(language: 'en');
    final repo = DriftStayAbleRepository(db);
    expect((await repo.getCurrentUser()).birthDate, isNull);

    await repo.setBirthDate(DateTime(1986, 9, 25));
    final user = await repo.getCurrentUser();
    expect(user.birthDate, DateTime(1986, 9, 25));
    expect(user.ageYears(DateTime(2026, 9, 25)), 40);
  });

  test('stores trainee assessment on the current user', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await SeedRunner(db).runIfNeeded(language: 'en');
    final repo = DriftStayAbleRepository(db);
    expect((await repo.getCurrentUser()).assessment, isNull);

    await repo.setAssessment(
      const TraineeAssessment(
        injuries: {InjuryArea.knees},
        background: TrainingBackground.starting,
        goals: [FitnessGoal.generalFitness],
      ),
    );
    final user = await repo.getCurrentUser();
    expect(user.assessment?.injuries, {InjuryArea.knees});
    expect(user.assessment?.background, TrainingBackground.starting);
    expect(user.fitnessLevel, FitnessLevel.beginner);
  });

  test('applies a remote athlete profile onto the signed-in user', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await SeedRunner(db).runIfNeeded(language: 'en');
    final repo = DriftStayAbleRepository(db);
    await repo.ensureSignedInUser(
      id: 'cloud-athlete',
      name: 'Pat',
      email: 'pat@example.com',
      language: 'en',
    );
    await repo.applyRemoteProfile(
      birthDate: DateTime(1986, 9, 25),
      assessment: const TraineeAssessment(
        injuries: {InjuryArea.shoulders},
        goals: [FitnessGoal.bodyToning],
        venue: ProgramVenue.gym,
      ),
    );

    final user = await repo.getCurrentUser();
    expect(user.id, 'cloud-athlete');
    expect(user.birthDate, DateTime(1986, 9, 25));
    expect(user.assessment?.injuries, {InjuryArea.shoulders});
    expect(user.goals, [FitnessGoal.bodyToning]);
    expect(user.trainingVenue, ExerciseVenue.gym);
  });
}
