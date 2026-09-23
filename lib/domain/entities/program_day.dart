import 'localized_text.dart';

class ProgramDay {
  const ProgramDay({
    required this.id,
    required this.programId,
    this.date,
    this.weekday,
    required this.title,
    required this.description,
  });

  final String id;
  final String programId;
  final DateTime? date;
  final int? weekday;
  final LocalizedText title;
  final LocalizedText description;
}
