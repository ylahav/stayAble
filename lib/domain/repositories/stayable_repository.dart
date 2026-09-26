import '../entities/app_user.dart';
import '../entities/enums.dart';
import '../entities/exercise.dart';
import '../entities/localized_text.dart';
import '../entities/program_day.dart';
import '../entities/program_exercise.dart';
import '../entities/trainee_assessment.dart';
import '../entities/training_program.dart';
import '../entities/workout_exercise_result.dart';
import '../entities/workout_session.dart';
import '../entities/workout_set_result.dart';

class ProgramExerciseItem {
  const ProgramExerciseItem({
    required this.assignment,
    required this.exercise,
  });

  final ProgramExercise assignment;
  final Exercise exercise;
}

class WeekStats {
  const WeekStats({
    required this.workouts,
    required this.minutes,
    required this.exercises,
    required this.completion,
  });

  final int workouts;
  final int minutes;
  final int exercises;
  final double completion;
}

class MonthStats {
  const MonthStats({
    required this.workouts,
    required this.minutes,
  });

  final int workouts;
  final int minutes;
}

class TodayWorkout {
  const TodayWorkout({
    required this.program,
    required this.day,
    required this.exercises,
    this.session,
  });

  final TrainingProgram program;
  final ProgramDay day;
  final List<ProgramExerciseItem> exercises;
  final WorkoutSession? session;
}

class HomeSnapshot {
  const HomeSnapshot({
    required this.user,
    required this.todayWorkouts,
    this.inProgress,
    required this.weekStats,
  });

  final AppUser user;
  final List<TodayWorkout> todayWorkouts;
  final InProgressInfo? inProgress;
  final WeekStats weekStats;

  ProgramDay? get todayDay =>
      todayWorkouts.isEmpty ? null : todayWorkouts.first.day;

  List<ProgramExerciseItem> get todayExercises =>
      todayWorkouts.isEmpty ? const [] : todayWorkouts.first.exercises;

  WorkoutSession? get todaysSession =>
      todayWorkouts.isEmpty ? null : todayWorkouts.first.session;

  bool get isRestDay => todayWorkouts.isEmpty;
  bool get hasInProgress => inProgress != null;
}

class InProgressInfo {
  const InProgressInfo({
    required this.session,
    required this.day,
    required this.completedExercises,
    required this.totalExercises,
  });

  final WorkoutSession session;
  final ProgramDay day;
  final int completedExercises;
  final int totalExercises;
}

class AssignedProgramView {
  const AssignedProgramView({
    required this.program,
    required this.days,
    required this.exercisesByDay,
    required this.completedDayIds,
    required this.inProgressByDayId,
  });

  final TrainingProgram program;
  final List<ProgramDay> days;
  final Map<String, List<ProgramExerciseItem>> exercisesByDay;
  final Set<String> completedDayIds;
  final Map<String, String> inProgressByDayId;
}

class ProgramSnapshot {
  const ProgramSnapshot({required this.programs});

  final List<AssignedProgramView> programs;
}

class HistoryExerciseNote {
  const HistoryExerciseNote({
    required this.exerciseName,
    required this.note,
  });

  final LocalizedText exerciseName;
  final String note;
}

class HistorySnapshot {
  const HistorySnapshot({
    required this.sessions,
    required this.dayTitles,
    required this.weekStats,
    required this.monthStats,
    this.notesBySessionId = const {},
  });

  final List<WorkoutSession> sessions;
  final Map<String, ProgramDay> dayTitles;
  final WeekStats weekStats;
  final MonthStats monthStats;
  final Map<String, List<HistoryExerciseNote>> notesBySessionId;
}

class WorkoutPlayback {
  const WorkoutPlayback({
    required this.session,
    required this.day,
    required this.program,
    required this.items,
    required this.results,
    required this.setsByResult,
  });

  final WorkoutSession session;
  final ProgramDay day;
  final TrainingProgram program;
  final List<ProgramExerciseItem> items;
  final List<WorkoutExerciseResult> results;
  final Map<String, List<WorkoutSetResult>> setsByResult;
}

