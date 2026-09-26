import 'package:flutter/material.dart';
import 'package:plinth_blocks/plinth_blocks.dart';

import 'stayable_scroll_body.dart';

class StayAbleEmpty extends StatelessWidget {
  const StayAbleEmpty({
    super.key,
    required this.title,
    this.lead,
    this.icon,
    this.action,
    this.scroll = true,
  });

  final String title;
  final String? lead;
  final Widget? icon;
  final Widget? action;
  final bool scroll;

  @override
  Widget build(BuildContext context) {
    final content = <Widget>[
      PlinthEmptyState(
        icon: icon,
        title: title,
      ),
      if (lead != null) ...[
        const PlinthSpace(h: PlinthSize.sm),
        PlinthText(lead!, color: 'gray'),
      ],
      if (action != null) ...[
        const PlinthSpace(h: PlinthSize.md),
        action!,
      ],
    ];
    if (!scroll) {
      return PlinthStack(children: content);
    }
    return StayAbleScrollBody(children: content);
  }
}
