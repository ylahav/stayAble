import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/db/app_database.dart' show AppDatabase;
import '../data/remote/session_store.dart';
import '../data/repositories/drift_stayable_repository.dart';
import '../domain/domain.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('databaseProvider must be overridden in main');
});

final repositoryProvider = Provider<StayAbleRepository>((ref) {
  return DriftStayAbleRepository(ref.watch(databaseProvider));
});

class LocaleController extends Notifier<Locale> {
  @override
  Locale build() => const Locale('en');

  Future<void> syncFromUser() async {
    final user = await ref.read(repositoryProvider).getCurrentUser();
    state = Locale(user.language);
  }

  Future<void> setCode(String languageCode) async {
    if (state.languageCode == languageCode) return;
    await ref.read(repositoryProvider).setLanguage(languageCode);
    state = Locale(languageCode);
  }

  Future<void> toggle() async {
    await setCode(state.languageCode == 'he' ? 'en' : 'he');
  }
}

final localeProvider =
    NotifierProvider<LocaleController, Locale>(LocaleController.new);

final homeSnapshotProvider = FutureProvider<HomeSnapshot>((ref) {
  final localOnly = ref.watch(appModeProvider) == AppMode.local;
  return ref.watch(repositoryProvider).getHomeSnapshot(
        DateTime.now(),
        localOnly: localOnly,
      );
});

final programSnapshotProvider = FutureProvider<ProgramSnapshot>((ref) {
  final localOnly = ref.watch(appModeProvider) == AppMode.local;
  return ref.watch(repositoryProvider).getProgramSnapshot(
        DateTime.now(),
        localOnly: localOnly,
      );
});

final historySnapshotProvider = FutureProvider<HistorySnapshot>((ref) {
  final localOnly = ref.watch(appModeProvider) == AppMode.local;
  return ref.watch(repositoryProvider).getHistorySnapshot(
        DateTime.now(),
        localOnly: localOnly,
      );
});

final exerciseByIdProvider =
    FutureProvider.family<Exercise?, String>((ref, id) {
  return ref.watch(repositoryProvider).getExercise(id);
});

class ExerciseFilter {
  const ExerciseFilter({
    this.query = '',
    this.category,
    this.workoutType,
    this.homeCapable = false,
    this.tags = const [],
  });

  final String query;
  final ExerciseCategory? category;
  final WorkoutType? workoutType;
  final bool homeCapable;
  final List<String> tags;

  ExerciseFilter copyWith({
    String? query,
    ExerciseCategory? category,
    WorkoutType? workoutType,
    bool? homeCapable,
    List<String>? tags,
    bool clearCategory = false,
    bool clearWorkoutType = false,
  }) {
    return ExerciseFilter(
      query: query ?? this.query,
      category: clearCategory ? null : (category ?? this.category),
      workoutType:
          clearWorkoutType ? null : (workoutType ?? this.workoutType),
      homeCapable: homeCapable ?? this.homeCapable,
      tags: tags ?? this.tags,
    );
  }
}

class ExerciseFilterController extends Notifier<ExerciseFilter> {
  @override
  ExerciseFilter build() => const ExerciseFilter();

  void setQuery(String query) => state = state.copyWith(query: query);

  void setCategory(ExerciseCategory? category) {
    if (category == null) {
      state = state.copyWith(clearCategory: true);
    } else {
      state = state.copyWith(category: category);
    }
  }

  void setWorkoutType(WorkoutType? workoutType) {
    if (workoutType == null) {
      state = state.copyWith(clearWorkoutType: true);
    } else {
      state = state.copyWith(workoutType: workoutType);
    }
  }

  void setHomeCapable(bool homeCapable) {
    state = state.copyWith(homeCapable: homeCapable);
  }

  void toggleTag(String tag) {
    final next = [...state.tags];
    if (next.contains(tag)) {
      next.remove(tag);
    } else {
      next.add(tag);
    }
    state = state.copyWith(tags: next);
  }
}

final exerciseFilterProvider =
    NotifierProvider<ExerciseFilterController, ExerciseFilter>(
  ExerciseFilterController.new,
);

final filteredExercisesProvider = FutureProvider<List<Exercise>>((ref) {
  final filter = ref.watch(exerciseFilterProvider);
  return ref.watch(repositoryProvider).getExercises(
        category: filter.category,
        workoutType: filter.workoutType,
        homeCapable: filter.homeCapable,
        query: filter.query,
        tags: filter.tags,
      );
});
