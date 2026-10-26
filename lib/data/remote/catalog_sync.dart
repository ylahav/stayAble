import '../../domain/domain.dart';
import 'rich_text.dart';

T _enum<T extends Enum>(List<T> values, Object? raw, T fallback) {
  if (raw is! String) return fallback;
  for (final value in values) {
    if (value.name == raw) return value;
  }
  return fallback;
}

LocalizedText _text(Object? raw) {
  if (raw is Map) {
    return LocalizedText(
      en: fieldToHtml(raw['en']),
      he: fieldToHtml(raw['he']),
    );
  }
  return const LocalizedText(en: '', he: '');
}

DateTime? _date(Object? raw) {
  if (raw is String && raw.isNotEmpty) return DateTime.tryParse(raw);
  return null;
}

int? _int(Object? raw) {
  if (raw is num) return raw.round();
  return null;
}

String rewriteMediaUrl(String url, String baseUrl) {
  final trimmed = url.trim();
  if (trimmed.isEmpty) return trimmed;
  if (trimmed.startsWith('/') && !trimmed.startsWith('//')) {
    return '$baseUrl$trimmed';
  }
  final uri = Uri.tryParse(trimmed);
  if (uri == null || (uri.scheme != 'http' && uri.scheme != 'https')) {
    return trimmed;
  }
  final loopback =
      uri.host == 'localhost' || uri.host == '127.0.0.1' || uri.host == '::1';
  if (!loopback) return trimmed;
  final base = Uri.parse(baseUrl);
  return Uri(
    scheme: base.scheme,
    host: base.host,
    port: base.hasPort ? base.port : null,
    path: uri.path,
    query: uri.query.isEmpty ? null : uri.query,
  ).toString();
}

String resolveExercisePhoto(Map<String, dynamic> doc, String baseUrl) {
  final image = doc['image'];
  if (image is Map && image['url'] is String) {
    return rewriteMediaUrl(image['url'] as String, baseUrl);
  }
  final path = doc['photoPath'] as String? ?? '';
  if (path.startsWith('http://') || path.startsWith('https://')) {
    return rewriteMediaUrl(path, baseUrl);
  }
  if (path.startsWith('assets/')) {
    return path;
  }
  final id = doc['clientId'] as String? ?? 'exercise';
  return 'assets/exercises/$id.png';
}

/// Reads one exercise from the public catalog endpoint. That endpoint sends
/// `instructions` as HTML strings rather than rich text, so it doesn't fit
/// the generated CmsExercise; the exercises collection is read with
/// exerciseFromCms instead.
Exercise exerciseFromPayload(Map<String, dynamic> doc, String baseUrl) {
  final now = DateTime.now();
  final category = _enum(
    ExerciseCategory.values,
    doc['category'],
    ExerciseCategory.strength,
  );
  return Exercise(
    id: doc['clientId'] as String,
    name: _text(doc['name']),
    description: _text(doc['description']),
    instructions: _text(doc['instructions']),
    photo: resolveExercisePhoto(doc, baseUrl),
    category: category,
    workoutType: _enum(
      WorkoutType.values,
      doc['workoutType'],
      workoutTypeFromCategory(category),
    ),
    difficulty: _enum(
      Difficulty.values,
      doc['difficulty'],
      Difficulty.intermediate,
    ),
    duration: _int(doc['duration']),
    repetitions: _int(doc['repetitions']),
    targetMuscles: [
      if (doc['targetMuscles'] is List)
        for (final item in doc['targetMuscles'] as List) item.toString(),
    ],
    equipment: _enum(
      EquipmentKind.values,
      doc['equipment'],
      EquipmentKind.none,
    ),
    safetyNotes: _text(doc['safetyNotes']),
    venue: _enum(ExerciseVenue.values, doc['venue'], ExerciseVenue.both),
    gymNumber: _int(doc['gymNumber']),
    active: doc['active'] as bool? ?? true,
    createdAt: _date(doc['createdAt']) ?? now,
    updatedAt: _date(doc['updatedAt']) ?? now,
  );
}
