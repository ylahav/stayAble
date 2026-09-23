class WorkoutSetResult {
  const WorkoutSetResult({
    required this.id,
    required this.workoutExerciseResultId,
    required this.setNumber,
    this.plannedReps,
    this.actualReps,
    this.plannedDuration,
    this.actualDuration,
    this.plannedLoadKg,
    this.actualLoadKg,
    required this.completed,
  });

  final String id;
  final String workoutExerciseResultId;
  final int setNumber;
  final int? plannedReps;
  final int? actualReps;
  final int? plannedDuration;
  final int? actualDuration;
  final double? plannedLoadKg;
  final double? actualLoadKg;
  final bool completed;

  WorkoutSetResult copyWith({
    int? actualReps,
    int? actualDuration,
    double? actualLoadKg,
    bool? completed,
  }) {
    return WorkoutSetResult(
      id: id,
      workoutExerciseResultId: workoutExerciseResultId,
      setNumber: setNumber,
      plannedReps: plannedReps,
      actualReps: actualReps ?? this.actualReps,
      plannedDuration: plannedDuration,
      actualDuration: actualDuration ?? this.actualDuration,
      plannedLoadKg: plannedLoadKg,
      actualLoadKg: actualLoadKg ?? this.actualLoadKg,
      completed: completed ?? this.completed,
    );
  }
}
