import '../../domain/entities/exercise.dart';

const catalogCheckInterval = Duration(days: 7);

class PublicCatalogStatus {
  const PublicCatalogStatus({required this.ids, this.updatedAt});

  final List<String> ids;
  final DateTime? updatedAt;

  int get count => ids.length;

  String get signature {
    final sorted = [...ids]..sort();
    return '${sorted.join(',')}|${updatedAt?.toUtc().toIso8601String() ?? ''}';
  }

  factory PublicCatalogStatus.fromJson(Map<String, dynamic> json) {
    final ids = <String>[];
    final raw = json['ids'];
    if (raw is List) {
      for (final id in raw) {
        if (id is String && id.isNotEmpty) ids.add(id);
      }
    }
    DateTime? updatedAt;
    final stamp = json['updatedAt'];
    if (stamp is String) updatedAt = DateTime.tryParse(stamp);
    return PublicCatalogStatus(ids: ids, updatedAt: updatedAt);
  }

  factory PublicCatalogStatus.fromExercises(List<Exercise> exercises) {
    DateTime? latest;
    final ids = <String>[];
    for (final exercise in exercises) {
      ids.add(exercise.id);
      if (latest == null || exercise.updatedAt.isAfter(latest)) {
        latest = exercise.updatedAt;
      }
    }
    return PublicCatalogStatus(ids: ids, updatedAt: latest);
  }
}

class CatalogUpdate {
  const CatalogUpdate({this.newCount = 0, this.hasUpdates = false});

  final int newCount;
  final bool hasUpdates;

  bool get available => newCount > 0 || hasUpdates;

  factory CatalogUpdate.compare({
    required Set<String> localIds,
    required PublicCatalogStatus remote,
    String? lastSignature,
  }) {
    final newCount = countNewExercises(localIds, remote.ids);
    return CatalogUpdate(
      newCount: newCount,
      hasUpdates:
          newCount == 0 &&
          lastSignature != null &&
          remote.signature != lastSignature,
    );
  }
}

int countNewExercises(Set<String> localIds, Iterable<String> remoteIds) {
  var count = 0;
  for (final id in remoteIds) {
    if (!localIds.contains(id)) count++;
  }
  return count;
}

bool catalogCheckDue({
  required DateTime now,
  DateTime? lastCheck,
  Duration interval = catalogCheckInterval,
}) {
  if (lastCheck == null) return true;
  return !now.isBefore(lastCheck.add(interval));
}
