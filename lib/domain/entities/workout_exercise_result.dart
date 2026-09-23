import 'enums.dart';

class WorkoutExerciseResult {
  const WorkoutExerciseResult({
    required this.id,
    required this.workoutSessionId,
    required this.exerciseId,
    required this.programExerciseId,
    required this.order,
    required this.plannedSets,
    required this.actualSets,
    this.plannedRepetitions,
    this.actualRepetitions,
    this.plannedDuration,
    this.actualDuration,
    required this.completed,
    this.effort,
    this.notes,
    this.personalRecord = false,
  });

  final String id;
  final String workoutSessionId;
  final String exerciseId;
  final String programExerciseId;
  final int order;
  final int plannedSets;
  final int actualSets;
  final int? plannedRepetitions;
  final int? actualRepetitions;
  final int? plannedDuration;
  final int? actualDuration;
  final bool completed;
  final PerceivedEffort? effort;
  final String? notes;
  final bool personalRecord;

  WorkoutExerciseResult copyWith({
    int? actualSets,
    int? actualRepetitions,
    int? actualDuration,
    bool? completed,
    PerceivedEffort? effort,
    String? notes,
  }) {
    return WorkoutExerciseResult(
      id: id,
      workoutSessionId: workoutSessionId,
      exerciseId: exerciseId,
      programExerciseId: programExerciseId,
      order: order,
      plannedSets: plannedSets,
      actualSets: actualSets ?? this.actualSets,
      plannedRepetitions: plannedRepetitions,
      actualRepetitions: actualRepetitions ?? this.actualRepetitions,
      plannedDuration: plannedDuration,
      actualDuration: actualDuration ?? this.actualDuration,
      completed: completed ?? this.completed,
      effort: effort ?? this.effort,
      notes: notes ?? this.notes,
    );
  }
}
