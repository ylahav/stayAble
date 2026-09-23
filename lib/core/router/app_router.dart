import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/auth/auth_controller.dart';
import '../../presentation/auth/boot_screen.dart';
import '../../presentation/auth/login_screen.dart';
import '../../presentation/exercises/exercise_details_screen.dart';
import '../../presentation/exercises/exercises_screen.dart';
import '../../presentation/history/history_screen.dart';
import '../../presentation/home/home_screen.dart';
import '../../presentation/program/program_screen.dart';
import '../../presentation/settings/settings_screen.dart';
import '../../presentation/shell/app_shell.dart';
import '../../presentation/workout/workout_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<int>(0);
  ref.listen(authProvider, (_, _) => refresh.value++);
  ref.onDispose(refresh.dispose);
  return createRouter(ref, refresh);
});

GoRouter createRouter(Ref ref, Listenable refresh) {
  return GoRouter(
    initialLocation: '/boot',
    refreshListenable: refresh,
    redirect: (context, state) {
      final auth = ref.read(authProvider);
      final loc = state.matchedLocation;
      final onBoot = loc == '/boot';
      final onLogin = loc == '/login';

      if (auth.isLoading) {
        return onBoot ? null : '/boot';
      }

      final loggedIn = auth.value != null;
      if (!loggedIn) {
        return onLogin ? null : '/login';
      }
      if (onLogin || onBoot) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/boot',
        builder: (context, state) => const BootScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/exercises',
                builder: (context, state) => const ExercisesScreen(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) => ExerciseDetailsScreen(
                      exerciseId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/program',
                builder: (context, state) => const ProgramScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/history',
                builder: (context, state) => const HistoryScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/workout/:sessionId',
        builder: (context, state) => WorkoutScreen(
          sessionId: state.pathParameters['sessionId']!,
        ),
      ),
    ],
  );
}