class LocalProgramSlot {
  const LocalProgramSlot({
    required this.exerciseId,
    required this.sets,
    this.repetitions,
    this.duration,
    this.loadKg,
    this.rest = 30,
  });

  final String exerciseId;
  final int sets;
  final int? repetitions;
  final int? duration;
  final double? loadKg;
  final int rest;

  LocalProgramSlot copyWith({
    String? exerciseId,
    int? sets,
    int? repetitions,
    int? duration,
    double? loadKg,
    int? rest,
    bool clearRepetitions = false,
    bool clearDuration = false,
    bool clearLoadKg = false,
  }) {
    return LocalProgramSlot(
      exerciseId: exerciseId ?? this.exerciseId,
      sets: sets ?? this.sets,
      repetitions:
          clearRepetitions ? null : (repetitions ?? this.repetitions),
      duration: clearDuration ? null : (duration ?? this.duration),
      loadKg: clearLoadKg ? null : (loadKg ?? this.loadKg),
      rest: rest ?? this.rest,
    );
  }
}

class LocalProgramDraft {
  const LocalProgramDraft({
    this.id,
    required this.name,
    required this.venue,
    this.scheduleType = ScheduleType.weekly,
    required this.weekdays,
    required this.slotsByWeekday,
  });

  final String? id;
  final String name;
  final ProgramVenue venue;
  final ScheduleType scheduleType;
  final List<int> weekdays;
  final Map<int, List<LocalProgramSlot>> slotsByWeekday;

  bool get isOccasional => isAnytimeSchedule(scheduleType);
}

class RemoteProgramTree {
  const RemoteProgramTree({
    required this.program,
    required this.days,
    required this.assignments,
  });

  final TrainingProgram program;
  final List<ProgramDay> days;
  final List<ProgramExercise> assignments;
}

abstract class StayAbleRepository {
  Future<AppUser> getCurrentUser();
  Future<void> useUserId(String id);
  Future<void> ensureSignedInUser({
    required String id,
    required String name,
    required String email,
    required String language,
  });
  Future<void> setLanguage(String languageCode);
  Future<void> setBirthDate(DateTime birthDate);
  Future<void> setAssessment(TraineeAssessment assessment);
  Future<void> applyRemoteProfile({
    DateTime? birthDate,
    TraineeAssessment? assessment,
    FitnessLevel? fitnessLevel,
    List<FitnessGoal>? goals,
    ExerciseVenue? trainingVenue,
  });

  Future<List<Exercise>> getExercises({
    ExerciseCategory? category,
    WorkoutType? workoutType,
    bool homeCapable = false,
    String? query,
    List<String>? tags,
  });
  Future<Set<String>> getExerciseIds();
  Future<Exercise?> getExercise(String id);

  Future<HomeSnapshot> getHomeSnapshot(DateTime now, {required bool localOnly});
  Future<ProgramSnapshot> getProgramSnapshot(DateTime now, {required bool localOnly});
  Future<HistorySnapshot> getHistorySnapshot(DateTime now, {required bool localOnly});

  Future<WorkoutSession> startOrResumeSession(String programDayId);
  Future<WorkoutSession> resumeSession(String sessionId);
  Future<WorkoutPlayback> getPlayback(String sessionId);
  Future<void> saveSetResult(WorkoutSetResult set);
  Future<void> saveExerciseResult(WorkoutExerciseResult result);
  Future<void> saveSessionNotes(String sessionId, String? notes);
  Future<void> finishSession(String sessionId, {required bool partial});
  Future<void> upsertExercises(List<Exercise> items);
  Future<void> upsertAssignedPrograms(List<RemoteProgramTree> trees);
  Future<LocalProgramDraft?> getLocalProgram(String id);
  Future<String> saveLocalProgram(LocalProgramDraft draft);
  Future<void> deleteLocalProgram(String id);
}
