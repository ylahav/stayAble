import 'package:flutter/material.dart';
import 'package:plinth_blocks/plinth_blocks.dart';

class StayAbleChoiceCard extends StatelessWidget {
  const StayAbleChoiceCard({
    super.key,
    required this.title,
    required this.lead,
    required this.action,
  });

  final String title;
  final String lead;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    return PlinthCard(
      withBorder: true,
      header: PlinthTitle(title, order: 3),
      footer: action,
      child: PlinthText(lead, color: 'gray'),
    );
  }
}
