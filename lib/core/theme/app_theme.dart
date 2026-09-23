import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plinth_blocks/plinth_blocks.dart';

import 'app_colors.dart';

class AppTheme {
  static PlinthTheme plinthLight() {
    final base = PlinthTheme.defaultTheme;
    return base.copyWith(
      primaryColor: 'green',
      density: PlinthDensity.touch,
      defaultRadius: PlinthSize.lg,
      colors: {
        ...base.colors,
        'green': PlinthTheme.generateShades(AppColors.matGreen),
        'yellow': PlinthTheme.generateShades(AppColors.restAmber),
      },
      semanticColors: const {
        'brand': PlinthSemanticColor('green'),
        'rest': PlinthSemanticColor('yellow'),
      },
      roleRamps: {
        ...kDefaultRoleRamps,
        PlinthRole.success: 'green',
      },
      surface: AppColors.card,
      surfaceMuted: AppColors.wall,
      surfaceSunken: const Color(0xFFE4E7E2),
      text: AppColors.graphite,
      textMuted: AppColors.mute,
      onFilled: AppColors.onGreen,
    );
  }

  static ThemeData light() {
    final plinth = plinthLight();
    final rubik = GoogleFonts.rubikTextTheme();
    final textTheme = plinth.toTextTheme(base: rubik).apply(
      bodyColor: AppColors.graphite,
      displayColor: AppColors.graphite,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: plinth.toColorScheme(),
      textTheme: textTheme,
      extensions: [plinth],
      scaffoldBackgroundColor: AppColors.wall,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.wall,
        foregroundColor: AppColors.graphite,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.rubik(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.graphite,
        ),
      ),
    );
  }
}
