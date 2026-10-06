import 'enums.dart';
import 'trainee_assessment.dart';

class RemoteUser {
  const RemoteUser({
    required this.id,
    required this.email,
    required this.name,
    required this.roles,
    required this.language,
    required this.active,
    this.birthDate,
    this.assessment,
    this.fitnessLevel,
    this.goals = const [],
    this.trainingVenue,
  });

  final String id;
  final String email;
  final String name;
  final List<String> roles;
  final String language;
  final bool active;
  final DateTime? birthDate;
  final TraineeAssessment? assessment;
  final FitnessLevel? fitnessLevel;
  final List<FitnessGoal> goals;
  final ExerciseVenue? trainingVenue;

  bool get isTrainee =>
      roles.contains('trainee') || roles.contains('athlete');

  bool get isAthlete => isTrainee;

  factory RemoteUser.fromJson(Map<String, dynamic> json) {
    final roles = json['roles'];
    final birth = json['birthDate'];
    DateTime? birthDate;
    if (birth is String && birth.isNotEmpty) {
      final parsed = DateTime.tryParse(birth);
      if (parsed != null) {
        birthDate = DateTime(parsed.year, parsed.month, parsed.day);
      }
    }
    final rawAssessment = json['assessment'];
    return RemoteUser(
      id: json['id'] as String,
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
      roles: roles is List
          ? roles.map((role) => role.toString()).toList()
          : const [],
      language: json['language'] as String? ?? 'en',
      active: json['active'] as bool? ?? true,
      birthDate: birthDate,
      assessment: rawAssessment is Map
          ? TraineeAssessment.fromJson(Map<String, dynamic>.from(rawAssessment))
          : null,
      fitnessLevel: _enum(FitnessLevel.values, json['fitnessLevel']) ??
          _enum(FitnessLevel.values, json['level']),
      goals: _enums(FitnessGoal.values, json['goals']),
      trainingVenue: _enum(ExerciseVenue.values, json['trainingVenue']),
    );
  }

  static T? _enum<T extends Enum>(List<T> values, Object? raw) {
    if (raw is! String) return null;
    return values.where((value) => value.name == raw).firstOrNull;
  }

  static List<T> _enums<T extends Enum>(List<T> values, Object? raw) {
    if (raw is! List) return const [];
    return [
      for (final item in raw)
        if (item is String) ...values.where((value) => value.name == item),
    ];
  }
}

class AuthSession {
  const AuthSession({
    required this.token,
    required this.user,
    this.localMode = false,
  });

  final String token;
  final RemoteUser user;
  final bool localMode;

  bool get isLocal => localMode || token.isEmpty;

  factory AuthSession.local({required String language}) {
    return AuthSession(
      token: '',
      localMode: true,
      user: RemoteUser(
        id: 'local',
        email: 'trainee@local',
        name: 'You',
        roles: const ['trainee'],
        language: language,
        active: true,
      ),
    );
  }
}

enum AuthFailure {
  invalidCredentials,
  notAthlete,
  inactive,
  network,
  invalidServer,
  emailTaken,
  unknown,
}

class AuthException implements Exception {
  const AuthException(this.failure, [this.detail]);

  final AuthFailure failure;
  final String? detail;

  @override
  String toString() {
    if (detail == null || detail!.isEmpty) {
      return 'AuthException.${failure.name}';
    }
    return 'AuthException.${failure.name}: $detail';
  }
}
