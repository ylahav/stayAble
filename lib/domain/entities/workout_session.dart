import 'enums.dart';

class WorkoutSession {
  const WorkoutSession({
    required this.id,
    required this.userId,
    required this.programDayId,
    required this.startedAt,
    this.completedAt,
    this.duration,
    required this.status,
    this.notes,
    this.totalVolumeKg,
  });

  final String id;
  final String userId;
  final String programDayId;
  final DateTime startedAt;
  final DateTime? completedAt;
  final int? duration;
  final WorkoutStatus status;
  final String? notes;
  final double? totalVolumeKg;

  WorkoutSession copyWith({
    DateTime? completedAt,
    int? duration,
    WorkoutStatus? status,
    String? notes,
    double? totalVolumeKg,
  }) {
    return WorkoutSession(
      id: id,
      userId: userId,
      programDayId: programDayId,
      startedAt: startedAt,
      completedAt: completedAt ?? this.completedAt,
      duration: duration ?? this.duration,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      totalVolumeKg: totalVolumeKg ?? this.totalVolumeKg,
    );
  }
}
