import 'package:flutter/material.dart';
import 'package:plinth_blocks/plinth_blocks.dart';

import '../app_version.dart';

class AppVersionLabel extends StatelessWidget {
  const AppVersionLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        PlinthSpacing.md,
        PlinthSpacing.xs,
        PlinthSpacing.md,
        PlinthSpacing.sm,
      ),
      child: FutureBuilder<String>(
        future: loadAppVersionLabel(),
        builder: (context, snapshot) {
          final text = snapshot.data;
          if (text == null || text.isEmpty) {
            return const SizedBox.shrink();
          }
          return PlinthText(
            text,
            size: PlinthSize.xs,
            color: 'gray',
            textAlign: TextAlign.center,
          );
        },
      ),
    );
  }
}
