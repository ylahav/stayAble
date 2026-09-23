import 'enums.dart';

class TrainingProgram {
  const TrainingProgram({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    this.startDate,
    this.endDate,
    required this.scheduleType,
    this.venue = ProgramVenue.home,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String userId;
  final String name;
  final String description;
  final DateTime? startDate;
  final DateTime? endDate;
  final ScheduleType scheduleType;
  final ProgramVenue venue;
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;
}
