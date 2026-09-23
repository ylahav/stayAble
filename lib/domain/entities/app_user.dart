import 'enums.dart';

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
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;
}
