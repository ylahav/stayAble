import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';

class GymClock extends StatelessWidget {
  const GymClock(
    this.text, {
    super.key,
    this.size = 72,
    this.color = AppColors.graphite,
  });

  final String text;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.rubik(
        fontSize: size,
        fontWeight: FontWeight.w700,
        height: 1,
        letterSpacing: -1.5,
        color: color,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
  }
}
