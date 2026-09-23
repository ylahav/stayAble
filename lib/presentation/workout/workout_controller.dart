import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/audio/timer_chime.dart';
import '../../domain/domain.dart';
import '../auth/auth_controller.dart';
import '../providers.dart';

enum WorkoutPhase { picking, ready, timed, loggingSet, rest, effort, finished }

class WorkoutViewState {
  const WorkoutViewState({
    required this.playback,
    required this.exerciseIndex,
    required this.setIndex,
    required this.phase,
    required this.remainingSeconds,
    required this.loggedReps,
    required this.loggedLoadKg,
    this.selectedEffort,
  });

  final WorkoutPlayback playback;
  final int exerciseIndex;
  final int setIndex;
  final WorkoutPhase phase;
  final int remainingSeconds;
  final int loggedReps;
  final double loggedLoadKg;
  final PerceivedEffort? selectedEffort;

  ProgramExerciseItem get currentItem => playback.items[exerciseIndex];
  WorkoutExerciseResult get currentResult => playback.results[exerciseIndex];
  List<WorkoutSetResult> get currentSets =>
      playback.setsByResult[currentResult.id] ?? const [];
  WorkoutSetResult get currentSet => currentSets[setIndex];
  bool get freeOrder => playback.program.venue != ProgramVenue.home;
  int get completedExerciseCount =>
      playback.results.where((result) => result.completed).length;
  bool get isLastExercise {
    if (freeOrder) {
      return playback.results.where((result) => !result.completed).length <= 1;
    }
    return exerciseIndex >= playback.items.length - 1;
  }
  bool get isLastSet => setIndex >= currentSets.length - 1;
  int get plannedSeconds => currentItem.assignment.duration ?? remainingSeconds;

  WorkoutViewState copyWith({
    WorkoutPlayback? playback,
    int? exerciseIndex,
    int? setIndex,
    WorkoutPhase? phase,
    int? remainingSeconds,
    int? loggedReps,
    double? loggedLoadKg,
    PerceivedEffort? selectedEffort,
    bool clearEffort = false,
  }) {
    return WorkoutViewState(
      playback: playback ?? this.playback,
      exerciseIndex: exerciseIndex ?? this.exerciseIndex,
      setIndex: setIndex ?? this.setIndex,
      phase: phase ?? this.phase,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      loggedReps: loggedReps ?? this.loggedReps,
      loggedLoadKg: loggedLoadKg ?? this.loggedLoadKg,
      selectedEffort:
          clearEffort ? null : (selectedEffort ?? this.selectedEffort),
    );
  }
}

class WorkoutController extends AsyncNotifier<WorkoutViewState> {
  WorkoutController(this.sessionId);

  final String sessionId;
  Timer? _timer;

  StayAbleRepository get _repo => ref.read(repositoryProvider);

  @override
  Future<WorkoutViewState> build() async {
    ref.onDispose(() => _timer?.cancel());
    final playback = await _repo.getPlayback(sessionId);
    return _initial(playback);
  }

  WorkoutViewState _initial(WorkoutPlayback playback) {
    final incomplete = <int>[];
    var resumeIndex = -1;
    for (var i = 0; i < playback.results.length; i++) {
      final result = playback.results[i];
      if (result.completed) continue;
      incomplete.add(i);
      final sets = playback.setsByResult[result.id] ?? const [];
      if (resumeIndex < 0 && sets.any((set) => set.completed)) {
        resumeIndex = i;
      }
    }
    if (incomplete.isEmpty) {
      return WorkoutViewState(
        playback: playback,
        exerciseIndex: playback.items.isEmpty ? 0 : playback.items.length - 1,
        setIndex: 0,
        phase: WorkoutPhase.finished,
        remainingSeconds: 0,
        loggedReps: 0,
        loggedLoadKg: 0,
      );
    }
    final freeOrder = playback.program.venue != ProgramVenue.home;
    if (freeOrder && resumeIndex < 0) {
      return WorkoutViewState(
        playback: playback,
        exerciseIndex: incomplete.first,
        setIndex: 0,
        phase: WorkoutPhase.picking,
        remainingSeconds: 0,
        loggedReps: 0,
        loggedLoadKg: 0,
      );
    }
    final index = freeOrder ? resumeIndex : incomplete.first;
    return _stateForExercise(playback, index, WorkoutPhase.ready);
  }

