import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plinth_blocks/plinth_blocks.dart';

import '../../presentation/providers.dart';

class LanguageToggle extends ConsumerWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    return PlinthButton(
      variant: PlinthVariant.subtle,
      size: PlinthSize.sm,
      onPressed: () => ref.read(localeProvider.notifier).toggle(),
      child: Text(locale.languageCode == 'he' ? 'EN' : 'עב'),
    );
  }
}
