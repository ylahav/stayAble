enum ExerciseCategory {
  warmUp,
  mobility,
  strength,
  cardio,
  stretching,
  coolDown,
}

enum Difficulty { beginner, intermediate, advanced }

enum EquipmentKind {
  none,
  mat,
  resistanceBand,
  dumbbells,
  chair,
  machine,
  barbell,
  cable,
  kettlebell,
  bench,
}

enum ExerciseVenue { home, gym, both }

enum ProgramVenue { home, gym, mixed }

enum PreferredUnits { kg, lbs }

enum ScheduleType { daily, weekly, custom }

enum WorkoutStatus {
  planned,
  started,
  completed,
  partiallyCompleted,
  skipped,
  cancelled,
}

enum PerceivedEffort { easy, good, difficult }

enum FitnessLevel { beginner, intermediate, advanced }

enum FitnessGoal {
  generalFitness,
  strength,
  mobility,
  cardio,
  weightManagement,
}
