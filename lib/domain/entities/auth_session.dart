class RemoteUser {
  const RemoteUser({
    required this.id,
    required this.email,
    required this.name,
    required this.roles,
    required this.language,
    required this.active,
  });

  final String id;
  final String email;
  final String name;
  final List<String> roles;
  final String language;
  final bool active;

  bool get isAthlete => roles.contains('athlete');

  factory RemoteUser.fromJson(Map<String, dynamic> json) {
    final roles = json['roles'];
    return RemoteUser(
      id: json['id'] as String,
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
      roles: roles is List
          ? roles.map((role) => role.toString()).toList()
          : const [],
      language: json['language'] as String? ?? 'en',
      active: json['active'] as bool? ?? true,
    );
  }
}

class AuthSession {
  const AuthSession({required this.token, required this.user});

  final String token;
  final RemoteUser user;
}

enum AuthFailure {
  invalidCredentials,
  notAthlete,
  inactive,
  network,
  invalidServer,
  unknown,
}

class AuthException implements Exception {
  const AuthException(this.failure, [this.detail]);

  final AuthFailure failure;
  final String? detail;
}
