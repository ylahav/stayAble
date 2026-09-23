import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plinth_blocks/plinth_blocks.dart';

import '../../l10n/app_localizations.dart';
import '../../core/widgets/language_toggle.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final wide = MediaQuery.sizeOf(context).width >= 840;
    final destinations = [
      _Dest('home', l10n.navHome, Icons.home_outlined),
      _Dest('exercises', l10n.navExercises, Icons.fitness_center_outlined),
      _Dest('program', l10n.navProgram, Icons.calendar_view_week_outlined),
      _Dest('history', l10n.navHistory, Icons.history_outlined),
    ];
    final active = destinations[navigationShell.currentIndex].value;

    void go(String value) {
      final index = destinations.indexWhere((d) => d.value == value);
      if (index < 0) return;
      navigationShell.goBranch(
        index,
        initialLocation: index == navigationShell.currentIndex,
      );
    }

    final sidebar = PlinthSidebar(
      activeValue: active,
      onSelect: go,
      header: const Padding(
        padding: EdgeInsets.all(PlinthSpacing.md),
        child: LanguageToggle(),
      ),
      sections: [
        PlinthNavSection(
          items: [
            for (final dest in destinations)
              PlinthNavItem(
                value: dest.value,
                label: dest.label,
                icon: Icon(dest.icon),
                onTap: () => go(dest.value),
              ),
          ],
        ),
      ],
    );

    return Scaffold(
      body: PlinthAppShell(
        navbarCollapsed: !wide,
        footerHeight: 76,
        navbar: sidebar,
        footer: wide
            ? null
            : PlinthPaper(
                withBorder: true,
                p: PlinthSize.xs,
                child: Row(
                  children: [
                    for (final dest in destinations)
                      Expanded(
                        child: PlinthNavLink(
                          label: dest.label,
                          leadingIcon: Icon(dest.icon, size: 20),
                          active: dest.value == active,
                          onTap: () => go(dest.value),
                        ),
                      ),
                  ],
                ),
              ),
        child: navigationShell,
      ),
    );
  }
}

class _Dest {
  const _Dest(this.value, this.label, this.icon);
  final String value;
  final String label;
  final IconData icon;
}
