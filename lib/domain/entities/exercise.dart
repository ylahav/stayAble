import 'enums.dart';
import 'localized_text.dart';

class Exercise {
  const Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.instructions,
    required this.photo,
    required this.category,
    required this.difficulty,
    this.duration,
    this.repetitions,
    required this.targetMuscles,
    required this.equipment,
    required this.safetyNotes,
    this.venue = ExerciseVenue.both,
    this.workoutType = WorkoutType.strength,
    this.gymNumber,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final LocalizedText name;
  final LocalizedText description;
  final LocalizedText instructions;
  final String photo;
  final ExerciseCategory category;
  final Difficulty difficulty;
  final int? duration;
  final int? repetitions;
  final List<String> targetMuscles;
  final EquipmentKind equipment;
  final LocalizedText safetyNotes;
  final ExerciseVenue venue;
  final WorkoutType workoutType;
  final int? gymNumber;

  bool get canDoAtHome => venue != ExerciseVenue.gym;
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;
}
