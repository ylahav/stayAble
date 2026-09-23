import 'package:flutter/material.dart';
import 'package:plinth_blocks/plinth_blocks.dart';

import '../../l10n/app_localizations.dart';

class NoteComposer extends StatefulWidget {
  const NoteComposer({
    super.key,
    required this.onSave,
  });

  final Future<void> Function(String notes) onSave;

  @override
  State<NoteComposer> createState() => _NoteComposerState();
}

class _NoteComposerState extends State<NoteComposer> {
  bool _adding = false;
  late final TextEditingController _note;

  @override
  void initState() {
    super.initState();
    _note = TextEditingController();
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (!_adding) {
      return PlinthButton(
        variant: PlinthVariant.outline,
        onPressed: () => setState(() => _adding = true),
        child: Text(l10n.addNote),
      );
    }

    return PlinthStack(
      children: [
        PlinthTextarea(
          controller: _note,
          placeholder: l10n.exerciseNoteHint,
          minLines: 2,
          maxLines: 4,
        ),
        PlinthAsyncButton(
          fullWidth: true,
          onPressed: () => widget.onSave(_note.text),
          child: Text(l10n.completed),
        ),
      ],
    );
  }
}
