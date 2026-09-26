import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/domain.dart' as domain;
import '../db/app_database.dart';
import '../mappers.dart';

const _uuid = Uuid();

DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

DateTime startOfWeekMonday(DateTime d) {
  final day = dateOnly(d);
  return day.subtract(Duration(days: day.weekday - DateTime.monday));
}

bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

class DriftStayAbleRepository implements domain.StayAbleRepository {
  DriftStayAbleRepository(this.db);

  final AppDatabase db;
  String? _currentUserId;

  Future<User> _userRow() async {
    final id = _currentUserId;
    if (id != null) {
      final match = await (db.select(db.users)..where((t) => t.id.equals(id)))
          .getSingleOrNull();
      if (match != null) return match;
    }
    final rows = await db.select(db.users).get();
    return rows.firstWhere(
      (row) => row.id == domain.anonymousLocalUserId,
      orElse: () => rows.first,
    );
  }

  @override
  Future<void> useUserId(String id) async {
    _currentUserId = id;
  }

  @override
  Future<void> ensureSignedInUser({
    required String id,
    required String name,
    required String email,
    required String language,
  }) async {
    final now = DateTime.now();
    final existing = await (db.select(db.users)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (existing == null) {
      await db.into(db.users).insert(
            UsersCompanion.insert(
              id: id,
              name: name.isEmpty ? email : name,
              email: Value(email),
              fitnessLevel: domain.FitnessLevel.beginner,
              goals: const [domain.FitnessGoal.generalFitness],
              language: language,
              createdAt: now,
              updatedAt: now,
            ),
          );
    } else {
      await (db.update(db.users)..where((t) => t.id.equals(id))).write(
        UsersCompanion(
          name: Value(name.isEmpty ? existing.name : name),
          email: Value(email),
          language: Value(language),
          updatedAt: Value(now),
        ),
      );
    }
    _currentUserId = id;
  }

  @override
  Future<domain.AppUser> getCurrentUser() async => mapUser(await _userRow());

  @override
  Future<void> setLanguage(String languageCode) async {
    final user = await _userRow();
    await (db.update(db.users)..where((t) => t.id.equals(user.id))).write(
      UsersCompanion(
        language: Value(languageCode),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> setBirthDate(DateTime birthDate) async {
    final user = await _userRow();
    await (db.update(db.users)..where((t) => t.id.equals(user.id))).write(
      UsersCompanion(
        birthDate: Value(dateOnly(birthDate)),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> setAssessment(domain.TraineeAssessment assessment) async {
    final user = await _userRow();
    await (db.update(db.users)..where((t) => t.id.equals(user.id))).write(
      UsersCompanion(
        assessment: Value(assessment),
        fitnessLevel: Value(
          assessment.derivedLevel(
            domain.ageYearsFromBirthDate(user.birthDate) ?? 40,
          ),
        ),
        goals: Value(
          assessment.goals.isEmpty
              ? const [domain.FitnessGoal.generalFitness]
              : assessment.goals,
        ),
        trainingVenue: Value(
          assessment.resolvedVenue == domain.ProgramVenue.gym
              ? domain.ExerciseVenue.gym
              : assessment.resolvedVenue == domain.ProgramVenue.home
                  ? domain.ExerciseVenue.home
                  : domain.ExerciseVenue.both,
        ),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> applyRemoteProfile({
    DateTime? birthDate,
    domain.TraineeAssessment? assessment,
    domain.FitnessLevel? fitnessLevel,
    List<domain.FitnessGoal>? goals,
    domain.ExerciseVenue? trainingVenue,
  }) async {
    if (birthDate != null) {
      await setBirthDate(birthDate);
    }
    if (assessment != null) {
      await setAssessment(assessment);
      return;
    }
    if (fitnessLevel == null && goals == null && trainingVenue == null) {
      return;
    }
    final user = await _userRow();
    await (db.update(db.users)..where((t) => t.id.equals(user.id))).write(
      UsersCompanion(
        fitnessLevel: fitnessLevel != null
            ? Value(fitnessLevel)
            : const Value.absent(),
        goals: goals != null ? Value(goals) : const Value.absent(),
        trainingVenue: trainingVenue != null
            ? Value(trainingVenue)
            : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<List<domain.Exercise>> getExercises({
    domain.ExerciseCategory? category,
    domain.WorkoutType? workoutType,
    bool homeCapable = false,
    String? query,
    List<String>? tags,
  }) async {
    final rows = await (db.select(db.exercises)
          ..where((t) => t.active.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.id)]))
        .get();
    var items = rows.map(mapExercise).toList();
    if (category != null) {
      items = items.where((e) => e.category == category).toList();
    }
    if (workoutType != null) {
      items = items.where((e) => e.workoutType == workoutType).toList();
    }
    if (homeCapable) {
      items = items.where((e) => e.canDoAtHome).toList();
    }
    if (tags != null && tags.isNotEmpty) {
      items = items.where((exercise) {
        final keys = {
          'cat:${exercise.category.name}',
          'type:${exercise.workoutType.name}',
          'venue:${exercise.venue.name}',
          'diff:${exercise.difficulty.name}',
          if (exercise.equipment != domain.EquipmentKind.none)
            'eq:${exercise.equipment.name}',
          for (final muscle in exercise.targetMuscles) 'muscle:$muscle',
        };
        return tags.every(keys.contains);
      }).toList();
    }
    final q = query?.trim().toLowerCase();
    if (q != null && q.isNotEmpty) {
      items = items.where((e) {
        return e.name.en.toLowerCase().contains(q) ||
            e.name.he.contains(q) ||
            e.description.en.toLowerCase().contains(q) ||
            e.description.he.contains(q);
      }).toList();
    }
    items.sort((a, b) {
      final gymA = a.gymNumber ?? 100000;
      final gymB = b.gymNumber ?? 100000;
      if (gymA != gymB) return gymA.compareTo(gymB);
      return a.id.compareTo(b.id);
    });
    return items;
  }

  @override
  Future<Set<String>> getExerciseIds() async {
    final rows = await (db.select(db.exercises)
          ..where((t) => t.active.equals(true)))
        .get();
    return rows.map((row) => row.id).toSet();
  }

  @override
  Future<domain.Exercise?> getExercise(String id) async {
    final row = await (db.select(db.exercises)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : mapExercise(row);
  }

  Future<List<TrainingProgram>> _activePrograms(
    String userId, {
    required bool localOnly,
  }) async {
    final rows = await (db.select(db.trainingPrograms)
          ..where((t) => t.userId.equals(userId) & t.active.equals(true)))
        .get();
    rows.removeWhere((row) => domain.isLocalProgramId(row.id) != localOnly);
    rows.sort((a, b) {
      final venue = a.venue.index.compareTo(b.venue.index);
      if (venue != 0) return venue;
      return a.name.compareTo(b.name);
    });
    return rows;
  }

  Future<ProgramDay?> _todayDay(TrainingProgram program, DateTime now) async {
    final days = await (db.select(db.programDays)
          ..where((t) => t.programId.equals(program.id)))
        .get();
    if (domain.isAnytimeSchedule(program.scheduleType)) {
      return days.where((day) => day.weekday == null).firstOrNull ??
          (days.isEmpty ? null : days.first);
    }
    final today = dateOnly(now);
    for (final day in days) {
      if (day.date != null && isSameDay(day.date!, today)) return day;
    }
    for (final day in days) {
      if (day.weekday != null && day.weekday == now.weekday) return day;
    }
    return null;
  }

  Future<List<domain.ProgramExerciseItem>> _itemsForDay(String dayId) async {
    final assignments = await (db.select(db.programExercises)
          ..where((t) => t.programDayId.equals(dayId) & t.active.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
    final result = <domain.ProgramExerciseItem>[];
    for (final assignment in assignments) {
      final exercise = await (db.select(db.exercises)
            ..where((t) => t.id.equals(assignment.exerciseId)))
          .getSingle();
      result.add(
        domain.ProgramExerciseItem(
          assignment: mapProgramExercise(assignment),
          exercise: mapExercise(exercise),
        ),
      );
    }
    return result;
  }

  Future<List<domain.ProgramExerciseItem>> _itemsForResults(
    List<WorkoutExerciseResult> results,
  ) async {
    final items = <domain.ProgramExerciseItem>[];
    for (final result in results) {
      final assignment = await (db.select(db.programExercises)
            ..where((t) => t.id.equals(result.programExerciseId)))
          .getSingleOrNull();
      final exercise = await (db.select(db.exercises)
            ..where((t) => t.id.equals(result.exerciseId)))
          .getSingle();
      if (assignment != null) {
        items.add(
          domain.ProgramExerciseItem(
            assignment: mapProgramExercise(assignment),
            exercise: mapExercise(exercise),
          ),
        );
        continue;
      }
      items.add(
        domain.ProgramExerciseItem(
          assignment: domain.ProgramExercise(
            id: result.programExerciseId,
            programDayId: '',
            exerciseId: result.exerciseId,
            order: result.sortOrder,
            sets: result.plannedSets,
            repetitions: result.plannedRepetitions,
            duration: result.plannedDuration,
            rest: 0,
          ),
          exercise: mapExercise(exercise),
        ),
      );
    }
    return items;
  }

  Future<WorkoutSession?> _todaysSession(String userId, String dayId, DateTime now) async {
    final rows = await (db.select(db.workoutSessions)
          ..where((t) => t.userId.equals(userId) & t.programDayId.equals(dayId))
          ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]))
        .get();
    for (final row in rows) {
      if (isSameDay(row.startedAt, now)) return row;
    }
    return null;
  }

  bool _resumable(domain.WorkoutStatus status) {
    return status == domain.WorkoutStatus.started ||
        status == domain.WorkoutStatus.partiallyCompleted;
  }

  Future<WorkoutSession> _reopen(WorkoutSession row) async {
    if (row.status != domain.WorkoutStatus.partiallyCompleted) return row;
    await (db.update(db.workoutSessions)..where((t) => t.id.equals(row.id)))
        .write(
      WorkoutSessionsCompanion(
        status: const Value(domain.WorkoutStatus.started),
        completedAt: const Value(null),
        duration: const Value(null),
      ),
    );
    return (await (db.select(db.workoutSessions)
          ..where((t) => t.id.equals(row.id)))
        .getSingle());
  }

  Future<Set<String>> _dayIds({required bool localOnly}) async {
    final days = await db.select(db.programDays).get();
    return {
      for (final day in days)
        if (domain.isLocalProgramId(day.programId) == localOnly) day.id,
    };
  }

  Future<domain.InProgressInfo?> _inProgressInfo(
    String userId, {
    required bool localOnly,
  }) async {
    final rows = await (db.select(db.workoutSessions)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]))
        .get();
    final allowedDays = await _dayIds(localOnly: localOnly);
    WorkoutSession? row;
    for (final candidate in rows) {
      if (_resumable(candidate.status) &&
          allowedDays.contains(candidate.programDayId)) {
        row = candidate;
        break;
      }
    }
    if (row == null) return null;
    final session = row;
    final day = await (db.select(db.programDays)
          ..where((t) => t.id.equals(session.programDayId)))
        .getSingleOrNull();
    if (day == null) return null;
    final results = await (db.select(db.workoutExerciseResults)
          ..where((t) => t.workoutSessionId.equals(session.id)))
        .get();
    return domain.InProgressInfo(
      session: mapSession(session),
      day: mapProgramDay(day),
      completedExercises: results.where((r) => r.completed).length,
      totalExercises: results.length,
    );
  }

  @override
  Future<domain.HomeSnapshot> getHomeSnapshot(
    DateTime now, {
    required bool localOnly,
  }) async {
    final user = await _userRow();
    final programs = await _activePrograms(user.id, localOnly: localOnly);
    final todayWorkouts = <domain.TodayWorkout>[];
    for (final program in programs) {
      final todayDay = await _todayDay(program, now);
      if (todayDay == null) continue;
      final session = await _todaysSession(user.id, todayDay.id, now);
      todayWorkouts.add(
        domain.TodayWorkout(
          program: mapProgram(program),
          day: mapProgramDay(todayDay),
          exercises: await _itemsForDay(todayDay.id),
          session: session == null ? null : mapSession(session),
        ),
      );
    }
    return domain.HomeSnapshot(
      user: mapUser(user),
      todayWorkouts: todayWorkouts,
      inProgress: await _inProgressInfo(user.id, localOnly: localOnly),
      weekStats: await _weekStats(user.id, now, localOnly: localOnly),
    );
  }

  Future<domain.WeekStats> _weekStats(
    String userId,
    DateTime now, {
    required bool localOnly,
  }) async {
    final weekStart = startOfWeekMonday(now);
    final weekEnd = weekStart.add(const Duration(days: 7));
    final allowedDays = await _dayIds(localOnly: localOnly);
    final sessions = await (db.select(db.workoutSessions)
          ..where((t) => t.userId.equals(userId)))
        .get();
    final weekSessions = sessions.where((s) {
      return allowedDays.contains(s.programDayId) &&
          !s.startedAt.isBefore(weekStart) &&
          s.startedAt.isBefore(weekEnd);
    }).toList();
    final counted = weekSessions.where((s) {
      return s.status == domain.WorkoutStatus.completed ||
          s.status == domain.WorkoutStatus.partiallyCompleted;
    }).toList();

    var minutes = 0;
    var exerciseCount = 0;
    for (final session in counted) {
      minutes += ((session.duration ?? 0) / 60).round();
      final results = await (db.select(db.workoutExerciseResults)
            ..where((t) => t.workoutSessionId.equals(session.id)))
          .get();
      exerciseCount += results.where((r) => r.completed).length;
    }

    var scheduledSoFar = 0;
    var completedScheduled = 0;
    final programs = await _activePrograms(userId, localOnly: localOnly);
    for (final program in programs) {
      final days = await (db.select(db.programDays)
            ..where((t) => t.programId.equals(program.id)))
          .get();
      for (final day in days) {
        final weekday = day.weekday;
        if (weekday == null) continue;
        if (weekday > now.weekday) continue;
        scheduledSoFar += 1;
        final dayDate = weekStart.add(Duration(days: weekday - 1));
        final done = counted.any((s) {
          return s.programDayId == day.id &&
              isSameDay(s.startedAt, dayDate) &&
              s.status == domain.WorkoutStatus.completed;
        });
        if (done) completedScheduled += 1;
      }
    }

    final completion =
        scheduledSoFar == 0 ? 0.0 : completedScheduled / scheduledSoFar;

    return domain.WeekStats(
      workouts: counted.length,
      minutes: minutes,
      exercises: exerciseCount,
      completion: completion,
    );
  }

  Future<domain.MonthStats> _monthStats(
    String userId,
    DateTime now, {
    required bool localOnly,
  }) async {
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 1);
    final allowedDays = await _dayIds(localOnly: localOnly);
    final sessions = await (db.select(db.workoutSessions)
          ..where((t) => t.userId.equals(userId)))
        .get();
    final month = sessions.where((s) {
      final inRange =
          !s.startedAt.isBefore(start) && s.startedAt.isBefore(end);
      final done = s.status == domain.WorkoutStatus.completed ||
          s.status == domain.WorkoutStatus.partiallyCompleted;
      return allowedDays.contains(s.programDayId) && inRange && done;
    }).toList();
    var minutes = 0;
    for (final s in month) {
      minutes += ((s.duration ?? 0) / 60).round();
    }
    return domain.MonthStats(workouts: month.length, minutes: minutes);
  }

  @override
  Future<domain.ProgramSnapshot> getProgramSnapshot(
    DateTime now, {
    required bool localOnly,
  }) async {
    final user = await _userRow();
    final programs = await _activePrograms(user.id, localOnly: localOnly);
    final views = <domain.AssignedProgramView>[];
    for (final program in programs) {
      views.add(await _assignedProgramView(user.id, program, now));
    }
    return domain.ProgramSnapshot(programs: views);
  }

  Future<domain.AssignedProgramView> _assignedProgramView(
    String userId,
    TrainingProgram program,
    DateTime now,
  ) async {
    final days = await (db.select(db.programDays)
          ..where((t) => t.programId.equals(program.id))
          ..orderBy([(t) => OrderingTerm.asc(t.weekday)]))
        .get();
    final exercisesByDay = <String, List<domain.ProgramExerciseItem>>{};
    final completed = <String>{};
    final inProgressByDayId = <String, String>{};
    final weekStart = startOfWeekMonday(now);
    for (final day in days) {
      if (day.weekday == null &&
          !domain.isAnytimeSchedule(program.scheduleType)) {
        continue;
      }
      exercisesByDay[day.id] = await _itemsForDay(day.id);
      final todaySession = await _todaysSession(userId, day.id, now);
      if (todaySession != null && _resumable(todaySession.status)) {
        inProgressByDayId[day.id] = todaySession.id;
      }
      if (day.weekday == null) {
        if (todaySession != null &&
            todaySession.status == domain.WorkoutStatus.completed) {
          completed.add(day.id);
        }
        continue;
      }
      final dayDate = weekStart.add(Duration(days: day.weekday! - 1));
      final session = await _todaysSession(userId, day.id, dayDate);
      if (session != null &&
          session.status == domain.WorkoutStatus.completed &&
          isSameDay(session.startedAt, dayDate)) {
        completed.add(day.id);
      }
    }
    return domain.AssignedProgramView(
      program: mapProgram(program),
      days: [
        for (final day in days)
          if (day.weekday != null ||
              domain.isAnytimeSchedule(program.scheduleType))
            mapProgramDay(day),
      ],
      exercisesByDay: exercisesByDay,
      completedDayIds: completed,
      inProgressByDayId: inProgressByDayId,
    );
  }

  @override
  Future<domain.HistorySnapshot> getHistorySnapshot(
    DateTime now, {
    required bool localOnly,
  }) async {
    final user = await _userRow();
    final allowedDays = await _dayIds(localOnly: localOnly);
    final sessions = await (db.select(db.workoutSessions)
          ..where((t) => t.userId.equals(user.id))
          ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]))
        .get();
    final days = await db.select(db.programDays).get();
    final dayMap = {
      for (final day in days)
        if (allowedDays.contains(day.id)) day.id: mapProgramDay(day),
    };
    return domain.HistorySnapshot(
      sessions: [
        for (final session in sessions)
          if (allowedDays.contains(session.programDayId)) mapSession(session),
      ],
      dayTitles: dayMap,
      weekStats: await _weekStats(user.id, now, localOnly: localOnly),
      monthStats: await _monthStats(user.id, now, localOnly: localOnly),
      notesBySessionId: await _notesBySessionId(),
    );
  }

  Future<Map<String, List<domain.HistoryExerciseNote>>> _notesBySessionId() async {
    final rows = await db.select(db.workoutExerciseResults).get();
    final noted = rows
        .where((row) => (row.notes ?? '').trim().isNotEmpty)
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    if (noted.isEmpty) return const {};

    final exerciseIds = noted.map((row) => row.exerciseId).toSet();
    final exercises = await (db.select(db.exercises)
          ..where((t) => t.id.isIn(exerciseIds)))
        .get();
    final names = {for (final exercise in exercises) exercise.id: exercise.name};

    final notes = <String, List<domain.HistoryExerciseNote>>{};
    for (final row in noted) {
      final name = names[row.exerciseId];
      if (name == null) continue;
      notes.putIfAbsent(row.workoutSessionId, () => []).add(
            domain.HistoryExerciseNote(
              exerciseName: name,
              note: row.notes!.trim(),
            ),
          );
    }
    return notes;
  }

  @override
  Future<domain.WorkoutSession> startOrResumeSession(String programDayId) async {
    final user = await _userRow();
    final now = DateTime.now();
    final existing = await _todaysSession(user.id, programDayId, now);
    if (existing != null && _resumable(existing.status)) {
      return mapSession(await _reopen(existing));
    }

    final sessionId = _uuid.v4();
    await db.into(db.workoutSessions).insert(
          WorkoutSessionsCompanion.insert(
            id: sessionId,
            userId: user.id,
            programDayId: programDayId,
            startedAt: now,
            status: domain.WorkoutStatus.started,
          ),
        );

    final items = await _itemsForDay(programDayId);
    for (final item in items) {
      final resultId = _uuid.v4();
      await db.into(db.workoutExerciseResults).insert(
            WorkoutExerciseResultsCompanion.insert(
              id: resultId,
              workoutSessionId: sessionId,
              exerciseId: item.exercise.id,
              programExerciseId: item.assignment.id,
              sortOrder: item.assignment.order,
              plannedSets: item.assignment.sets,
              plannedRepetitions: Value(item.assignment.repetitions),
              plannedDuration: Value(item.assignment.duration),
            ),
          );
      for (var i = 1; i <= item.assignment.sets; i++) {
        await db.into(db.workoutSetResults).insert(
              WorkoutSetResultsCompanion.insert(
                id: _uuid.v4(),
                workoutExerciseResultId: resultId,
                setNumber: i,
                plannedReps: Value(item.assignment.repetitions),
                plannedDuration: Value(item.assignment.duration),
                plannedLoadKg: Value(item.assignment.loadKg),
              ),
            );
      }
    }

    final created = await (db.select(db.workoutSessions)
          ..where((t) => t.id.equals(sessionId)))
        .getSingle();
    return mapSession(created);
  }

  @override
  Future<domain.WorkoutSession> resumeSession(String sessionId) async {
    final row = await (db.select(db.workoutSessions)
          ..where((t) => t.id.equals(sessionId)))
        .getSingle();
    if (!_resumable(row.status)) {
      throw StateError('Session cannot be resumed');
    }
    return mapSession(await _reopen(row));
  }

  @override
  Future<domain.WorkoutPlayback> getPlayback(String sessionId) async {
    final session = await (db.select(db.workoutSessions)
          ..where((t) => t.id.equals(sessionId)))
        .getSingle();
    final day = await (db.select(db.programDays)
          ..where((t) => t.id.equals(session.programDayId)))
        .getSingle();
    final results = await (db.select(db.workoutExerciseResults)
          ..where((t) => t.workoutSessionId.equals(sessionId))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
    final items = await _itemsForResults(results);
    final setsByResult = <String, List<domain.WorkoutSetResult>>{};
    for (final result in results) {
      final sets = await (db.select(db.workoutSetResults)
            ..where((t) => t.workoutExerciseResultId.equals(result.id))
            ..orderBy([(t) => OrderingTerm.asc(t.setNumber)]))
          .get();
      setsByResult[result.id] = sets.map(mapSetResult).toList();
    }
    final program = await (db.select(db.trainingPrograms)
          ..where((t) => t.id.equals(day.programId)))
        .getSingle();
    return domain.WorkoutPlayback(
      session: mapSession(session),
      day: mapProgramDay(day),
      program: mapProgram(program),
      items: items,
      results: results.map(mapExerciseResult).toList(),
      setsByResult: setsByResult,
    );
  }

  @override
  Future<void> saveSetResult(domain.WorkoutSetResult set) async {
    await (db.update(db.workoutSetResults)..where((t) => t.id.equals(set.id)))
        .write(
      WorkoutSetResultsCompanion(
        actualReps: Value(set.actualReps),
        actualDuration: Value(set.actualDuration),
        actualLoadKg: Value(set.actualLoadKg),
        completed: Value(set.completed),
      ),
    );
  }

  @override
  Future<void> saveExerciseResult(domain.WorkoutExerciseResult result) async {
    await (db.update(db.workoutExerciseResults)
          ..where((t) => t.id.equals(result.id)))
        .write(
      WorkoutExerciseResultsCompanion(
        actualSets: Value(result.actualSets),
        actualRepetitions: Value(result.actualRepetitions),
        actualDuration: Value(result.actualDuration),
        completed: Value(result.completed),
        effort: Value(result.effort),
        notes: Value(result.notes),
      ),
    );
  }

  @override
  Future<void> saveSessionNotes(String sessionId, String? notes) async {
    final trimmed = notes?.trim();
    await (db.update(db.workoutSessions)..where((t) => t.id.equals(sessionId)))
        .write(
      WorkoutSessionsCompanion(
        notes: Value((trimmed == null || trimmed.isEmpty) ? null : trimmed),
      ),
    );
  }

  @override
  Future<void> finishSession(String sessionId, {required bool partial}) async {
    final session = await (db.select(db.workoutSessions)
          ..where((t) => t.id.equals(sessionId)))
        .getSingle();
    final end = DateTime.now();
    final seconds = end.difference(session.startedAt).inSeconds;
    final playback = await getPlayback(sessionId);
    var volume = 0.0;
    for (final sets in playback.setsByResult.values) {
      for (final set in sets) {
        final kg = set.actualLoadKg ?? set.plannedLoadKg;
        final reps = set.actualReps ?? set.plannedReps;
        if (kg != null && reps != null) {
          volume += kg * reps;
        }
      }
    }
    await (db.update(db.workoutSessions)..where((t) => t.id.equals(sessionId)))
        .write(
      WorkoutSessionsCompanion(
        completedAt: Value(end),
        duration: Value(seconds),
        totalVolumeKg: Value(volume > 0 ? volume : null),
        status: Value(
          partial
              ? domain.WorkoutStatus.partiallyCompleted
              : domain.WorkoutStatus.completed,
        ),
      ),
    );
  }

  @override
  Future<void> upsertExercises(List<domain.Exercise> items) async {
    for (final item in items) {
      await db.into(db.exercises).insertOnConflictUpdate(
            ExercisesCompanion.insert(
              id: item.id,
              name: item.name,
              description: item.description,
              instructions: item.instructions,
              photo: item.photo,
              category: item.category,
              difficulty: item.difficulty,
              duration: Value(item.duration),
              repetitions: Value(item.repetitions),
              targetMuscles: item.targetMuscles,
              equipment: item.equipment,
              safetyNotes: item.safetyNotes,
              venue: Value(item.venue),
              workoutType: Value(item.workoutType),
              gymNumber: Value(item.gymNumber),
              active: Value(item.active),
              createdAt: item.createdAt,
              updatedAt: item.updatedAt,
            ),
          );
    }
  }

  @override
  Future<void> upsertAssignedPrograms(List<domain.RemoteProgramTree> trees) async {
    if (trees.isEmpty) return;
    final user = await _userRow();
    final seen = <String>{};
    final unique = <domain.RemoteProgramTree>[];
    for (final tree in trees) {
      if (!seen.add(tree.program.id)) continue;
      unique.add(tree);
    }
    final ids = unique.map((tree) => tree.program.id).toList();
    for (final tree in unique) {
      await db.into(db.trainingPrograms).insertOnConflictUpdate(
            TrainingProgramsCompanion.insert(
              id: tree.program.id,
              userId: user.id,
              name: tree.program.name,
              description: tree.program.description,
              startDate: Value(tree.program.startDate),
              endDate: Value(tree.program.endDate),
              scheduleType: tree.program.scheduleType,
              venue: Value(tree.program.venue),
              active: const Value(true),
              createdAt: tree.program.createdAt,
              updatedAt: tree.program.updatedAt,
            ),
          );
      for (final day in tree.days) {
        await db.into(db.programDays).insertOnConflictUpdate(
              ProgramDaysCompanion.insert(
                id: day.id,
                programId: tree.program.id,
                date: Value(day.date),
                weekday: Value(day.weekday),
                title: day.title,
                description: day.description,
              ),
            );
      }
      for (final assignment in tree.assignments) {
        final exercise = await (db.select(db.exercises)
              ..where((t) => t.id.equals(assignment.exerciseId)))
            .getSingleOrNull();
        if (exercise == null) continue;
        await db.into(db.programExercises).insertOnConflictUpdate(
              ProgramExercisesCompanion.insert(
                id: assignment.id,
                programDayId: assignment.programDayId,
                exerciseId: assignment.exerciseId,
                sortOrder: assignment.order,
                sets: assignment.sets,
                repetitions: Value(assignment.repetitions),
                duration: Value(assignment.duration),
                loadKg: Value(assignment.loadKg),
                rest: Value(assignment.rest),
                notes: Value(assignment.notes),
                active: const Value(true),
              ),
            );
      }
      final dayIds = tree.days.map((day) => day.id).toList();
      if (dayIds.isEmpty) continue;
      final keep = tree.assignments.map((row) => row.id).toList();
      final stale = await (db.select(db.programExercises)
            ..where((t) {
              final onProgram = t.programDayId.isIn(dayIds);
              return keep.isEmpty ? onProgram : onProgram & t.id.isNotIn(keep);
            }))
          .get();
      for (final row in stale) {
        await (db.update(db.programExercises)..where((t) => t.id.equals(row.id)))
            .write(const ProgramExercisesCompanion(active: Value(false)));
      }
    }
    final stale = await (db.select(db.trainingPrograms)
          ..where((t) => t.userId.equals(user.id) & t.id.isNotIn(ids)))
        .get();
    for (final row in stale) {
      if (domain.isLocalProgramId(row.id)) continue;
      await (db.update(db.trainingPrograms)..where((t) => t.id.equals(row.id)))
          .write(const TrainingProgramsCompanion(active: Value(false)));
    }
  }

  @override
  Future<String> saveLocalProgram(domain.LocalProgramDraft draft) async {
    final user = await _userRow();
    final now = DateTime.now();
    final id = draft.id ?? '${domain.localProgramPrefix}${_uuid.v4()}';
    final occasional = draft.isOccasional;
    final keys = occasional
        ? const [domain.occasionalSlotKey]
        : ([...draft.weekdays]..sort());
    await db.into(db.trainingPrograms).insertOnConflictUpdate(
          TrainingProgramsCompanion.insert(
            id: id,
            userId: user.id,
            name: draft.name.trim(),
            description: '',
            scheduleType: occasional
                ? domain.ScheduleType.occasional
                : draft.scheduleType,
            venue: Value(draft.venue),
            active: const Value(true),
            createdAt: now,
            updatedAt: now,
          ),
        );

    final existingDays = await (db.select(db.programDays)
          ..where((t) => t.programId.equals(id)))
        .get();
    final keepDayIds = <String>{};
    for (final key in keys) {
      final dayId = occasional ? '$id-day-any' : '$id-day-$key';
      keepDayIds.add(dayId);
      await db.into(db.programDays).insertOnConflictUpdate(
            ProgramDaysCompanion.insert(
              id: dayId,
              programId: id,
              weekday: occasional ? const Value(null) : Value(key),
              title: occasional
                  ? const domain.LocalizedText(
                      en: 'Anytime',
                      he: 'מתי שרוצים',
                    )
                  : _localDayTitle(key),
              description: const domain.LocalizedText(en: '', he: ''),
            ),
          );
      final slots = draft.slotsByWeekday[key] ?? const [];
      final keepSlots = <String>[];
      for (var index = 0; index < slots.length; index++) {
        final slot = slots[index];
        final slotId = '$dayId-ex-$index';
        keepSlots.add(slotId);
        await db.into(db.programExercises).insertOnConflictUpdate(
              ProgramExercisesCompanion.insert(
                id: slotId,
                programDayId: dayId,
                exerciseId: slot.exerciseId,
                sortOrder: index,
                sets: slot.sets,
                repetitions: Value(slot.repetitions),
                duration: Value(slot.duration),
                loadKg: Value(slot.loadKg),
                rest: Value(slot.rest),
                active: const Value(true),
              ),
            );
      }
      final staleSlots = await (db.select(db.programExercises)
            ..where((t) {
              final onDay = t.programDayId.equals(dayId);
              return keepSlots.isEmpty
                  ? onDay
                  : onDay & t.id.isNotIn(keepSlots);
            }))
          .get();
      for (final row in staleSlots) {
        await (db.update(db.programExercises)..where((t) => t.id.equals(row.id)))
            .write(const ProgramExercisesCompanion(active: Value(false)));
      }
    }
    for (final day in existingDays) {
      if (keepDayIds.contains(day.id)) continue;
      await (db.update(db.programDays)..where((t) => t.id.equals(day.id)))
          .write(const ProgramDaysCompanion(weekday: Value(null)));
      await (db.update(db.programExercises)
            ..where((t) => t.programDayId.equals(day.id)))
          .write(const ProgramExercisesCompanion(active: Value(false)));
    }
    return id;
  }

  domain.LocalizedText _localDayTitle(int weekday) {
    return switch (weekday) {
      DateTime.monday =>
        const domain.LocalizedText(en: 'Monday', he: 'שני'),
      DateTime.tuesday =>
        const domain.LocalizedText(en: 'Tuesday', he: 'שלישי'),
      DateTime.wednesday =>
        const domain.LocalizedText(en: 'Wednesday', he: 'רביעי'),
      DateTime.thursday =>
        const domain.LocalizedText(en: 'Thursday', he: 'חמישי'),
      DateTime.friday =>
        const domain.LocalizedText(en: 'Friday', he: 'שישי'),
      DateTime.saturday =>
        const domain.LocalizedText(en: 'Saturday', he: 'שבת'),
      DateTime.sunday =>
        const domain.LocalizedText(en: 'Sunday', he: 'ראשון'),
      _ => domain.LocalizedText(en: 'Day $weekday', he: ''),
    };
  }

  @override
  Future<domain.LocalProgramDraft?> getLocalProgram(String id) async {
    if (!domain.isLocalProgramId(id)) return null;
    final row = await (db.select(db.trainingPrograms)
          ..where((t) => t.id.equals(id) & t.active.equals(true)))
        .getSingleOrNull();
    if (row == null) return null;
    final days = await (db.select(db.programDays)
          ..where((t) => t.programId.equals(id)))
        .get();
    final weekdays = <int>[];
    final slots = <int, List<domain.LocalProgramSlot>>{};
    final occasional = domain.isAnytimeSchedule(row.scheduleType);
    for (final day in days) {
      final weekday = day.weekday;
      if (weekday == null && !occasional) continue;
      final key = weekday ?? domain.occasionalSlotKey;
      if (weekday != null) weekdays.add(weekday);
      final assignments = await (db.select(db.programExercises)
            ..where(
              (t) => t.programDayId.equals(day.id) & t.active.equals(true),
            )
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .get();
      slots[key] = [
        for (final assignment in assignments)
          domain.LocalProgramSlot(
            exerciseId: assignment.exerciseId,
            sets: assignment.sets,
            repetitions: assignment.repetitions,
            duration: assignment.duration,
            loadKg: assignment.loadKg,
            rest: assignment.rest,
          ),
      ];
    }
    weekdays.sort();
    return domain.LocalProgramDraft(
      id: id,
      name: row.name,
      venue: row.venue,
      scheduleType: row.scheduleType,
      weekdays: weekdays,
      slotsByWeekday: slots,
    );
  }

  @override
  Future<void> deleteLocalProgram(String id) async {
    if (!domain.isLocalProgramId(id)) return;
    await (db.update(db.trainingPrograms)..where((t) => t.id.equals(id))).write(
      const TrainingProgramsCompanion(active: Value(false)),
    );
  }
}
