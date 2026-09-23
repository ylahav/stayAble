class ProgramExercise {
  const ProgramExercise({
    required this.id,
    required this.programDayId,
    required this.exerciseId,
    required this.order,
    required this.sets,
    this.repetitions,
    this.duration,
    this.loadKg,
    required this.rest,
    this.notes,
  });

  final String id;
  final String programDayId;
  final String exerciseId;
  final int order;
  final int sets;
  final int? repetitions;
  final int? duration;
  final double? loadKg;
  final int rest;
  final String? notes;

  bool get isTimed => duration != null && duration! > 0;
}
