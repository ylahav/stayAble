import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app.dart';
import 'data/db/app_database.dart';
import 'data/seed/seed_data.dart';
import 'presentation/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('en');
  await initializeDateFormatting('he');
  final deviceLang =
      WidgetsBinding.instance.platformDispatcher.locale.languageCode;
  final database = AppDatabase();
  await SeedRunner(database).runIfNeeded(
    language: deviceLang == 'he' ? 'he' : 'en',
  );

  final container = ProviderContainer(
    overrides: [
      databaseProvider.overrideWithValue(database),
    ],
  );
  await container.read(localeProvider.notifier).syncFromUser();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const StayAbleApp(),
    ),
  );
}
