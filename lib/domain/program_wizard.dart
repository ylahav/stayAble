import 'entities/enums.dart';
import 'entities/exercise.dart';
import 'entities/trainee_assessment.dart';
import 'repositories/stayable_repository.dart';

class ProgramWizardAnswers {
  const ProgramWizardAnswers({
    required this.venue,
    required this.workoutType,
    required this.age,
    required this.status,
    required this.goals,
    required this.period,
    this.weekdays = const [],
    this.sessionMinutes = 45,
    this.assessment,
  });

  final ProgramVenue venue;
  final WorkoutType workoutType;
  final int age;
  final FitnessLevel status;
  final List<FitnessGoal> goals;
  final ScheduleType period;
  final List<int> weekdays;
  final int sessionMinutes;
  final TraineeAssessment? assessment;
}

class GeneratedLocalProgram {
  const GeneratedLocalProgram({
    required this.name,
    required this.venue,
    required this.scheduleType,
    required this.weekdays,
    required this.slotsByWeekday,
  });

  final String name;
  final ProgramVenue venue;
  final ScheduleType scheduleType;
  final List<int> weekdays;
  final Map<int, List<LocalProgramSlot>> slotsByWeekday;

  LocalProgramDraft toDraft() {
    return LocalProgramDraft(
      name: name,
      venue: venue,
      scheduleType: scheduleType,
      weekdays: weekdays,
      slotsByWeekday: slotsByWeekday,
    );
  }
}

class ProgramWizardException implements Exception {
  const ProgramWizardException();
}

GeneratedLocalProgram generateLocalProgram({
  required ProgramWizardAnswers answers,
  required List<Exercise> catalog,
  String language = 'en',
}) {
  final usable = catalog.where((exercise) {
    if (!exercise.active) return false;
    if (!_fitsVenue(exercise, answers.venue)) return false;
    return _fitsAssessment(exercise, answers.assessment);
  }).toList();
  if (usable.isEmpty) throw const ProgramWizardException();

  final cap = _difficultyCap(answers);
  usable.sort((a, b) {
    final score = _difficultyScore(a, cap) - _difficultyScore(b, cap);
    if (score != 0) return score;
    return a.id.compareTo(b.id);
  });

  final warmups = _ofCategories(usable, const {
    ExerciseCategory.warmUp,
    ExerciseCategory.mobility,
  });
  final mobility = _ofCategories(usable, const {ExerciseCategory.mobility});
  final cooldowns = _ofCategories(usable, const {
    ExerciseCategory.coolDown,
    ExerciseCategory.stretching,
  });
  var mains = usable
      .where(
        (exercise) =>
            exercise.workoutType == answers.workoutType &&
            exercise.category != ExerciseCategory.warmUp &&
            exercise.category != ExerciseCategory.coolDown &&
            exercise.category != ExerciseCategory.stretching,
      )
      .toList();
  if (mains.length < 3) {
    mains = usable
        .where(
          (exercise) =>
              exercise.category != ExerciseCategory.warmUp &&
              exercise.category != ExerciseCategory.coolDown,
        )
        .toList();
  }
  if (mains.isEmpty) throw const ProgramWizardException();

  final weekdays = weekdaysFor(answers);
  final mainCount = _mainCount(answers);
  final extraMobility = answers.age >= 55 ||
      answers.goals.contains(FitnessGoal.mobility) ||
      answers.assessment?.occupation == OccupationDemand.sedentary ||
      answers.assessment?.hasBackIssue == true ||
      answers.assessment?.mobility == MobilityLevel.limited;
  final extraCardio = answers.goals.contains(FitnessGoal.cardio) &&
      answers.workoutType == WorkoutType.strength;
  final cardio = usable
      .where(
        (exercise) =>
            exercise.workoutType == WorkoutType.aerobic ||
            exercise.category == ExerciseCategory.cardio,
      )
      .toList();

  final slots = <int, List<LocalProgramSlot>>{};
  for (var dayIndex = 0; dayIndex < weekdays.length; dayIndex++) {
    final day = <Exercise>[];
    void add(Exercise? exercise) {
      if (exercise == null) return;
      if (day.any((item) => item.id == exercise.id)) return;
      day.add(exercise);
    }

    add(_pick(warmups, dayIndex));
    if (extraMobility) add(_pick(mobility, dayIndex + 1));
    for (var i = 0; i < mainCount; i++) {
      add(_pick(mains, dayIndex * mainCount + i));
    }
    if (extraCardio) add(_pick(cardio, dayIndex));
    add(_pick(cooldowns, dayIndex));
    if (day.isEmpty) throw const ProgramWizardException();
    slots[weekdays[dayIndex]] = [
      for (final exercise in day) _slotFor(exercise, answers),
    ];
  }

  return GeneratedLocalProgram(
    name: _programName(answers, language),
    venue: answers.venue,
    scheduleType: answers.period,
    weekdays: weekdays,
    slotsByWeekday: slots,
  );
}

