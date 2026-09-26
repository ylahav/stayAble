import 'enums.dart';

enum InjuryArea { knees, back, shoulders, other }

enum MedicalCondition { heart, bloodPressure, asthma, diabetes, joints }

enum TrainingBackground { starting, returning, current }

enum OccupationDemand { sedentary, mixed, physical }

enum GoalTimeline { slow, moderate, fast }

enum TrainingPreference { freeWeights, machines, functional, mixed }

enum StressLevel { low, moderate, high }

enum DietHabit { regular, specificPlan, skipMeals }

enum LifestyleHabit { none, smoking, alcohol, both }

enum MobilityLevel { limited, average, good }

class TraineeAssessment {
  const TraineeAssessment({
    this.injuries = const {},
    this.conditions = const {},
    this.medicationsAffecting = false,
    this.needsClearance = false,
    this.goals = const [FitnessGoal.generalFitness],
    this.timeline = GoalTimeline.moderate,
    this.preferences = const {TrainingPreference.mixed},
    this.background = TrainingBackground.starting,
    this.occupation = OccupationDemand.sedentary,
    this.mobility = MobilityLevel.average,
    this.weekdays = const [DateTime.monday, DateTime.wednesday, DateTime.friday],
    this.sessionMinutes = 45,
    this.sleepHours = 7,
    this.stress = StressLevel.moderate,
    this.diet = DietHabit.regular,
    this.habits = LifestyleHabit.none,
    this.venue = ProgramVenue.home,
    this.workoutType = WorkoutType.strength,
    this.period = ScheduleType.weekly,
  });

  final Set<InjuryArea> injuries;
  final Set<MedicalCondition> conditions;
  final bool medicationsAffecting;
  final bool needsClearance;
  final List<FitnessGoal> goals;
  final GoalTimeline timeline;
  final Set<TrainingPreference> preferences;
  final TrainingBackground background;
  final OccupationDemand occupation;
  final MobilityLevel mobility;
  final List<int> weekdays;
  final int sessionMinutes;
  final int sleepHours;
  final StressLevel stress;
  final DietHabit diet;
  final LifestyleHabit habits;
  final ProgramVenue venue;
  final WorkoutType workoutType;
  final ScheduleType period;

  bool get hasKneeIssue => injuries.contains(InjuryArea.knees);
  bool get hasBackIssue => injuries.contains(InjuryArea.back);
  bool get hasShoulderIssue => injuries.contains(InjuryArea.shoulders);

  bool get hasHeartRisk =>
      conditions.contains(MedicalCondition.heart) ||
      conditions.contains(MedicalCondition.bloodPressure) ||
      medicationsAffecting ||
      needsClearance;

  bool get recoveryLimited =>
      sleepHours < 6 ||
      stress == StressLevel.high ||
      habits == LifestyleHabit.smoking ||
      habits == LifestyleHabit.both;

  bool get isConservative =>
      hasHeartRisk ||
      hasKneeIssue ||
      hasBackIssue ||
      mobility == MobilityLevel.limited ||
      recoveryLimited;

  FitnessLevel derivedLevel(int age) {
    if (isConservative || age >= 65 || background == TrainingBackground.starting) {
      return FitnessLevel.beginner;
    }
    if (background == TrainingBackground.current &&
        mobility == MobilityLevel.good &&
        age < 55) {
      return FitnessLevel.advanced;
    }
    return FitnessLevel.intermediate;
  }

  WorkoutType get resolvedWorkoutType {
    if (hasHeartRisk || hasKneeIssue) {
      if (workoutType == WorkoutType.hiit) return WorkoutType.aerobic;
    }
    if (preferences.contains(TrainingPreference.functional) &&
        !preferences.contains(TrainingPreference.freeWeights) &&
        !preferences.contains(TrainingPreference.machines)) {
      return WorkoutType.functional;
    }
    return workoutType;
  }

  ProgramVenue get resolvedVenue {
    if (preferences.contains(TrainingPreference.machines) &&
        !preferences.contains(TrainingPreference.freeWeights)) {
      return ProgramVenue.gym;
    }
    return venue;
  }

