import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/enums.dart';
import '../../presentation/auth/auth_controller.dart';
import 'exercise_illustration.dart';

class ExercisePhoto extends ConsumerWidget {
  const ExercisePhoto({
    super.key,
    required this.photo,
    required this.category,
    this.height = 180,
  });

  final String photo;
  final ExerciseCategory category;
  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fallback = ExerciseIllustration(
      photo: photo,
      category: category,
      height: height,
    );

    Widget frame(Widget child) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: ColoredBox(
          color: const Color(0xFFE4E8E3),
          child: SizedBox(
            height: height,
            width: double.infinity,
            child: child,
          ),
        ),
      );
    }

    if (photo.startsWith('http://') || photo.startsWith('https://')) {
      final token = ref.watch(authProvider).value?.token;
      return frame(
        Image.network(
          photo,
          height: height,
          fit: BoxFit.fitHeight,
          alignment: Alignment.center,
          headers: token == null
              ? const {}
              : {'Authorization': 'JWT $token'},
          errorBuilder: (context, error, stackTrace) => fallback,
        ),
      );
    }

    if (photo.startsWith('assets/')) {
      return frame(
        Image.asset(
          photo,
          height: height,
          fit: BoxFit.fitHeight,
          alignment: Alignment.center,
          errorBuilder: (context, error, stackTrace) => fallback,
        ),
      );
    }

    return fallback;
  }
}
