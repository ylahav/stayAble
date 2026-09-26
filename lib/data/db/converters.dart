import 'dart:convert';

import 'package:drift/drift.dart';

import '../../domain/entities/enums.dart';
import '../../domain/entities/localized_text.dart';
import '../../domain/entities/trainee_assessment.dart';

class LocalizedTextConverter extends TypeConverter<LocalizedText, String> {
  const LocalizedTextConverter();

  @override
  LocalizedText fromSql(String fromDb) {
    final map = json.decode(fromDb) as Map<String, dynamic>;
    return LocalizedText(
      en: map['en'] as String? ?? '',
      he: map['he'] as String? ?? '',
    );
  }

  @override
  String toSql(LocalizedText value) =>
      json.encode({'en': value.en, 'he': value.he});
}

class StringListConverter extends TypeConverter<List<String>, String> {
  const StringListConverter();

  @override
  List<String> fromSql(String fromDb) {
    final decoded = json.decode(fromDb);
    if (decoded is List) {
      return decoded.map((e) => e.toString()).toList();
    }
    return const [];
  }

  @override
  String toSql(List<String> value) => json.encode(value);
}

class GoalListConverter extends TypeConverter<List<FitnessGoal>, String> {
  const GoalListConverter();

  @override
  List<FitnessGoal> fromSql(String fromDb) {
    final decoded = json.decode(fromDb);
    if (decoded is! List) return const [];
    return decoded
        .map((e) => FitnessGoal.values.byName(e.toString()))
        .toList();
  }

  @override
  String toSql(List<FitnessGoal> value) =>
      json.encode(value.map((e) => e.name).toList());
}

class AssessmentConverter extends TypeConverter<TraineeAssessment?, String?> {
  const AssessmentConverter();

  @override
  TraineeAssessment? fromSql(String? fromDb) {
    if (fromDb == null || fromDb.isEmpty) return null;
    final decoded = json.decode(fromDb);
    if (decoded is! Map) return null;
    return TraineeAssessment.fromJson(Map<String, dynamic>.from(decoded));
  }

  @override
  String? toSql(TraineeAssessment? value) {
    if (value == null) return null;
    return json.encode(value.toJson());
  }
}
