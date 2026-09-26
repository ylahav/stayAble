import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/trainee_assessment.dart';
import '../../domain/entities/localized_text.dart';
import '../../domain/entities/exercise.dart';
import '../../domain/entities/program_exercise.dart';

String localizedName(LocalizedText text, Locale locale) =>
    text.resolve(locale.languageCode);

String categoryLabel(AppLocalizations l10n, ExerciseCategory category) {
  switch (category) {
    case ExerciseCategory.warmUp:
      return l10n.categoryWarmUp;
    case ExerciseCategory.mobility:
      return l10n.categoryMobility;
    case ExerciseCategory.strength:
      return l10n.categoryStrength;
    case ExerciseCategory.cardio:
      return l10n.categoryCardio;
    case ExerciseCategory.stretching:
      return l10n.categoryStretching;
    case ExerciseCategory.coolDown:
      return l10n.categoryCoolDown;
  }
}

String difficultyLabel(AppLocalizations l10n, Difficulty difficulty) {
  switch (difficulty) {
    case Difficulty.beginner:
      return l10n.difficultyBeginner;
    case Difficulty.intermediate:
      return l10n.difficultyIntermediate;
    case Difficulty.advanced:
      return l10n.difficultyAdvanced;
  }
}

String equipmentLabel(AppLocalizations l10n, EquipmentKind equipment) {
  switch (equipment) {
    case EquipmentKind.none:
      return l10n.equipmentNone;
    case EquipmentKind.mat:
      return l10n.equipmentMat;
    case EquipmentKind.resistanceBand:
      return l10n.equipmentResistanceBand;
    case EquipmentKind.dumbbells:
      return l10n.equipmentDumbbells;
    case EquipmentKind.chair:
      return l10n.equipmentChair;
    case EquipmentKind.machine:
      return l10n.equipmentMachine;
    case EquipmentKind.barbell:
      return l10n.equipmentBarbell;
    case EquipmentKind.cable:
      return l10n.equipmentCable;
    case EquipmentKind.kettlebell:
      return l10n.equipmentKettlebell;
    case EquipmentKind.bench:
      return l10n.equipmentBench;
  }
}

String workoutTypeLabel(AppLocalizations l10n, WorkoutType type) {
  switch (type) {
    case WorkoutType.strength:
      return l10n.workoutTypeStrength;
    case WorkoutType.aerobic:
      return l10n.workoutTypeAerobic;
    case WorkoutType.hiit:
      return l10n.workoutTypeHiit;
    case WorkoutType.functional:
      return l10n.workoutTypeFunctional;
  }
}

String venueLabel(AppLocalizations l10n, ExerciseVenue venue) {
  switch (venue) {
    case ExerciseVenue.home:
      return l10n.venueHome;
    case ExerciseVenue.gym:
      return l10n.venueGym;
    case ExerciseVenue.both:
      return l10n.venueBoth;
  }
}

String programVenueLabel(AppLocalizations l10n, ProgramVenue venue) {
  switch (venue) {
    case ProgramVenue.home:
      return l10n.venueHome;
    case ProgramVenue.gym:
      return l10n.venueGym;
    case ProgramVenue.mixed:
      return l10n.venueMixed;
  }
}

String scheduleTypeLabel(AppLocalizations l10n, ScheduleType type) {
  return switch (type) {
    ScheduleType.daily => l10n.wizardPeriodDaily,
    ScheduleType.weekly => l10n.wizardPeriodWeekly,
    ScheduleType.occasional => l10n.wizardPeriodOccasional,
    ScheduleType.custom => l10n.wizardPeriodWeekly,
  };
}

String muscleLabel(AppLocalizations l10n, String key) {
  switch (key) {
    case 'quadriceps':
      return l10n.muscleQuadriceps;
    case 'glutes':
      return l10n.muscleGlutes;
    case 'hamstrings':
      return l10n.muscleHamstrings;
    case 'shoulders':
      return l10n.muscleShoulders;
    case 'chest':
      return l10n.muscleChest;
    case 'core':
      return l10n.muscleCore;
    case 'calves':
      return l10n.muscleCalves;
    case 'hipFlexors':
      return l10n.muscleHipFlexors;
    case 'back':
      return l10n.muscleBack;
    case 'fullBody':
      return l10n.muscleFullBody;
    case 'cardiovascular':
      return l10n.muscleCardiovascular;
    case 'hipMobility':
      return l10n.muscleHipMobility;
    default:
      return key;
  }
}

List<String> exerciseTagKeys(Exercise exercise) {
  return [
    'cat:${exercise.category.name}',
    'type:${exercise.workoutType.name}',
    'venue:${exercise.venue.name}',
    'diff:${exercise.difficulty.name}',
    if (exercise.equipment != EquipmentKind.none)
      'eq:${exercise.equipment.name}',
    for (final muscle in exercise.targetMuscles) 'muscle:$muscle',
  ];
}

