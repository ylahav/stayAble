import 'dart:convert';

import 'package:crypto/crypto.dart';

const localSessionTokenPrefix = 'local:';

bool isLocalSessionToken(String token) =>
    token.startsWith(localSessionTokenPrefix);

String localSessionToken(String userId) => '$localSessionTokenPrefix$userId';

String? localUserIdFromToken(String token) {
  if (!isLocalSessionToken(token)) return null;
  final id = token.substring(localSessionTokenPrefix.length);
  return id.isEmpty ? null : id;
}

class LocalAccountRecord {
  const LocalAccountRecord({
    required this.id,
    required this.name,
    required this.email,
    required this.salt,
    required this.hash,
  });

  final String id;
  final String name;
  final String email;
  final String salt;
  final String hash;

  bool matches(String password) => hashLocalPassword(password, salt) == hash;

  Map<String, String> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'salt': salt,
        'hash': hash,
      };

  factory LocalAccountRecord.fromJson(Map<String, dynamic> json) {
    return LocalAccountRecord(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      salt: json['salt'] as String? ?? '',
      hash: json['hash'] as String? ?? '',
    );
  }
}

String normalizeLocalEmail(String email) => email.trim().toLowerCase();

String hashLocalPassword(String password, String salt) {
  return sha256.convert(utf8.encode('$salt:$password')).toString();
}

Map<String, LocalAccountRecord> parseLocalAccounts(String? raw) {
  if (raw == null || raw.isEmpty) return {};
  try {
    final decoded = jsonDecode(raw);
    if (decoded is! Map) return {};
    final accounts = <String, LocalAccountRecord>{};
    decoded.forEach((key, value) {
      if (value is! Map) return;
      final record = LocalAccountRecord.fromJson(
        Map<String, dynamic>.from(value),
      );
      if (record.id.isEmpty || record.email.isEmpty) return;
      accounts[normalizeLocalEmail(record.email)] = record;
    });
    return accounts;
  } catch (_) {
    return {};
  }
}

String encodeLocalAccounts(Map<String, LocalAccountRecord> accounts) {
  return jsonEncode({
    for (final entry in accounts.entries) entry.key: entry.value.toJson(),
  });
}
