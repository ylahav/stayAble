import '../domain/domain.dart' as domain;
import 'db/app_database.dart';

domain.AppUser mapUser(User row) {
  return domain.AppUser(
    id: row.id,
    name: row.name,
    email: row.email,
    photo: row.photo,
    birthDate: row.birthDate,
    gender: row.gender,
    fitnessLevel: row.fitnessLevel,
    goals: row.goals,
    language: row.language,
    trainingVenue: row.trainingVenue,
    preferredUnits: row.preferredUnits,
    defaultRestSeconds: row.defaultRestSeconds,
    active: row.active,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  );
}

domain.Exercise mapExercise(Exercise row) {
  return domain.Exercise(
    id: row.id,
    name: row.name,
    description: row.description,
    instructions: row.instructions,
    photo: row.photo,
    category: row.category,
    difficulty: row.difficulty,
    duration: row.duration,
    repetitions: row.repetitions,
    targetMuscles: row.targetMuscles,
    equipment: row.equipment,
    safetyNotes: row.safetyNotes,
    venue: row.venue,
    gymNumber: row.gymNumber,
    active: row.active,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  );
}

domain.TrainingProgram mapProgram(TrainingProgram row) {
  return domain.TrainingProgram(
    id: row.id,
    userId: row.userId,
    name: row.name,
    description: row.description,
    startDate: row.startDate,
    endDate: row.endDate,
    scheduleType: row.scheduleType,
    venue: row.venue,
    active: row.active,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  );
}

domain.ProgramDay mapProgramDay(ProgramDay row) {
  return domain.ProgramDay(
    id: row.id,
    programId: row.programId,
    date: row.date,
    weekday: row.weekday,
    title: row.title,
    description: row.description,
  );
}

domain.ProgramExercise mapProgramExercise(ProgramExercise row) {
  return domain.ProgramExercise(
    id: row.id,
    programDayId: row.programDayId,
    exerciseId: row.exerciseId,
    order: row.sortOrder,
    sets: row.sets,
    repetitions: row.repetitions,
    duration: row.duration,
    loadKg: row.loadKg,
    rest: row.rest,
    notes: row.notes,
  );
}

domain.WorkoutSession mapSession(WorkoutSession row) {
  return domain.WorkoutSession(
    id: row.id,
    userId: row.userId,
    programDayId: row.programDayId,
    startedAt: row.startedAt,
    completedAt: row.completedAt,
    duration: row.duration,
    status: row.status,
    notes: row.notes,
    totalVolumeKg: row.totalVolumeKg,
  );
}

domain.WorkoutExerciseResult mapExerciseResult(WorkoutExerciseResult row) {
  return domain.WorkoutExerciseResult(
    id: row.id,
    workoutSessionId: row.workoutSessionId,
    exerciseId: row.exerciseId,
    programExerciseId: row.programExerciseId,
    order: row.sortOrder,
    plannedSets: row.plannedSets,
    actualSets: row.actualSets,
    plannedRepetitions: row.plannedRepetitions,
    actualRepetitions: row.actualRepetitions,
    plannedDuration: row.plannedDuration,
    actualDuration: row.actualDuration,
    completed: row.completed,
    effort: row.effort,
    notes: row.notes,
    personalRecord: row.personalRecord,
  );
}

domain.WorkoutSetResult mapSetResult(WorkoutSetResult row) {
  return domain.WorkoutSetResult(
    id: row.id,
    workoutExerciseResultId: row.workoutExerciseResultId,
    setNumber: row.setNumber,
    plannedReps: row.plannedReps,
    actualReps: row.actualReps,
    plannedDuration: row.plannedDuration,
    actualDuration: row.actualDuration,
    plannedLoadKg: row.plannedLoadKg,
    actualLoadKg: row.actualLoadKg,
    completed: row.completed,
  );
}
