/// Exercises read from the generated `CmsExercise` model
/// (lib/payload/models.dart, from payload_dart_gen) instead of JSON maps.
///
/// Typed twin of [exerciseFromPayload]: same result, but fields come from
/// typed properties, so a field renamed or removed in Payload becomes a
/// compile error after regenerating rather than a silent null.
library;

import '../../domain/domain.dart';
import '../../payload/models.dart';
import 'catalog_sync.dart' show rewriteMediaUrl;
import 'rich_text.dart';

/// Typed twin of [exerciseFromPayload]. Requires [CmsExercise.clientId].
Exercise exerciseFromCms(CmsExercise doc, String baseUrl) {
  final now = DateTime.now();
  final category = _enum(
    ExerciseCategory.values,
    doc.category?.value,
    ExerciseCategory.strength,
  );
  return Exercise(
    id: doc.clientId!,
    name: _text(doc.name?.en, doc.name?.he),
    description: _text(doc.description?.en, doc.description?.he),
    // Rich text (Lexical JSON) per language, rendered the same way as before.
    instructions: LocalizedText(
      en: fieldToHtml(doc.instructions?.en),
      he: fieldToHtml(doc.instructions?.he),
    ),
    photo: _photo(doc, baseUrl),
    category: category,
    workoutType: _enum(
      WorkoutType.values,
      doc.workoutType?.value,
      workoutTypeFromCategory(category),
    ),
    difficulty: _enum(
      Difficulty.values,
      doc.difficulty?.value,
      Difficulty.intermediate,
    ),
    duration: doc.duration?.round(),
    repetitions: doc.repetitions?.round(),
    targetMuscles: [...?doc.targetMuscles],
    equipment: _enum(
      EquipmentKind.values,
      doc.equipment?.value,
      EquipmentKind.none,
    ),
    safetyNotes: _text(doc.safetyNotes?.en, doc.safetyNotes?.he),
    venue: _enum(ExerciseVenue.values, doc.venue?.value, ExerciseVenue.both),
    gymNumber: doc.gymNumber?.round(),
    active: doc.active ?? true,
    createdAt: doc.createdAt ?? now,
    updatedAt: doc.updatedAt ?? now,
  );
}

/// Same order as [resolveExercisePhoto]: the uploaded image, then
/// photoPath, then the bundled asset named after the clientId.
String _photo(CmsExercise doc, String baseUrl) {
  // `image` is a Ref<CmsMedia>: populated at depth 1, an ID otherwise.
  if (doc.image?.doc?.url case final url?) {
    return rewriteMediaUrl(url, baseUrl);
  }
  final path = doc.photoPath ?? '';
  if (path.startsWith('http://') || path.startsWith('https://')) {
    return rewriteMediaUrl(path, baseUrl);
  }
  if (path.startsWith('assets/')) return path;
  return 'assets/exercises/${doc.clientId ?? 'exercise'}.png';
}

LocalizedText _text(String? en, String? he) =>
    LocalizedText(en: en ?? '', he: he ?? '');

/// Payload's select values and the app's enums share names, so this maps
/// one to the other. Generated select types are open (unknown values are
/// kept), which is why a fallback is still needed.
T _enum<T extends Enum>(List<T> values, String? raw, T fallback) {
  if (raw == null) return fallback;
  for (final value in values) {
    if (value.name == raw) return value;
  }
  return fallback;
}
