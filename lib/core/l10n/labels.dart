import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/localized_text.dart';
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
      return '';
  }
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
