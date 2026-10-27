import '../../domain/domain.dart';
import '../../payload/models.dart';

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

/// The PATCH body for the signed-in athlete's profile, built with the
/// generated input builder so field names and types match the schema.
Map<String, Object?> athleteProfilePayload({
  required DateTime? birthDate,
  required TraineeAssessment? assessment,
  required FitnessLevel fitnessLevel,
  required List<FitnessGoal> goals,
  required ExerciseVenue trainingVenue,
}) {
  return CmsUser.input(
    // Midnight UTC of the calendar day: the same instant Payload stored for
    // the date-only string this used to send, and no time zone can move it
    // to the day before.
    birthDate: birthDate == null
        ? null
        : DateTime.utc(birthDate.year, birthDate.month, birthDate.day),
    age: ageYearsFromBirthDate(birthDate),
    fitnessLevel: CmsUserFitnessLevel(fitnessLevel.name),
    level: CmsUserLevel(fitnessLevel.name),
    goals: [for (final goal in goals) CmsUserGoals(goal.name)],
    trainingVenue: CmsUserTrainingVenue(trainingVenue.name),
    assessment: assessment?.toJson(),
    conditionNotes: assessment == null
        ? null
        : athleteConditionNotes(assessment),
  );
}