String exerciseTagLabel(AppLocalizations l10n, String key) {
  final parts = key.split(':');
  if (parts.length != 2) return key;
  return switch (parts[0]) {
    'cat' => categoryLabel(
        l10n,
        ExerciseCategory.values.firstWhere(
          (value) => value.name == parts[1],
          orElse: () => ExerciseCategory.strength,
        ),
      ),
    'type' => workoutTypeLabel(
        l10n,
        WorkoutType.values.firstWhere(
          (value) => value.name == parts[1],
          orElse: () => WorkoutType.strength,
        ),
      ),
    'venue' => venueLabel(
        l10n,
        ExerciseVenue.values.firstWhere(
          (value) => value.name == parts[1],
          orElse: () => ExerciseVenue.both,
        ),
      ),
    'diff' => difficultyLabel(
        l10n,
        Difficulty.values.firstWhere(
          (value) => value.name == parts[1],
          orElse: () => Difficulty.beginner,
        ),
      ),
    'eq' => equipmentLabel(
        l10n,
        EquipmentKind.values.firstWhere(
          (value) => value.name == parts[1],
          orElse: () => EquipmentKind.none,
        ),
      ),
    'muscle' => muscleLabel(l10n, parts[1]),
    _ => parts[1],
  };
}

String fitnessLevelLabel(AppLocalizations l10n, FitnessLevel level) {
  switch (level) {
    case FitnessLevel.beginner:
      return l10n.difficultyBeginner;
    case FitnessLevel.intermediate:
      return l10n.difficultyIntermediate;
    case FitnessLevel.advanced:
      return l10n.difficultyAdvanced;
  }
}

String fitnessGoalLabel(AppLocalizations l10n, FitnessGoal goal) {
  switch (goal) {
    case FitnessGoal.generalFitness:
      return l10n.goalGeneralFitness;
    case FitnessGoal.strength:
      return l10n.goalStrength;
    case FitnessGoal.mobility:
      return l10n.goalMobility;
    case FitnessGoal.cardio:
      return l10n.goalCardio;
    case FitnessGoal.weightManagement:
      return l10n.goalWeightManagement;
    case FitnessGoal.bodyToning:
      return l10n.goalBodyToning;
  }
}

String injuryAreaLabel(AppLocalizations l10n, InjuryArea area) {
  return switch (area) {
    InjuryArea.knees => l10n.assessInjuryKnees,
    InjuryArea.back => l10n.assessInjuryBack,
    InjuryArea.shoulders => l10n.assessInjuryShoulders,
    InjuryArea.other => l10n.assessInjuryOther,
  };
}

String medicalConditionLabel(AppLocalizations l10n, MedicalCondition condition) {
  return switch (condition) {
    MedicalCondition.heart => l10n.assessConditionHeart,
    MedicalCondition.bloodPressure => l10n.assessConditionBp,
    MedicalCondition.asthma => l10n.assessConditionAsthma,
    MedicalCondition.diabetes => l10n.assessConditionDiabetes,
    MedicalCondition.joints => l10n.assessConditionJoints,
  };
}

String trainingBackgroundLabel(AppLocalizations l10n, TrainingBackground value) {
  return switch (value) {
    TrainingBackground.starting => l10n.assessBackgroundStarting,
    TrainingBackground.returning => l10n.assessBackgroundReturning,
    TrainingBackground.current => l10n.assessBackgroundCurrent,
  };
}

String occupationDemandLabel(AppLocalizations l10n, OccupationDemand value) {
  return switch (value) {
    OccupationDemand.sedentary => l10n.assessOccupationSedentary,
    OccupationDemand.mixed => l10n.assessOccupationMixed,
    OccupationDemand.physical => l10n.assessOccupationPhysical,
  };
}

String goalTimelineLabel(AppLocalizations l10n, GoalTimeline value) {
  return switch (value) {
    GoalTimeline.slow => l10n.assessTimelineSlow,
    GoalTimeline.moderate => l10n.assessTimelineModerate,
    GoalTimeline.fast => l10n.assessTimelineFast,
  };
}

String trainingPreferenceLabel(AppLocalizations l10n, TrainingPreference value) {
  return switch (value) {
    TrainingPreference.freeWeights => l10n.assessPrefFreeWeights,
    TrainingPreference.machines => l10n.assessPrefMachines,
    TrainingPreference.functional => l10n.assessPrefFunctional,
    TrainingPreference.mixed => l10n.assessPrefMixed,
  };
}

