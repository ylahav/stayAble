/// [RemoteUser] read from the generated `CmsUser` model instead of a JSON
/// map. Typed twin of [RemoteUser.fromJson], which stays for the tests and
/// anything that still holds raw JSON.
library;

import '../../domain/domain.dart';
import '../../payload/models.dart';

RemoteUser remoteUserFromCms(CmsUser user) {
  final birth = user.birthDate;
  final assessment = user.assessment;
  return RemoteUser(
    id: user.id,
    email: user.email ?? '',
    name: user.name ?? '',
    // Kept as strings: legacy values like 'athlete' must survive, and
    // RemoteUser.isTrainee checks for them.
    roles: [
      for (final role in user.roles ?? const <CmsUserRoles>[]) role.value,
    ],
    language: user.language?.value ?? 'en',
    active: user.active ?? true,
    // A calendar date: keep the day Payload stored, drop the time.
    birthDate: birth == null
        ? null
        : DateTime(birth.year, birth.month, birth.day),
    assessment: assessment is Map
        ? TraineeAssessment.fromJson(Map<String, dynamic>.from(assessment))
        : null,
    fitnessLevel:
        _enum(FitnessLevel.values, user.fitnessLevel?.value) ??
        _enum(FitnessLevel.values, user.level?.value),
    goals: [
      for (final goal in user.goals ?? const <CmsUserGoals>[])
        ?_enum(FitnessGoal.values, goal.value),
    ],
    trainingVenue: _enum(ExerciseVenue.values, user.trainingVenue?.value),
  );
}

T? _enum<T extends Enum>(List<T> values, String? raw) {
  if (raw == null) return null;
  for (final value in values) {
    if (value.name == raw) return value;
  }
  return null;
}
