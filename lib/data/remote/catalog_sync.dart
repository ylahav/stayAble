import '../../domain/domain.dart';

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
      en: raw['en'] as String? ?? '',
      he: raw['he'] as String? ?? '',
    );
  }
  return const LocalizedText(en: '', he: '');
}

DateTime? _date(Object? raw) {
  if (raw is String && raw.isNotEmpty) return DateTime.tryParse(raw);
  return null;
}

double? _double(Object? raw) {
  if (raw is num) return raw.toDouble();
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
  final loopback = uri.host == 'localhost' ||
      uri.host == '127.0.0.1' ||
      uri.host == '::1';
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

Exercise exerciseFromPayload(Map<String, dynamic> doc, String baseUrl) {
  final now = DateTime.now();
  return Exercise(
    id: doc['clientId'] as String,
    name: _text(doc['name']),
    description: _text(doc['description']),
    instructions: _text(doc['instructions']),
    photo: resolveExercisePhoto(doc, baseUrl),
    category: _enum(ExerciseCategory.values, doc['category'], ExerciseCategory.strength),
    difficulty: _enum(Difficulty.values, doc['difficulty'], Difficulty.intermediate),
    duration: _int(doc['duration']),
    repetitions: _int(doc['repetitions']),
    targetMuscles: [
      if (doc['targetMuscles'] is List)
        for (final item in doc['targetMuscles'] as List) item.toString(),
    ],
    equipment: _enum(EquipmentKind.values, doc['equipment'], EquipmentKind.none),
    safetyNotes: _text(doc['safetyNotes']),
    venue: _enum(ExerciseVenue.values, doc['venue'], ExerciseVenue.both),
    gymNumber: _int(doc['gymNumber']),
    active: doc['active'] as bool? ?? true,
    createdAt: _date(doc['createdAt']) ?? now,
    updatedAt: _date(doc['updatedAt']) ?? now,
  );
}

RemoteProgramTree? programFromPayload(
  Map<String, dynamic> doc,
  String localUserId, {
  Map<String, dynamic>? assignment,
}) {
  final clientId = doc['clientId'] as String?;
  if (clientId == null) return null;
  final now = DateTime.now();
  final refinements = _keyedMaps(assignment?['refinements'], 'programExerciseClientId');
  final scheduleType = _enum(
    ScheduleType.values,
    assignment?['scheduleType'],
    ScheduleType.weekly,
  );
  final program = TrainingProgram(
    id: clientId,
    userId: localUserId,
    name: doc['name'] as String? ?? 'Program',
    description: doc['description'] as String? ?? '',
    startDate: _date(assignment?['startDate']),
    endDate: _date(assignment?['endDate']),
    scheduleType: scheduleType,
    venue: _enum(ProgramVenue.values, doc['venue'], ProgramVenue.home),
    active: doc['active'] as bool? ?? true,
    createdAt: _date(doc['createdAt']) ?? now,
    updatedAt: _date(assignment?['updatedAt']) ?? _date(doc['updatedAt']) ?? now,
  );
  final slots = _programExercises(doc);
  final schedule = _scheduleSlots(doc, assignment, scheduleType, clientId);
  final days = <ProgramDay>[];
  final assignments = <ProgramExercise>[];
  for (final slot in schedule) {
    days.add(
      ProgramDay(
        id: slot.id,
        programId: clientId,
        date: slot.date,
        weekday: slot.weekday,
        title: _weekdayTitle(slot.weekday, program.name),
        description: LocalizedText(en: program.description, he: ''),
      ),
    );
    for (final item in slots) {
      final slotId = item['clientId'] as String?;
      final exercise = item['exercise'];
      final exerciseId = exercise is Map
          ? exercise['clientId'] as String?
          : null;
      if (slotId == null || exerciseId == null) continue;
      final refinement = refinements[slotId];
      assignments.add(
        ProgramExercise(
          id: '${slot.id}-$slotId',
          programDayId: slot.id,
          exerciseId: exerciseId,
          order: _int(item['sortOrder']) ?? 0,
          sets: _int(refinement?['sets']) ?? _int(item['sets']) ?? 1,
          repetitions: _int(refinement?['repetitions']) ?? _int(item['repetitions']),
          duration: _int(refinement?['duration']) ?? _int(item['duration']),
          loadKg: _double(refinement?['loadKg']) ?? _double(item['loadKg']),
          rest: _int(refinement?['rest']) ?? _int(item['rest']) ?? 0,
          notes: refinement?['notes'] as String? ?? item['notes'] as String?,
        ),
      );
    }
  }
  return RemoteProgramTree(program: program, days: days, assignments: assignments);
}

class _ScheduleSlot {
  const _ScheduleSlot({required this.id, this.weekday, this.date});

  final String id;
  final int? weekday;
  final DateTime? date;
}

List<Map<String, dynamic>> _programExercises(Map<String, dynamic> doc) {
  final raw = doc['exercises'];
  if (raw is List && raw.isNotEmpty) {
    return [
      for (final item in raw)
        if (item is Map) Map<String, dynamic>.from(item),
    ];
  }
  final days = doc['days'];
  if (days is! List || days.isEmpty || days.first is! Map) return const [];
  final first = Map<String, dynamic>.from(days.first as Map);
  final items = first['exercises'];
  if (items is! List) return const [];
  return [
    for (final item in items)
      if (item is Map) Map<String, dynamic>.from(item),
  ];
}

List<_ScheduleSlot> _scheduleSlots(
  Map<String, dynamic> doc,
  Map<String, dynamic>? assignment,
  ScheduleType scheduleType,
  String programId,
) {
  final fromAssignment = _slotsFromList(assignment?['scheduleDays']);
  if (fromAssignment.isNotEmpty) return fromAssignment;
  final fromLegacyDays = _slotsFromLegacyProgramDays(doc['days']);
  if (fromLegacyDays.isNotEmpty) return fromLegacyDays;
  if (scheduleType == ScheduleType.daily) {
    return [
      for (var weekday = 1; weekday <= 7; weekday++)
        _ScheduleSlot(id: '$programId-day-$weekday', weekday: weekday),
    ];
  }
  if (scheduleType == ScheduleType.weekly) {
    return const [
      _ScheduleSlot(id: 'day-mon', weekday: 1),
      _ScheduleSlot(id: 'day-wed', weekday: 3),
      _ScheduleSlot(id: 'day-fri', weekday: 5),
    ];
  }
  return const [];
}

List<_ScheduleSlot> _slotsFromList(Object? raw) {
  if (raw is! List) return const [];
  final slots = <_ScheduleSlot>[];
  for (var index = 0; index < raw.length; index++) {
    final item = raw[index];
    if (item is! Map) continue;
    final map = Map<String, dynamic>.from(item);
    final weekday = _int(map['weekday']);
    final date = _date(map['date']);
    if (weekday == null && date == null) continue;
    final id = (map['clientId'] as String?)?.trim();
    slots.add(
      _ScheduleSlot(
        id: (id != null && id.isNotEmpty)
            ? id
            : (weekday != null ? 'day-$weekday' : 'day-${index + 1}'),
        weekday: weekday,
        date: date,
      ),
    );
  }
  return slots;
}

List<_ScheduleSlot> _slotsFromLegacyProgramDays(Object? raw) {
  if (raw is! List) return const [];
  final slots = <_ScheduleSlot>[];
  for (final item in raw) {
    if (item is! Map) continue;
    final day = Map<String, dynamic>.from(item);
    final id = day['clientId'] as String?;
    if (id == null) continue;
    slots.add(
      _ScheduleSlot(
        id: id,
        weekday: _int(day['weekday']),
        date: _date(day['date']),
      ),
    );
  }
  return slots;
}

LocalizedText _weekdayTitle(int? weekday, String fallback) {
  return switch (weekday) {
    1 => const LocalizedText(en: 'Monday', he: 'שני'),
    2 => const LocalizedText(en: 'Tuesday', he: 'שלישי'),
    3 => const LocalizedText(en: 'Wednesday', he: 'רביעי'),
    4 => const LocalizedText(en: 'Thursday', he: 'חמישי'),
    5 => const LocalizedText(en: 'Friday', he: 'שישי'),
    6 => const LocalizedText(en: 'Saturday', he: 'שבת'),
    7 => const LocalizedText(en: 'Sunday', he: 'ראשון'),
    _ => LocalizedText(en: fallback, he: ''),
  };
}

Map<String, Map<String, dynamic>> _keyedMaps(Object? raw, String key) {
  final out = <String, Map<String, dynamic>>{};
  if (raw is! List) return out;
  for (final item in raw) {
    if (item is! Map) continue;
    final map = Map<String, dynamic>.from(item);
    final id = map[key] as String?;
    if (id == null || id.isEmpty) continue;
    out[id] = map;
  }
  return out;
}
