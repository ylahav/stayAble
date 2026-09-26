import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:plinth_blocks/plinth_blocks.dart';

import '../../l10n/app_localizations.dart';
import '../auth/auth_controller.dart';
import '../providers.dart';

const minAgeYears = 12;
const maxAgeYears = 90;

Future<DateTime?> ensureUserBirthDate({
  required BuildContext context,
  required WidgetRef ref,
}) async {
  final user = await ref.read(repositoryProvider).getCurrentUser();
  if (user.birthDate != null) return user.birthDate;
  if (!context.mounted) return null;
  return editUserBirthDate(context: context, ref: ref);
}

Future<DateTime?> editUserBirthDate({
  required BuildContext context,
  required WidgetRef ref,
  DateTime? initial,
}) async {
  final l10n = AppLocalizations.of(context);
  final locale = Localizations.localeOf(context);
  final now = DateTime.now();
  final first = DateTime(now.year - maxAgeYears, now.month, now.day);
  final last = DateTime(now.year - minAgeYears, now.month, now.day);
  var selected = initial ??
      (await ref.read(repositoryProvider).getCurrentUser()).birthDate ??
      DateTime(now.year - 40, now.month, now.day);
  if (selected.isBefore(first)) selected = first;
  if (selected.isAfter(last)) selected = last;

  if (!context.mounted) return null;
  final controller = PlinthDisclosureController();
  var confirmed = false;
  await PlinthModal(
    controller: controller,
    title: l10n.birthday,
    size: PlinthSize.sm,
    child: StatefulBuilder(
      builder: (modalContext, setModal) {
        return PlinthStack(
          children: [
            PlinthText(l10n.birthdayLead),
            PlinthButton(
              fullWidth: true,
              variant: PlinthVariant.outline,
              onPressed: () async {
                final picked = await showDatePicker(
                  context: modalContext,
                  initialDate: selected,
                  firstDate: first,
                  lastDate: last,
                );
                if (picked == null) return;
                setModal(() => selected = picked);
              },
              child: Text(
                DateFormat.yMMMd(locale.toLanguageTag()).format(selected),
              ),
            ),
            PlinthGroup(
              children: [
                PlinthButton(
                  variant: PlinthVariant.subtle,
                  onPressed: () => Navigator.of(modalContext).pop(),
                  child: Text(l10n.cancel),
                ),
                PlinthButton(
                  onPressed: () {
                    confirmed = true;
                    Navigator.of(modalContext).pop();
                  },
                  child: Text(l10n.birthdaySave),
                ),
              ],
            ),
          ],
        );
      },
    ),
  ).show(context);
  controller.dispose();
  if (!confirmed) return null;
  await ref.read(authProvider.notifier).saveBirthDate(selected);
  return selected;
}

Future<bool> startProgramDay({
  required BuildContext context,
  required WidgetRef ref,
  required String dayId,
  String? resumeSessionId,
}) async {
  final birth = await ensureUserBirthDate(context: context, ref: ref);
  if (birth == null || !context.mounted) return false;
  final repo = ref.read(repositoryProvider);
  final session = resumeSessionId != null
      ? await repo.resumeSession(resumeSessionId)
      : await repo.startOrResumeSession(dayId);
  if (!context.mounted) return false;
  ref.invalidate(homeSnapshotProvider);
  ref.invalidate(programSnapshotProvider);
  ref.invalidate(historySnapshotProvider);
  await context.push('/workout/${session.id}');
  return true;
}
