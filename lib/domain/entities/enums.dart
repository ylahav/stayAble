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

enum WorkoutType { strength, aerobic, hiit, functional }

WorkoutType workoutTypeFromCategory(ExerciseCategory category) {
  return switch (category) {
    ExerciseCategory.strength => WorkoutType.strength,
    ExerciseCategory.cardio => WorkoutType.aerobic,
    _ => WorkoutType.functional,
  };
}

enum ProgramVenue { home, gym, mixed }

enum PreferredUnits { kg, lbs }

enum ScheduleType { daily, weekly, custom, occasional }

/// Slot map key for programs that are not bound to a weekday.
const occasionalSlotKey = 0;

bool isAnytimeSchedule(ScheduleType type) => type == ScheduleType.occasional;

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
  bodyToning,
}