List<int> weekdaysFor(ProgramWizardAnswers answers) {
  if (isAnytimeSchedule(answers.period)) {
    return const [occasionalSlotKey];
  }
  if (answers.period == ScheduleType.weekly) {
    final chosen = [
      for (final weekday in answers.weekdays)
        if (weekday >= DateTime.monday && weekday <= DateTime.sunday) weekday,
    ]..sort();
    if (chosen.isNotEmpty) return chosen;
  }
  if (answers.period == ScheduleType.daily) {
    if (answers.age >= 65) {
      return const [
        DateTime.monday,
        DateTime.tuesday,
        DateTime.wednesday,
        DateTime.thursday,
        DateTime.friday,
      ];
    }
    return const [
      DateTime.monday,
      DateTime.tuesday,
      DateTime.wednesday,
      DateTime.thursday,
      DateTime.friday,
      DateTime.saturday,
      DateTime.sunday,
    ];
  }
  if (answers.age >= 65 || answers.status == FitnessLevel.beginner) {
    return const [DateTime.monday, DateTime.wednesday, DateTime.friday];
  }
  if (answers.status == FitnessLevel.intermediate) {
    return const [
      DateTime.monday,
      DateTime.tuesday,
      DateTime.thursday,
      DateTime.saturday,
    ];
  }
  return const [
    DateTime.monday,
    DateTime.tuesday,
    DateTime.wednesday,
    DateTime.friday,
    DateTime.saturday,
  ];
}

bool _fitsVenue(Exercise exercise, ProgramVenue venue) {
  return switch (venue) {
    ProgramVenue.home => exercise.canDoAtHome,
    ProgramVenue.gym => exercise.venue != ExerciseVenue.home,
    ProgramVenue.mixed => true,
  };
}

bool _fitsAssessment(Exercise exercise, TraineeAssessment? assessment) {
  if (assessment == null) return true;
  if ((assessment.hasHeartRisk || assessment.hasKneeIssue) &&
      exercise.workoutType == WorkoutType.hiit) {
    return false;
  }
  if (assessment.hasShoulderIssue &&
      exercise.targetMuscles.contains('shoulders')) {
    return false;
  }
  return true;
}

Difficulty _difficultyCap(ProgramWizardAnswers answers) {
  if (answers.assessment?.isConservative == true || answers.age >= 65) {
    return Difficulty.beginner;
  }
  if (answers.age >= 55 && answers.status == FitnessLevel.advanced) {
    return Difficulty.intermediate;
  }
  return switch (answers.status) {
    FitnessLevel.beginner => Difficulty.beginner,
    FitnessLevel.intermediate => Difficulty.intermediate,
    FitnessLevel.advanced => Difficulty.advanced,
  };
}

int _difficultyScore(Exercise exercise, Difficulty cap) {
  return (exercise.difficulty.index - cap.index).abs();
}

List<Exercise> _ofCategories(
  List<Exercise> catalog,
  Set<ExerciseCategory> categories,
) {
  return [
    for (final exercise in catalog)
      if (categories.contains(exercise.category)) exercise,
  ];
}

Exercise? _pick(List<Exercise> items, int offset) {
  if (items.isEmpty) return null;
  return items[offset % items.length];
}

int _mainCount(ProgramWizardAnswers answers) {
  final daily = answers.period == ScheduleType.daily &&
      !isAnytimeSchedule(answers.period);
  var count = switch (answers.status) {
    FitnessLevel.beginner => daily ? 3 : 4,
    FitnessLevel.intermediate => daily ? 3 : 5,
    FitnessLevel.advanced => daily ? 4 : 6,
  };
  if (answers.age >= 60 || answers.assessment?.isConservative == true) {
    count = daily ? 2 : 3;
  }
  if (answers.sessionMinutes <= 30) {
    count = count > 2 ? count - 1 : count;
  } else if (answers.sessionMinutes >= 60 &&
      answers.assessment?.isConservative != true) {
    count += 1;
  }
  return count;
}

LocalProgramSlot _slotFor(Exercise exercise, ProgramWizardAnswers answers) {
  final support = exercise.category == ExerciseCategory.warmUp ||
      exercise.category == ExerciseCategory.mobility ||
      exercise.category == ExerciseCategory.stretching ||
      exercise.category == ExerciseCategory.coolDown;
  final timed = exercise.duration != null &&
      exercise.duration! > 0 &&
      (exercise.repetitions == null ||
          exercise.category == ExerciseCategory.cardio ||
          exercise.workoutType == WorkoutType.aerobic ||
          exercise.workoutType == WorkoutType.hiit ||
          support);
  final sets = support
      ? 1
      : answers.age >= 60
          ? 2
          : answers.status == FitnessLevel.beginner
              ? 2
              : 3;
  final rest = support
      ? 20
      : answers.age >= 60 || answers.assessment?.recoveryLimited == true
          ? 60
          : answers.workoutType == WorkoutType.hiit
              ? 20
              : 40;
  return LocalProgramSlot(
    exerciseId: exercise.id,
    sets: sets,
    repetitions: timed
        ? null
        : exercise.repetitions ??
            switch (answers.status) {
              FitnessLevel.beginner => 8,
              FitnessLevel.intermediate => 10,
              FitnessLevel.advanced => 12,
            },
    duration: timed ? exercise.duration : null,
    rest: rest,
  );
}

String _programName(ProgramWizardAnswers answers, String language) {
  if (language == 'he') {
    final venue = answers.venue == ProgramVenue.gym ? 'מכון' : 'בית';
    final type = switch (answers.workoutType) {
      WorkoutType.strength => 'כוח',
      WorkoutType.aerobic => 'אירובי',
      WorkoutType.hiit => 'HIIT',
      WorkoutType.functional => 'פונקציונלי',
    };
    return 'תוכנית $type ב$venue';
  }
  final venue = answers.venue == ProgramVenue.gym ? 'Gym' : 'Home';
  final type = switch (answers.workoutType) {
    WorkoutType.strength => 'strength',
    WorkoutType.aerobic => 'aerobic',
    WorkoutType.hiit => 'HIIT',
    WorkoutType.functional => 'functional',
  };
  return '$venue $type program';
}
