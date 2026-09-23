import 'package:flutter/material.dart';

import '../../domain/entities/enums.dart';
import '../theme/app_colors.dart';

class ExerciseIllustration extends StatelessWidget {
  const ExerciseIllustration({
    super.key,
    required this.photo,
    required this.category,
    this.height = 180,
  });

  final String photo;
  final ExerciseCategory category;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: CustomPaint(
          painter: _ExercisePainter(seed: photo, category: category),
        ),
      ),
    );
  }
}

class _ExercisePainter extends CustomPainter {
  _ExercisePainter({required this.seed, required this.category});

  final String seed;
  final ExerciseCategory category;

  Color get _base {
    switch (category) {
      case ExerciseCategory.warmUp:
        return const Color(0xFFD9C9A8);
      case ExerciseCategory.mobility:
        return const Color(0xFFB7C4B8);
      case ExerciseCategory.strength:
        return AppColors.matGreen.withValues(alpha: 0.55);
      case ExerciseCategory.cardio:
        return const Color(0xFF8FA898);
      case ExerciseCategory.stretching:
        return const Color(0xFFC5C1B5);
      case ExerciseCategory.coolDown:
        return const Color(0xFF9AA39C);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = _base.withValues(alpha: 0.35);
    canvas.drawRect(Offset.zero & size, bg);

    final hash = seed.hashCode;
    final accent = Paint()
      ..color = AppColors.graphite.withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    final cx = size.width * (0.35 + (hash % 20) / 100);
    final cy = size.height * 0.52;
    canvas.drawCircle(Offset(cx, cy), size.height * 0.22, accent);
    canvas.drawLine(
      Offset(cx, cy + size.height * 0.22),
      Offset(cx, size.height * 0.92),
      accent,
    );
    canvas.drawLine(
      Offset(cx, cy + size.height * 0.08),
      Offset(cx - size.width * 0.22, cy + size.height * 0.28),
      accent,
    );
    canvas.drawLine(
      Offset(cx, cy + size.height * 0.08),
      Offset(cx + size.width * 0.22, cy + size.height * 0.28),
      accent,
    );

    final fill = Paint()..color = AppColors.matGreen.withValues(alpha: 0.28);
    canvas.drawCircle(
      Offset(size.width * 0.78, size.height * 0.28),
      28,
      fill,
    );
  }

  @override
  bool shouldRepaint(covariant _ExercisePainter oldDelegate) {
    return oldDelegate.seed != seed || oldDelegate.category != category;
  }
}
