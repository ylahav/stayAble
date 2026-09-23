import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/db/app_database.dart' show AppDatabase;
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
  return ref.watch(repositoryProvider).getHomeSnapshot(DateTime.now());
});

final programSnapshotProvider = FutureProvider<ProgramSnapshot>((ref) {
  return ref.watch(repositoryProvider).getProgramSnapshot(DateTime.now());
});

final historySnapshotProvider = FutureProvider<HistorySnapshot>((ref) {
  return ref.watch(repositoryProvider).getHistorySnapshot(DateTime.now());
});

final exerciseByIdProvider =
    FutureProvider.family<Exercise?, String>((ref, id) {
  return ref.watch(repositoryProvider).getExercise(id);
});

class ExerciseFilter {
  const ExerciseFilter({this.query = '', this.category});

  final String query;
  final ExerciseCategory? category;

  ExerciseFilter copyWith({
    String? query,
    ExerciseCategory? category,
    bool clearCategory = false,
  }) {
    return ExerciseFilter(
      query: query ?? this.query,
      category: clearCategory ? null : (category ?? this.category),
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
}

final exerciseFilterProvider =
    NotifierProvider<ExerciseFilterController, ExerciseFilter>(
  ExerciseFilterController.new,
);

final filteredExercisesProvider = FutureProvider<List<Exercise>>((ref) {
  final filter = ref.watch(exerciseFilterProvider);
  return ref.watch(repositoryProvider).getExercises(
        category: filter.category,
        query: filter.query,
      );
});
