import 'package:flutter_test/flutter_test.dart';
import 'package:stayable/domain/entities/enums.dart';
import 'package:stayable/domain/entities/exercise.dart';
import 'package:stayable/domain/entities/localized_text.dart';
import 'package:stayable/domain/entities/trainee_assessment.dart';
import 'package:stayable/domain/program_wizard.dart';

Exercise _exercise({
  required String id,
  required ExerciseCategory category,
  required WorkoutType workoutType,
  ExerciseVenue venue = ExerciseVenue.both,
  Difficulty difficulty = Difficulty.beginner,
  int? duration,
  int? repetitions,
}) {
  final now = DateTime.utc(2026, 1, 1);
  return Exercise(
    id: id,
    name: LocalizedText(en: id, he: id),
    description: const LocalizedText(en: '', he: ''),
    instructions: const LocalizedText(en: '', he: ''),
    photo: '',
    category: category,
    difficulty: difficulty,
    duration: duration,
    repetitions: repetitions,
    targetMuscles: const ['core'],
    equipment: EquipmentKind.none,
    safetyNotes: const LocalizedText(en: '', he: ''),
    venue: venue,
    workoutType: workoutType,
    active: true,
    createdAt: now,
    updatedAt: now,
  );
}

void main() {
  final catalog = [
    _exercise(
      id: 'ex-march',
      category: ExerciseCategory.warmUp,
      workoutType: WorkoutType.functional,
      duration: 60,
    ),
    _exercise(
      id: 'ex-cat-cow',
      category: ExerciseCategory.mobility,
      workoutType: WorkoutType.functional,
      duration: 40,
    ),
    _exercise(
      id: 'ex-squat',
      category: ExerciseCategory.strength,
      workoutType: WorkoutType.strength,
      repetitions: 10,
    ),
    _exercise(
      id: 'ex-glute-bridge',
      category: ExerciseCategory.strength,
      workoutType: WorkoutType.strength,
      repetitions: 10,
    ),
    _exercise(
      id: 'ex-plank',
      category: ExerciseCategory.strength,
      workoutType: WorkoutType.functional,
      duration: 30,
    ),
    _exercise(
      id: 'ex-cardio',
      category: ExerciseCategory.cardio,
      workoutType: WorkoutType.aerobic,
      duration: 120,
    ),
    _exercise(
      id: 'ex-cooldown',
      category: ExerciseCategory.coolDown,
      workoutType: WorkoutType.functional,
      duration: 45,
    ),
    _exercise(
      id: 'ex-leg-press',
      category: ExerciseCategory.strength,
      workoutType: WorkoutType.strength,
      venue: ExerciseVenue.gym,
      repetitions: 10,
    ),
    _exercise(
      id: 'ex-seated-fast-feet',
      category: ExerciseCategory.cardio,
      workoutType: WorkoutType.hiit,
      venue: ExerciseVenue.home,
      duration: 30,
    ),
  ];

  const beginnerWeekly = ProgramWizardAnswers(
    venue: ProgramVenue.home,
    workoutType: WorkoutType.strength,
    age: 40,
    status: FitnessLevel.beginner,
    goals: [FitnessGoal.generalFitness],
    period: ScheduleType.weekly,
  );

  test('weekly program uses the days the user picked', () {
    final program = generateLocalProgram(
      answers: const ProgramWizardAnswers(
        venue: ProgramVenue.home,
        workoutType: WorkoutType.strength,
        age: 40,
        status: FitnessLevel.beginner,
        goals: [FitnessGoal.generalFitness],
        period: ScheduleType.weekly,
        weekdays: [DateTime.tuesday, DateTime.thursday],
      ),
      catalog: catalog,
    );
    expect(program.weekdays, [DateTime.tuesday, DateTime.thursday]);
    expect(program.slotsByWeekday.keys, {DateTime.tuesday, DateTime.thursday});
  });

  test('weekly beginner program uses Mon Wed Fri and home-capable exercises', () {
    final program = generateLocalProgram(
      answers: beginnerWeekly,
      catalog: catalog,
    );
    expect(program.weekdays, [DateTime.monday, DateTime.wednesday, DateTime.friday]);
    expect(program.name, 'Home strength program');
    final monday = program.slotsByWeekday[DateTime.monday]!;
    expect(monday, isNotEmpty);
    expect(monday.any((slot) => slot.exerciseId == 'ex-leg-press'), isFalse);
    expect(
      monday.first.exerciseId,
      anyOf('ex-march', 'ex-cat-cow'),
    );
  });

  test('daily program fills every weekday', () {
    final program = generateLocalProgram(
      answers: const ProgramWizardAnswers(
        venue: ProgramVenue.home,
        workoutType: WorkoutType.strength,
        age: 30,
        status: FitnessLevel.intermediate,
        goals: [FitnessGoal.strength],
        period: ScheduleType.daily,
      ),
      catalog: catalog,
    );
    expect(program.weekdays, hasLength(7));
  });

  test('gym venue can include gym-only machines', () {
    final program = generateLocalProgram(
      answers: const ProgramWizardAnswers(
        venue: ProgramVenue.gym,
        workoutType: WorkoutType.strength,
        age: 35,
        status: FitnessLevel.intermediate,
        goals: [FitnessGoal.strength],
        period: ScheduleType.weekly,
      ),
      catalog: catalog,
    );
    final ids = program.slotsByWeekday.values
        .expand((slots) => slots.map((slot) => slot.exerciseId))
        .toSet();
    expect(ids, contains('ex-leg-press'));
    expect(ids, isNot(contains('ex-seated-fast-feet')));
  });

  test('occasional program is available any day', () {
    final program = generateLocalProgram(
      answers: const ProgramWizardAnswers(
        venue: ProgramVenue.home,
        workoutType: WorkoutType.strength,
        age: 40,
        status: FitnessLevel.beginner,
        goals: [FitnessGoal.generalFitness],
        period: ScheduleType.occasional,
      ),
      catalog: catalog,
    );
    expect(program.scheduleType, ScheduleType.occasional);
    expect(program.weekdays, [occasionalSlotKey]);
    expect(program.slotsByWeekday[occasionalSlotKey], isNotEmpty);
    final draft = program.toDraft();
    expect(draft.isOccasional, isTrue);
  });

  test('heart risk and knee issues drop HIIT from the program', () {
    final program = generateLocalProgram(
      answers: ProgramWizardAnswers(
        venue: ProgramVenue.home,
        workoutType: WorkoutType.hiit,
        age: 40,
        status: FitnessLevel.advanced,
        goals: const [FitnessGoal.cardio],
        period: ScheduleType.weekly,
        assessment: TraineeAssessment(
          conditions: const {MedicalCondition.heart},
          injuries: const {InjuryArea.knees},
          workoutType: WorkoutType.hiit,
          period: ScheduleType.weekly,
        ),
      ),
      catalog: catalog,
    );
    final ids = program.slotsByWeekday.values
        .expand((slots) => slots.map((slot) => slot.exerciseId))
        .toSet();
    expect(ids, isNot(contains('ex-seated-fast-feet')));
    expect(program.slotsByWeekday.values.any((slots) => slots.isNotEmpty), isTrue);
  });

  test('empty catalog cannot build a program', () {
    expect(
      () => generateLocalProgram(answers: beginnerWeekly, catalog: const []),
      throwsA(isA<ProgramWizardException>()),
    );
  });
}
