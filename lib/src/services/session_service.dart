import 'package:session_app/src/rust/api/simple.dart';
import '../core/logging.dart';
import 'key_service.dart';
import 'mnemonic_codec.dart';

const _tag = 'SessionService';

class SessionService {
  final KeyService _keyService;

  SessionService(this._keyService);

  /// Creates a new account: generates keypair, saves keys, returns recovery phrase.
  Future<String> createAccount() async {
    Log.i(_tag, 'Creating new account...');
    final result = generateKeypair();
    final sessionId = result.$1;
    final secretKeyBytes = result.$2;
    final seedHex = result.$3;
    final secretKeyHex = secretKeyBytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();

    await _keyService.saveKeys(
      sessionId: sessionId,
      secretKeyHex: secretKeyHex,
      seedHex: seedHex,
    );

    final recoveryPhrase = MnemonicCodec.encode(seedHex);
    await _keyService.saveRecoveryPhrase(recoveryPhrase);
    Log.i(_tag, 'Account created: ${sessionId.substring(0, 16)}...');
    return sessionId;
  }

  /// Restores account from a 13-word recovery phrase. Returns the Session ID.
  Future<String> restoreAccount(String rawPhrase) async {
    Log.i(_tag, 'Restoring account from recovery phrase...');
    final sanitized = MnemonicCodec.sanitize(rawPhrase);
    final seedHex = MnemonicCodec.decode(sanitized);

    final seedBytes = <int>[];
    for (var i = 0; i < seedHex.length; i += 2) {
      seedBytes.add(int.parse(seedHex.substring(i, i + 2), radix: 16));
    }

    final result = keypairFromSeed(seed: seedBytes);
    final sessionId = result.$1;
    final secretKeyBytes = result.$2;
    final secretKeyHex = secretKeyBytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();

    await _keyService.saveKeys(
      sessionId: sessionId,
      secretKeyHex: secretKeyHex,
      seedHex: seedHex,
    );
    await _keyService.saveRecoveryPhrase(sanitized);
    Log.i(_tag, 'Account restored: ${sessionId.substring(0, 16)}...');
    return sessionId;
  }

  bool isValidSessionId(String id) => validateSessionId(sessionId: id);

  Future<bool> hasAccount() => _keyService.hasAccount();

  Future<String?> getSessionId() => _keyService.getSessionId();

  Future<String?> getRecoveryPhrase() => _keyService.getRecoveryPhrase();

  Future<void> setDisplayName(String name) {
    Log.d(_tag, 'Setting display name: $name');
    return _keyService.saveDisplayName(name);
  }

  Future<String?> getDisplayName() => _keyService.getDisplayName();

  String getLibVersion() => libVersion();
}
