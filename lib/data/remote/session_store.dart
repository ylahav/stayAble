import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'catalog_check.dart';
import 'local_accounts.dart';
import 'payload_config.dart';

const _tokenKey = 'payload_jwt';
const _urlKey = 'payload_base_url';
const _modeKey = 'stayable_app_mode';
const _localLoginKey = 'stayable_local_login';
const _currentUserKey = 'stayable_current_user_id';
const _localAccountsKey = 'stayable_local_accounts';
const _catalogCheckAtKey = 'stayable_catalog_check_at';
const _catalogSignatureKey = 'stayable_catalog_signature';
const _catalogPendingNewKey = 'stayable_catalog_pending_new';
const _catalogPendingChangedKey = 'stayable_catalog_pending_changed';

enum AppMode { cloud, local }

final sessionStoreProvider = Provider<SessionStore>((ref) => SessionStore());

class AppModeController extends Notifier<AppMode?> {
  @override
  AppMode? build() => null;

  void setMode(AppMode? mode) => state = mode;
}

final appModeProvider =
    NotifierProvider<AppModeController, AppMode?>(AppModeController.new);

class LocalLoginController extends Notifier<bool?> {
  @override
  bool? build() => null;

  void setChoice(bool? value) => state = value;
}

final localLoginProvider =
    NotifierProvider<LocalLoginController, bool?>(LocalLoginController.new);

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

  Future<bool> hasSavedBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_urlKey);
    return stored != null && stored.trim().isNotEmpty;
  }

  Future<AppMode?> readMode() async {
    final prefs = await SharedPreferences.getInstance();
    return switch (prefs.getString(_modeKey)) {
      'local' => AppMode.local,
      'cloud' => AppMode.cloud,
      _ => null,
    };
  }

  Future<void> saveMode(AppMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_modeKey, mode.name);
  }

  Future<void> clearMode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_modeKey);
  }

  Future<bool?> readLocalLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_localLoginKey)) return null;
    return prefs.getBool(_localLoginKey);
  }

  Future<void> saveLocalLogin(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_localLoginKey, enabled);
  }

  Future<String?> readCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_currentUserKey);
    if (stored == null || stored.isEmpty) return null;
    return stored;
  }

  Future<Map<String, LocalAccountRecord>> readLocalAccounts() async {
    final raw = await _secure.read(key: _localAccountsKey);
    return parseLocalAccounts(raw);
  }

  Future<bool> hasLocalAccounts() async {
    final accounts = await readLocalAccounts();
    return accounts.isNotEmpty;
  }

  Future<LocalAccountRecord?> findLocalAccount(String email) async {
    final accounts = await readLocalAccounts();
    return accounts[normalizeLocalEmail(email)];
  }

  Future<void> saveLocalAccount(LocalAccountRecord account) async {
    final accounts = await readLocalAccounts();
    accounts[normalizeLocalEmail(account.email)] = account;
    await _secure.write(
      key: _localAccountsKey,
      value: encodeLocalAccounts(accounts),
    );
  }

  Future<void> saveCurrentUserId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserKey, id);
  }

  Future<void> clearTokenOnly() async {
    await _secure.delete(key: _tokenKey);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  Future<void> clear() async {
    await clearTokenOnly();
  }

  Future<void> clearSetup() async {
    await clearTokenOnly();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_modeKey);
    await prefs.remove(_localLoginKey);
    await prefs.remove(_currentUserKey);
    await clearCatalogCheck();
  }

  Future<DateTime?> readCatalogLastCheck() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_catalogCheckAtKey);
    if (raw == null || raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }

  Future<void> saveCatalogLastCheck(DateTime at) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_catalogCheckAtKey, at.toUtc().toIso8601String());
  }

  Future<String?> readCatalogSignature() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_catalogSignatureKey);
    if (stored == null || stored.isEmpty) return null;
    return stored;
  }

  Future<void> saveCatalogSignature(String signature) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_catalogSignatureKey, signature);
  }

  Future<CatalogUpdate> readCatalogPending() async {
    final prefs = await SharedPreferences.getInstance();
    return CatalogUpdate(
      newCount: prefs.getInt(_catalogPendingNewKey) ?? 0,
      hasUpdates: prefs.getBool(_catalogPendingChangedKey) ?? false,
    );
  }

  Future<void> saveCatalogPending(CatalogUpdate pending) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_catalogPendingNewKey, pending.newCount);
    await prefs.setBool(_catalogPendingChangedKey, pending.hasUpdates);
  }

  Future<void> clearCatalogCheck() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_catalogCheckAtKey);
    await prefs.remove(_catalogSignatureKey);
    await prefs.remove(_catalogPendingNewKey);
    await prefs.remove(_catalogPendingChangedKey);
  }
}
