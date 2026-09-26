import 'package:flutter/material.dart';
import 'package:plinth_blocks/plinth_blocks.dart';

class BootScreen extends StatelessWidget {
  const BootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlinthAuthScreen(
      accentColor: 'green',
      child: PlinthLoader(),
    );
  }
}
