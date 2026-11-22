import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Keeps the token pair and the last known user (raw JSON) in secure storage,
/// with an in-memory copy so every request does not hit the keystore.
class TokenStorage {
  TokenStorage(this._storage);

  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';
  static const _userKey = 'cached_user';

  final FlutterSecureStorage _storage;
  String? _access;
  String? _refresh;
  bool _loaded = false;

  String? get accessToken => _access;
  String? get refreshToken => _refresh;

  Future<void> load() async {
    if (_loaded) return;
    try {
      _access = await _storage.read(key: _accessKey);
      _refresh = await _storage.read(key: _refreshKey);
    } catch (_) {
      // A corrupted keystore (e.g. after a backup restore) must not brick the app.
      await clear();
    }
    _loaded = true;
  }

  bool get hasSession => _refresh != null && _refresh!.isNotEmpty;

  /// Save the new pair before doing anything else: the old refresh token is already void.
  Future<void> saveTokens({required String access, required String refresh}) async {
    _access = access;
    _refresh = refresh;
    await _storage.write(key: _accessKey, value: access);
    await _storage.write(key: _refreshKey, value: refresh);
  }

  Future<void> saveUserJson(String json) => _storage.write(key: _userKey, value: json);

  Future<String?> readUserJson() async {
    try {
      return await _storage.read(key: _userKey);
    } catch (_) {
      return null;
    }
  }

  Future<void> clear() async {
    _access = null;
    _refresh = null;
    await _storage.deleteAll();
  }
}
