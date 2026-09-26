import 'package:flutter/material.dart';
import 'package:plinth_blocks/plinth_blocks.dart';

class StayAbleLoading extends StatelessWidget {
  const StayAbleLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: PlinthLoader());
  }
}

class StayAbleError extends StatelessWidget {
  const StayAbleError({super.key, required this.message});

  final Object message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(PlinthSpacing.md),
        child: PlinthAlert(
          color: 'red',
          icon: const Icon(Icons.error_outline),
          child: Text('$message'),
        ),
      ),
    );
  }
}

class StayAblePage extends StatelessWidget {
  const StayAblePage({
    super.key,
    required this.title,
    required this.body,
    this.subtitle,
    this.leading,
    this.actions = const [],
    this.below,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget> actions;
  final Widget? below;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return PlinthPage(
      title: title,
      subtitle: subtitle,
      leading: leading,
      actions: actions,
      below: below,
      body: body,
      padding: const EdgeInsets.fromLTRB(
        PlinthSpacing.md,
        PlinthSpacing.sm,
        PlinthSpacing.md,
        0,
      ),
    );
  }
}
