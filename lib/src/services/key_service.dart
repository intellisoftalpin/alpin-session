import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class KeyService {
  static const _sessionIdKey = 'session_id';
  static const _secretKeyKey = 'secret_key';
  static const _seedHexKey = 'seed_hex';
  static const _displayNameKey = 'display_name';
  static const _recoveryPhraseKey = 'recovery_phrase';
  static const _lastPollHashKey = 'last_poll_hash';

  final _storage = const FlutterSecureStorage();

  Future<bool> hasAccount() async {
    final sessionId = await _storage.read(key: _sessionIdKey);
    return sessionId != null;
  }

  Future<void> saveKeys({
    required String sessionId,
    required String secretKeyHex,
    required String seedHex,
  }) async {
    await _storage.write(key: _sessionIdKey, value: sessionId);
    await _storage.write(key: _secretKeyKey, value: secretKeyHex);
    await _storage.write(key: _seedHexKey, value: seedHex);
  }

  Future<String?> getSeedHex() async {
    return _storage.read(key: _seedHexKey);
  }

  Future<void> saveDisplayName(String name) async {
    await _storage.write(key: _displayNameKey, value: name);
  }

  Future<String?> getDisplayName() async {
    return _storage.read(key: _displayNameKey);
  }

  Future<void> saveRecoveryPhrase(String phrase) async {
    await _storage.write(key: _recoveryPhraseKey, value: phrase);
  }

  Future<String?> getRecoveryPhrase() async {
    return _storage.read(key: _recoveryPhraseKey);
  }

  Future<String?> getSessionId() async {
    return _storage.read(key: _sessionIdKey);
  }

  Future<String?> getSecretKeyHex() async {
    return _storage.read(key: _secretKeyKey);
  }

  Future<void> saveLastPollHash(String hash) async {
    await _storage.write(key: _lastPollHashKey, value: hash);
  }

  Future<String?> getLastPollHash() async {
    return _storage.read(key: _lastPollHashKey);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
