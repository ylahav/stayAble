import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../domain/entities/enums.dart';
import '../../domain/entities/localized_text.dart';
import 'converters.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Users,
    Exercises,
    TrainingPrograms,
    ProgramDays,
    ProgramExercises,
    WorkoutSessions,
    WorkoutExerciseResults,
    WorkoutSetResults,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _open());

  static QueryExecutor _open() {
    return driftDatabase(name: 'stayable');
  }

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(users, users.trainingVenue);
            await m.addColumn(users, users.preferredUnits);
            await m.addColumn(users, users.defaultRestSeconds);
            await m.addColumn(exercises, exercises.venue);
            await m.addColumn(exercises, exercises.gymNumber);
            await m.addColumn(trainingPrograms, trainingPrograms.venue);
            await m.addColumn(programExercises, programExercises.loadKg);
            await m.addColumn(workoutSessions, workoutSessions.totalVolumeKg);
            await m.addColumn(
              workoutExerciseResults,
              workoutExerciseResults.personalRecord,
            );
            await m.addColumn(workoutSetResults, workoutSetResults.plannedLoadKg);
            await m.addColumn(workoutSetResults, workoutSetResults.actualLoadKg);
          }
          if (from < 3) {
            await m.addColumn(programExercises, programExercises.active);
          }
        },
      );
}
