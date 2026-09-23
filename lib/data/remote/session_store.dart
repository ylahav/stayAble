import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'payload_config.dart';

const _tokenKey = 'payload_jwt';
const _urlKey = 'payload_base_url';

class SessionStore {
  static const _secure = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  Future<String?> readToken() async {
    final stored = await _secure.read(key: _tokenKey);
    if (stored != null && stored.isNotEmpty) return stored;

    final prefs = await SharedPreferences.getInstance();
    final legacy = prefs.getString(_tokenKey);
    if (legacy == null || legacy.isEmpty) return null;
    await _secure.write(key: _tokenKey, value: legacy);
    await prefs.remove(_tokenKey);
    return legacy;
  }

  Future<void> saveToken(String token) async {
    await _secure.write(key: _tokenKey, value: token);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  Future<String> readBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_urlKey);
    if (stored == null || stored.trim().isEmpty) return resolvePayloadUrl();
    try {
      return normalizePayloadUrl(stored);
    } catch (_) {
      return resolvePayloadUrl();
    }
  }

  Future<void> saveBaseUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_urlKey, normalizePayloadUrl(url));
  }

  Future<void> clear() async {
    await _secure.delete(key: _tokenKey);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