String stressLevelLabel(AppLocalizations l10n, StressLevel value) {
  return switch (value) {
    StressLevel.low => l10n.assessStressLow,
    StressLevel.moderate => l10n.assessStressModerate,
    StressLevel.high => l10n.assessStressHigh,
  };
}

String dietHabitLabel(AppLocalizations l10n, DietHabit value) {
  return switch (value) {
    DietHabit.regular => l10n.assessDietRegular,
    DietHabit.specificPlan => l10n.assessDietPlan,
    DietHabit.skipMeals => l10n.assessDietSkip,
  };
}

String lifestyleHabitLabel(AppLocalizations l10n, LifestyleHabit value) {
  return switch (value) {
    LifestyleHabit.none => l10n.assessHabitNone,
    LifestyleHabit.smoking => l10n.assessHabitSmoking,
    LifestyleHabit.alcohol => l10n.assessHabitAlcohol,
    LifestyleHabit.both => l10n.assessHabitBoth,
  };
}

String mobilityLevelLabel(AppLocalizations l10n, MobilityLevel value) {
  return switch (value) {
    MobilityLevel.limited => l10n.assessMobilityLimited,
    MobilityLevel.average => l10n.assessMobilityAverage,
    MobilityLevel.good => l10n.assessMobilityGood,
  };
}

String weekdayLabel(AppLocalizations l10n, int weekday) {
  switch (weekday) {
    case DateTime.monday:
      return l10n.weekdayMon;
    case DateTime.tuesday:
      return l10n.weekdayTue;
    case DateTime.wednesday:
      return l10n.weekdayWed;
    case DateTime.thursday:
      return l10n.weekdayThu;
    case DateTime.friday:
      return l10n.weekdayFri;
    case DateTime.saturday:
      return l10n.weekdaySat;
    case DateTime.sunday:
      return l10n.weekdaySun;
    default:
      return l10n.scheduleAnytime;
  }
}

String programDayLabel(AppLocalizations l10n, int? weekday) {
  if (weekday == null || weekday == occasionalSlotKey) {
    return l10n.scheduleAnytime;
  }
  return weekdayLabel(l10n, weekday);
}

String greeting(AppLocalizations l10n, DateTime now) {
  final hour = now.hour;
  if (hour < 12) return l10n.goodMorning;
  if (hour < 17) return l10n.goodAfternoon;
  return l10n.goodEvening;
}

String statusLabel(AppLocalizations l10n, WorkoutStatus status) {
  switch (status) {
    case WorkoutStatus.planned:
      return l10n.planned;
    case WorkoutStatus.started:
      return l10n.started;
    case WorkoutStatus.completed:
      return l10n.completed;
    case WorkoutStatus.partiallyCompleted:
      return l10n.partiallyCompleted;
    case WorkoutStatus.skipped:
      return l10n.skipped;
    case WorkoutStatus.cancelled:
      return l10n.cancelled;
  }
}

String formatDurationClock(int seconds) {
  final m = (seconds ~/ 60).toString().padLeft(2, '0');
  final s = (seconds % 60).toString().padLeft(2, '0');
  return '$m:$s';
}

int estimatedWorkoutSeconds(Iterable<ProgramExercise> assignments) {
  var total = 0;
  for (final item in assignments) {
    if (item.isTimed) {
      total += item.duration! * item.sets;
    } else {
      total += (item.repetitions ?? 10) * 3 * item.sets;
    }
    if (item.sets > 1) {
      total += item.rest * (item.sets - 1);
    }
  }
  return total;
}

String formatLoadKg(double kg) {
  if (kg == kg.roundToDouble()) return kg.round().toString();
  return kg.toStringAsFixed(1);
}

String prescriptionLabel(AppLocalizations l10n, ProgramExercise assignment) {
  if (assignment.isTimed) {
    final seconds = assignment.duration!;
    if (seconds >= 60 && seconds % 60 == 0) {
      final minutes = seconds ~/ 60;
      if (assignment.sets > 1) {
        return '${assignment.sets} × ${l10n.prescriptionMinutes(minutes)}';
      }
      return l10n.prescriptionMinutes(minutes);
    }
    if (assignment.sets > 1) {
      return '${assignment.sets} × ${l10n.prescriptionDuration(seconds)}';
    }
    return l10n.prescriptionDuration(seconds);
  }
  final reps = l10n.prescriptionSetsReps(
    assignment.sets,
    assignment.repetitions ?? 0,
  );
  if (assignment.loadKg != null) {
    return '$reps · ${formatLoadKg(assignment.loadKg!)} ${l10n.kg}';
  }
  return reps;
}

String formatMinutesTotal(AppLocalizations l10n, int minutes) {
  if (minutes >= 60) {
    return l10n.hoursMinutes(minutes ~/ 60, minutes % 60);
  }
  return '$minutes ${l10n.minutesShort}';
}
