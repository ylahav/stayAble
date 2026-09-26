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