  TraineeAssessment copyWith({
    Set<InjuryArea>? injuries,
    Set<MedicalCondition>? conditions,
    bool? medicationsAffecting,
    bool? needsClearance,
    List<FitnessGoal>? goals,
    GoalTimeline? timeline,
    Set<TrainingPreference>? preferences,
    TrainingBackground? background,
    OccupationDemand? occupation,
    MobilityLevel? mobility,
    List<int>? weekdays,
    int? sessionMinutes,
    int? sleepHours,
    StressLevel? stress,
    DietHabit? diet,
    LifestyleHabit? habits,
    ProgramVenue? venue,
    WorkoutType? workoutType,
    ScheduleType? period,
  }) {
    return TraineeAssessment(
      injuries: injuries ?? this.injuries,
      conditions: conditions ?? this.conditions,
      medicationsAffecting: medicationsAffecting ?? this.medicationsAffecting,
      needsClearance: needsClearance ?? this.needsClearance,
      goals: goals ?? this.goals,
      timeline: timeline ?? this.timeline,
      preferences: preferences ?? this.preferences,
      background: background ?? this.background,
      occupation: occupation ?? this.occupation,
      mobility: mobility ?? this.mobility,
      weekdays: weekdays ?? this.weekdays,
      sessionMinutes: sessionMinutes ?? this.sessionMinutes,
      sleepHours: sleepHours ?? this.sleepHours,
      stress: stress ?? this.stress,
      diet: diet ?? this.diet,
      habits: habits ?? this.habits,
      venue: venue ?? this.venue,
      workoutType: workoutType ?? this.workoutType,
      period: period ?? this.period,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'injuries': [for (final item in injuries) item.name],
      'conditions': [for (final item in conditions) item.name],
      'medicationsAffecting': medicationsAffecting,
      'needsClearance': needsClearance,
      'goals': [for (final item in goals) item.name],
      'timeline': timeline.name,
      'preferences': [for (final item in preferences) item.name],
      'background': background.name,
      'occupation': occupation.name,
      'mobility': mobility.name,
      'weekdays': weekdays,
      'sessionMinutes': sessionMinutes,
      'sleepHours': sleepHours,
      'stress': stress.name,
      'diet': diet.name,
      'habits': habits.name,
      'venue': venue.name,
      'workoutType': workoutType.name,
      'period': period.name,
    };
  }

  factory TraineeAssessment.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const TraineeAssessment();
    T enumOr<T extends Enum>(List<T> values, Object? raw, T fallback) {
      if (raw is! String) return fallback;
      return values.where((value) => value.name == raw).firstOrNull ?? fallback;
    }

    Set<T> enumSet<T extends Enum>(List<T> values, Object? raw) {
      if (raw is! List) return {};
      return {
        for (final item in raw)
          if (item is String)
            ...values.where((value) => value.name == item),
      };
    }

    return TraineeAssessment(
      injuries: enumSet(InjuryArea.values, json['injuries']),
      conditions: enumSet(MedicalCondition.values, json['conditions']),
      medicationsAffecting: json['medicationsAffecting'] == true,
      needsClearance: json['needsClearance'] == true,
      goals: [
        for (final item in (json['goals'] as List? ?? const []))
          if (item is String)
            ...FitnessGoal.values.where((value) => value.name == item),
      ],
      timeline: enumOr(GoalTimeline.values, json['timeline'], GoalTimeline.moderate),
      preferences: enumSet(TrainingPreference.values, json['preferences']),
      background: enumOr(
        TrainingBackground.values,
        json['background'],
        TrainingBackground.starting,
      ),
      occupation: enumOr(
        OccupationDemand.values,
        json['occupation'],
        OccupationDemand.sedentary,
      ),
      mobility: enumOr(MobilityLevel.values, json['mobility'], MobilityLevel.average),
      weekdays: [
        for (final item in (json['weekdays'] as List? ?? const []))
          if (item is num) item.toInt(),
      ],
      sessionMinutes: (json['sessionMinutes'] as num?)?.toInt() ?? 45,
      sleepHours: (json['sleepHours'] as num?)?.toInt() ?? 7,
      stress: enumOr(StressLevel.values, json['stress'], StressLevel.moderate),
      diet: enumOr(DietHabit.values, json['diet'], DietHabit.regular),
      habits: enumOr(LifestyleHabit.values, json['habits'], LifestyleHabit.none),
      venue: enumOr(ProgramVenue.values, json['venue'], ProgramVenue.home),
      workoutType:
          enumOr(WorkoutType.values, json['workoutType'], WorkoutType.strength),
      period: enumOr(ScheduleType.values, json['period'], ScheduleType.weekly),
    );
  }
}
