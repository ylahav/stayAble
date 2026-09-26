import '../../domain/domain.dart';

String dateOnlyIso(DateTime date) {
  final local = DateTime(date.year, date.month, date.day);
  final month = local.month.toString().padLeft(2, '0');
  final day = local.day.toString().padLeft(2, '0');
  return '${local.year}-$month-$day';
}

String athleteConditionNotes(TraineeAssessment assessment) {
  final parts = <String>[];
  if (assessment.injuries.isNotEmpty) {
    parts.add(
      'Injuries: ${assessment.injuries.map((item) => item.name).join(', ')}',
    );
  }
  if (assessment.conditions.isNotEmpty) {
    parts.add(
      'Conditions: ${assessment.conditions.map((item) => item.name).join(', ')}',
    );
  }
  if (assessment.medicationsAffecting) {
    parts.add('Medications affecting training');
  }
  if (assessment.needsClearance) {
    parts.add('Needs medical clearance');
  }
  return parts.join('. ');
}

Map<String, dynamic> athleteProfilePayload({
  required DateTime? birthDate,
  required TraineeAssessment? assessment,
  required FitnessLevel fitnessLevel,
  required List<FitnessGoal> goals,
  required ExerciseVenue trainingVenue,
}) {
  final age = ageYearsFromBirthDate(birthDate);
  return {
    if (birthDate != null) 'birthDate': dateOnlyIso(birthDate),
    'age': ?age,
    'fitnessLevel': fitnessLevel.name,
    'level': fitnessLevel.name,
    'goals': [for (final goal in goals) goal.name],
    'trainingVenue': trainingVenue.name,
    if (assessment != null) 'assessment': assessment.toJson(),
    if (assessment != null) 'conditionNotes': athleteConditionNotes(assessment),
  };
}
