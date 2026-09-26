import 'enums.dart';
import 'trainee_assessment.dart';

int? ageYearsFromBirthDate(DateTime? birth, [DateTime? now]) {
  if (birth == null) return null;
  final today = now ?? DateTime.now();
  var age = today.year - birth.year;
  if (today.month < birth.month ||
      (today.month == birth.month && today.day < birth.day)) {
    age--;
  }
  return age;
}

class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    this.email,
    this.photo,
    this.birthDate,
    this.gender,
    required this.fitnessLevel,
    required this.goals,
    required this.language,
    this.trainingVenue = ExerciseVenue.both,
    this.preferredUnits = PreferredUnits.kg,
    this.defaultRestSeconds,
    this.assessment,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String? email;
  final String? photo;
  final DateTime? birthDate;
  final String? gender;
  final FitnessLevel fitnessLevel;
  final List<FitnessGoal> goals;
  final String language;
  final ExerciseVenue trainingVenue;
  final PreferredUnits preferredUnits;
  final int? defaultRestSeconds;
  final TraineeAssessment? assessment;
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;

  int? ageYears([DateTime? now]) => ageYearsFromBirthDate(birthDate, now);
}