  WorkoutViewState _stateForExercise(
    WorkoutPlayback playback,
    int index,
    WorkoutPhase phase,
  ) {
    final item = playback.items[index];
    final result = playback.results[index];
    final sets = playback.setsByResult[result.id] ?? const [];
    final setIndex = sets.indexWhere((s) => !s.completed);
    return WorkoutViewState(
      playback: playback,
      exerciseIndex: index,
      setIndex: setIndex < 0 ? 0 : setIndex,
      phase: phase,
      remainingSeconds: item.assignment.duration ?? 0,
      loggedReps: item.assignment.repetitions ?? 0,
      loggedLoadKg: item.assignment.loadKg ?? 0,
    );
  }

  Future<void> _reloadKeepingPhase({
    required int exerciseIndex,
    required int setIndex,
    required WorkoutPhase phase,
    int? remainingSeconds,
    int? loggedReps,
    double? loggedLoadKg,
    PerceivedEffort? effort,
    bool clearEffort = false,
  }) async {
    final playback = await _repo.getPlayback(sessionId);
    final item = playback.items[exerciseIndex];
    state = AsyncData(
      WorkoutViewState(
        playback: playback,
        exerciseIndex: exerciseIndex,
        setIndex: setIndex,
        phase: phase,
        remainingSeconds: remainingSeconds ?? item.assignment.duration ?? 0,
        loggedReps: loggedReps ?? item.assignment.repetitions ?? 0,
        loggedLoadKg: loggedLoadKg ?? item.assignment.loadKg ?? 0,
        selectedEffort: clearEffort ? null : effort,
      ),
    );
  }

  void start() {
    final current = state.value;
    if (current == null) return;
    unawaited(TimerChime.warmUp());
    if (current.currentItem.assignment.isTimed) {
      _startTimer();
      state = AsyncData(current.copyWith(phase: WorkoutPhase.timed));
    } else {
      state = AsyncData(current.copyWith(phase: WorkoutPhase.loggingSet));
    }
  }

  void selectExercise(int index) {
    final current = state.value;
    if (current == null) return;
    if (index < 0 || index >= current.playback.results.length) return;
    if (current.playback.results[index].completed) return;
    _timer?.cancel();
    state = AsyncData(
      _stateForExercise(current.playback, index, WorkoutPhase.ready),
    );
  }

