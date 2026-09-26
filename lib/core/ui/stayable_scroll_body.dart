import 'package:flutter/material.dart';
import 'package:plinth_blocks/plinth_blocks.dart';

class StayAbleScrollBody extends StatelessWidget {
  const StayAbleScrollBody({
    super.key,
    required this.children,
  });

  final List<Widget> children;

  static const padding = EdgeInsets.fromLTRB(
    0,
    PlinthSpacing.sm,
    0,
    PlinthSpacing.xl,
  );

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: padding,
      children: children,
    );
  }
}
