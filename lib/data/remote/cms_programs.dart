/// Assigned programs read from the generated models (`CmsProgramAssignment`
/// with its `CmsProgram` populated). Replaced the map-based
/// programFromPayload.
///
/// One difference on purpose: the map version also read a legacy `days`
/// array on programs. The backend migrates that away at every startup
/// (migrateProgramTemplates in onInit), it is no longer in the schema, and
/// so it isn't in the generated model either.
library;

import '../../domain/domain.dart';
import '../../payload/models.dart';

/// Null when the assignment's program isn't populated (depth too low) or
/// has no clientId, the same cases the map version skipped.
RemoteProgramTree? programFromCms(
  CmsProgramAssignment assignment,
  String localUserId,
) {
  final doc = assignment.program?.doc;
  final clientId = doc?.clientId;
  if (doc == null || clientId == null) return null;

  final now = DateTime.now();
  final refinements = {
    for (final r
        in assignment.refinements ?? const <CmsProgramAssignmentRefinement>[])
      if (r.programExerciseClientId case final id? when id.isNotEmpty) id: r,
  };
  final scheduleType = _enum(
    ScheduleType.values,
    assignment.scheduleType?.value,
    ScheduleType.weekly,
  );
  final program = TrainingProgram(
    id: clientId,
    userId: localUserId,
    name: doc.name ?? 'Program',
    description: doc.description ?? '',
    startDate: assignment.startDate,
    endDate: assignment.endDate,
    scheduleType: scheduleType,
    venue: _enum(ProgramVenue.values, doc.venue?.value, ProgramVenue.home),
    active: doc.active ?? true,
    createdAt: doc.createdAt ?? now,
    updatedAt: assignment.updatedAt ?? doc.updatedAt ?? now,
  );

  final slots = doc.exercises ?? const <CmsProgramExercise>[];
  final days = <ProgramDay>[];
  final assignments = <ProgramExercise>[];
  for (final day in _schedule(assignment, scheduleType, clientId)) {
    days.add(
      ProgramDay(
        id: day.id,
        programId: clientId,
        date: day.date,
        weekday: day.weekday,
        title: _weekdayTitle(day.weekday, program.name),
        description: LocalizedText(en: program.description, he: ''),
      ),
    );
    for (final item in slots) {
      final slotId = item.clientId;
      // Populated at depth 2 (assignment → program → exercise).
      final exerciseId = item.exercise?.doc?.clientId;
      if (slotId == null || exerciseId == null) continue;
      final refinement = refinements[slotId];
      assignments.add(
        ProgramExercise(
          id: '${day.id}-$slotId',
          programDayId: day.id,
          exerciseId: exerciseId,
          order: item.sortOrder?.round() ?? 0,
          sets: refinement?.sets?.round() ?? item.sets?.round() ?? 1,
          repetitions:
              refinement?.repetitions?.round() ?? item.repetitions?.round(),
          duration: refinement?.duration?.round() ?? item.duration?.round(),
          loadKg: refinement?.loadKg?.toDouble() ?? item.loadKg?.toDouble(),
          rest: refinement?.rest?.round() ?? item.rest?.round() ?? 0,
          notes: refinement?.notes ?? item.notes,
        ),
      );
    }
  }
  return RemoteProgramTree(
    program: program,
    days: days,
    assignments: assignments,
  );
}

typedef _Day = ({String id, int? weekday, DateTime? date});

List<_Day> _schedule(
  CmsProgramAssignment assignment,
  ScheduleType scheduleType,
  String programId,
) {
  final listed =
      assignment.scheduleDays ?? const <CmsProgramAssignmentScheduleDay>[];
  final days = <_Day>[];
  for (final (index, item) in listed.indexed) {
    final weekday = item.weekday?.round();
    final date = item.date;
    if (weekday == null && date == null) continue;
    final id = item.clientId?.trim();
    days.add((
      id: (id != null && id.isNotEmpty)
          ? id
          : (weekday != null ? 'day-$weekday' : 'day-${index + 1}'),
      weekday: weekday,
      date: date,
    ));
  }
  if (days.isNotEmpty) return days;

  return switch (scheduleType) {
    ScheduleType.daily => [
      for (var weekday = 1; weekday <= 7; weekday++)
        (id: '$programId-day-$weekday', weekday: weekday, date: null),
    ],
    ScheduleType.weekly => const [
      (id: 'day-mon', weekday: 1, date: null),
      (id: 'day-wed', weekday: 3, date: null),
      (id: 'day-fri', weekday: 5, date: null),
    ],
    _ => const [],
  };
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

T _enum<T extends Enum>(List<T> values, String? raw, T fallback) {
  if (raw == null) return fallback;
  for (final value in values) {
    if (value.name == raw) return value;
  }
  return fallback;
}
