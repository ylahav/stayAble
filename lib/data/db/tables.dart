import 'package:drift/drift.dart';

import '../../domain/entities/enums.dart';
import 'converters.dart';

class Users extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get email => text().nullable()();
  TextColumn get photo => text().nullable()();
  DateTimeColumn get birthDate => dateTime().nullable()();
  TextColumn get gender => text().nullable()();
  TextColumn get fitnessLevel => textEnum<FitnessLevel>()();
  TextColumn get goals => text().map(const GoalListConverter())();
  TextColumn get language => text()();
  TextColumn get trainingVenue =>
      textEnum<ExerciseVenue>().withDefault(const Constant('both'))();
  TextColumn get preferredUnits =>
      textEnum<PreferredUnits>().withDefault(const Constant('kg'))();
  IntColumn get defaultRestSeconds => integer().nullable()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Exercises extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().map(const LocalizedTextConverter())();
  TextColumn get description => text().map(const LocalizedTextConverter())();
  TextColumn get instructions => text().map(const LocalizedTextConverter())();
  TextColumn get photo => text()();
  TextColumn get category => textEnum<ExerciseCategory>()();
  TextColumn get difficulty => textEnum<Difficulty>()();
  IntColumn get duration => integer().nullable()();
  IntColumn get repetitions => integer().nullable()();
  TextColumn get targetMuscles => text().map(const StringListConverter())();
  TextColumn get equipment => textEnum<EquipmentKind>()();
  TextColumn get safetyNotes => text().map(const LocalizedTextConverter())();
  TextColumn get venue =>
      textEnum<ExerciseVenue>().withDefault(const Constant('both'))();
  IntColumn get gymNumber => integer().nullable()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class TrainingPrograms extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get name => text()();
  TextColumn get description => text()();
  DateTimeColumn get startDate => dateTime().nullable()();
  DateTimeColumn get endDate => dateTime().nullable()();
  TextColumn get scheduleType => textEnum<ScheduleType>()();
  TextColumn get venue =>
      textEnum<ProgramVenue>().withDefault(const Constant('home'))();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class ProgramDays extends Table {
  TextColumn get id => text()();
  TextColumn get programId => text().references(TrainingPrograms, #id)();
  DateTimeColumn get date => dateTime().nullable()();
  IntColumn get weekday => integer().nullable()();
  TextColumn get title => text().map(const LocalizedTextConverter())();
  TextColumn get description => text().map(const LocalizedTextConverter())();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class ProgramExercises extends Table {
  TextColumn get id => text()();
  TextColumn get programDayId => text().references(ProgramDays, #id)();
  TextColumn get exerciseId => text().references(Exercises, #id)();
  IntColumn get sortOrder => integer()();
  IntColumn get sets => integer()();
  IntColumn get repetitions => integer().nullable()();
  IntColumn get duration => integer().nullable()();
  RealColumn get loadKg => real().nullable()();
  IntColumn get rest => integer().withDefault(const Constant(0))();
  TextColumn get notes => text().nullable()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class WorkoutSessions extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get programDayId => text().references(ProgramDays, #id)();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  IntColumn get duration => integer().nullable()();
  TextColumn get status => textEnum<WorkoutStatus>()();
  TextColumn get notes => text().nullable()();
  RealColumn get totalVolumeKg => real().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class WorkoutExerciseResults extends Table {
  TextColumn get id => text()();
  TextColumn get workoutSessionId => text().references(WorkoutSessions, #id)();
  TextColumn get exerciseId => text().references(Exercises, #id)();
  TextColumn get programExerciseId => text().references(ProgramExercises, #id)();
  IntColumn get sortOrder => integer()();
  IntColumn get plannedSets => integer()();
  IntColumn get actualSets => integer().withDefault(const Constant(0))();
  IntColumn get plannedRepetitions => integer().nullable()();
  IntColumn get actualRepetitions => integer().nullable()();
  IntColumn get plannedDuration => integer().nullable()();
  IntColumn get actualDuration => integer().nullable()();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  TextColumn get effort => textEnum<PerceivedEffort>().nullable()();
  TextColumn get notes => text().nullable()();
  BoolColumn get personalRecord =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class WorkoutSetResults extends Table {
  TextColumn get id => text()();
  TextColumn get workoutExerciseResultId =>
      text().references(WorkoutExerciseResults, #id)();
  IntColumn get setNumber => integer()();
  IntColumn get plannedReps => integer().nullable()();
  IntColumn get actualReps => integer().nullable()();
  IntColumn get plannedDuration => integer().nullable()();
  IntColumn get actualDuration => integer().nullable()();
  RealColumn get plannedLoadKg => real().nullable()();
  RealColumn get actualLoadKg => real().nullable()();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
