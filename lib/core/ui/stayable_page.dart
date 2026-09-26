import 'package:flutter/material.dart';
import 'package:plinth_blocks/plinth_blocks.dart';

import 'stayable_scroll_body.dart';

class StayAblePage extends StatelessWidget {
  const StayAblePage({
    super.key,
    required this.title,
    required this.body,
    this.subtitle,
    this.leading,
    this.actions = const [],
    this.below,
    this.scroll = false,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget> actions;
  final Widget? below;
  final Widget body;
  final bool scroll;

  @override
  Widget build(BuildContext context) {
    return PlinthPage(
      title: title,
      subtitle: subtitle,
      leading: leading,
      actions: actions,
      below: below,
      body: scroll
          ? ListView(
              padding: StayAbleScrollBody.padding,
              children: [body],
            )
          : body,
      padding: const EdgeInsets.fromLTRB(
        PlinthSpacing.lg,
        PlinthSpacing.sm,
        PlinthSpacing.lg,
        0,
      ),
    );
  }
}