  void backToPicker() {
    final current = state.value;
    if (current == null || current.phase == WorkoutPhase.finished) return;
    _timer?.cancel();
    state = AsyncData(current.copyWith(phase: WorkoutPhase.picking));
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final current = state.value;
      if (current == null || current.phase != WorkoutPhase.timed) return;
      if (current.remainingSeconds <= 1) {
        _timer?.cancel();
        unawaited(TimerChime.playEnd());
        unawaited(completeTimedSet(seconds: current.plannedSeconds));
        return;
      }
      final remaining = current.remainingSeconds - 1;
      if (remaining <= 3) {
        unawaited(TimerChime.playTick());
      }
      state = AsyncData(current.copyWith(remainingSeconds: remaining));
    });
  }

  void adjustReps(int delta) {
    final current = state.value;
    if (current == null) return;
    setReps(current.loggedReps + delta);
  }

  void setReps(int value) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(loggedReps: value.clamp(0, 99)));
  }

  void adjustLoad(double delta) {
    final current = state.value;
    if (current == null) return;
    setLoad(current.loggedLoadKg + delta);
  }

  void setLoad(double value) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(loggedLoadKg: value.clamp(0.0, 400.0)));
  }

  Future<void> completeTimedSet({int? seconds}) async {
    final current = state.value;
    if (current == null) return;
    _timer?.cancel();
    final actual = seconds ??
        (current.plannedSeconds - current.remainingSeconds)
            .clamp(0, current.plannedSeconds);
    final set = current.currentSet.copyWith(
      actualDuration: actual,
      completed: true,
    );
    await _repo.saveSetResult(set);
    await _afterSetLogged(current, actualDuration: actual);
  }

  Future<void> logRepSet() async {
    final current = state.value;
    if (current == null) return;
    final set = current.currentSet.copyWith(
      actualReps: current.loggedReps,
      actualLoadKg: current.currentItem.assignment.loadKg == null
          ? null
          : current.loggedLoadKg,
      completed: true,
    );
    await _repo.saveSetResult(set);
    await _afterSetLogged(current, actualReps: current.loggedReps);
  }

  Future<void> _afterSetLogged(
    WorkoutViewState current, {
    int? actualReps,
    int? actualDuration,
  }) async {
    if (!current.isLastSet) {
      await _reloadKeepingPhase(
        exerciseIndex: current.exerciseIndex,
        setIndex: current.setIndex + 1,
        phase: current.currentItem.assignment.rest > 0
            ? WorkoutPhase.rest
            : WorkoutPhase.ready,
        remainingSeconds: current.currentItem.assignment.rest,
        loggedReps: current.currentItem.assignment.repetitions,
        clearEffort: true,
      );
      if (state.value?.phase == WorkoutPhase.rest) {
        unawaited(TimerChime.warmUp());
        _startRestTimer();
      }
      return;
    }

    final sets = current.currentSets.map((s) {
      if (s.setNumber == current.currentSet.setNumber) {
        return s.copyWith(
          actualReps: actualReps ?? s.actualReps,
          actualDuration: actualDuration ?? s.actualDuration,
          completed: true,
        );
      }
      return s;
    }).toList();
    final completedSets = sets.where((s) => s.completed).length;
    final totalReps = sets.fold<int>(0, (sum, s) => sum + (s.actualReps ?? 0));
    final totalDuration =
        sets.fold<int>(0, (sum, s) => sum + (s.actualDuration ?? 0));

    await _repo.saveExerciseResult(
      current.currentResult.copyWith(
        actualSets: completedSets,
        actualRepetitions: totalReps == 0 ? null : totalReps,
        actualDuration: totalDuration == 0 ? null : totalDuration,
      ),
    );

    await _reloadKeepingPhase(
      exerciseIndex: current.exerciseIndex,
      setIndex: current.setIndex,
      phase: WorkoutPhase.effort,
      clearEffort: true,
    );
  }

  void _startRestTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final current = state.value;
      if (current == null || current.phase != WorkoutPhase.rest) return;
      if (current.remainingSeconds <= 1) {
        _timer?.cancel();
        unawaited(TimerChime.playEnd());
        state = AsyncData(
          current.copyWith(
            phase: WorkoutPhase.ready,
            remainingSeconds: current.currentItem.assignment.duration ?? 0,
            loggedReps: current.currentItem.assignment.repetitions ?? 0,
            loggedLoadKg: current.currentItem.assignment.loadKg ?? 0,
          ),
        );
        return;
      }
      final remaining = current.remainingSeconds - 1;
      if (remaining <= 3) {
        unawaited(TimerChime.playTick());
      }
      state = AsyncData(current.copyWith(remainingSeconds: remaining));
    });
  }

  void skipRest() {
    _timer?.cancel();
    final current = state.value;
    if (current == null) return;
    state = AsyncData(
      current.copyWith(
        phase: WorkoutPhase.ready,
        remainingSeconds: current.currentItem.assignment.duration ?? 0,
        loggedReps: current.currentItem.assignment.repetitions ?? 0,
        loggedLoadKg: current.currentItem.assignment.loadKg ?? 0,
      ),
    );
  }

  void selectEffort(PerceivedEffort effort) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(selectedEffort: effort));
  }

  Future<void> confirmEffort({String? notes}) async {
    final current = state.value;
    if (current == null || current.selectedEffort == null) return;
    final trimmed = notes?.trim();
    await _repo.saveExerciseResult(
      current.currentResult.copyWith(
        completed: true,
        effort: current.selectedEffort,
        notes: (trimmed == null || trimmed.isEmpty) ? null : trimmed,
      ),
    );

    if (current.isLastExercise) {
      await _repo.finishSession(sessionId, partial: false);
      ref.invalidate(homeSnapshotProvider);
      ref.invalidate(programSnapshotProvider);
      ref.invalidate(historySnapshotProvider);
      unawaited(ref.read(authProvider.notifier).pushSession(sessionId));
      await _reloadKeepingPhase(
        exerciseIndex: current.exerciseIndex,
        setIndex: current.setIndex,
        phase: WorkoutPhase.finished,
      );
      return;
    }

    if (current.freeOrder) {
      final playback = await _repo.getPlayback(sessionId);
      state = AsyncData(_initial(playback));
      return;
    }

    await _reloadKeepingPhase(
      exerciseIndex: current.exerciseIndex + 1,
      setIndex: 0,
      phase: WorkoutPhase.ready,
      clearEffort: true,
    );
  }

  Future<void> finishPartial() async {
    _timer?.cancel();
    await _repo.finishSession(sessionId, partial: true);
    ref.invalidate(homeSnapshotProvider);
    ref.invalidate(programSnapshotProvider);
    ref.invalidate(historySnapshotProvider);
    unawaited(ref.read(authProvider.notifier).pushSession(sessionId));
  }
}

final workoutControllerProvider = AsyncNotifierProvider.autoDispose
    .family<WorkoutController, WorkoutViewState, String>(
  WorkoutController.new,
);
