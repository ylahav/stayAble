import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:plinth_blocks/plinth_blocks.dart';

import '../../data/remote/rich_text.dart';
import '../theme/app_colors.dart';

class StayAbleInstructions extends StatelessWidget {
  const StayAbleInstructions({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final raw = text.trim();
    if (raw.isEmpty) return const SizedBox.shrink();
    if (looksLikeHtml(raw)) {
      return HtmlWidget(
        raw,
        textStyle: const TextStyle(
          color: AppColors.graphite,
          fontSize: 16,
          height: 1.4,
        ),
      );
    }
    final steps = raw
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
    return PlinthList(
      type: PlinthListType.ordered,
      items: [
        for (final step in steps) PlinthListItem(Text(step)),
      ],
    );
  }
}
