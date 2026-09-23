import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/stayable_async.dart';

class BootScreen extends StatelessWidget {
  const BootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          ColoredBox(
            color: AppColors.matGreen,
            child: SizedBox(height: 8, width: double.infinity),
          ),
          Expanded(child: StayAbleLoading()),
        ],
      ),
    );
  }
}
