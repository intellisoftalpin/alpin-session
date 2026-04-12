import 'dart:async';
import 'package:drift/drift.dart';
import '../core/logging.dart';
import '../core/storage/database.dart';
import '../rust/api/simple.dart' as rust;
import 'key_service.dart';

const _tag = 'MessageService';

enum MessageStatus {
  sending(0),
  sent(1),
  delivered(2),
  read(3),
  failed(-1);

  final int value;
  const MessageStatus(this.value);

  static MessageStatus fromValue(int v) =>
      MessageStatus.values.firstWhere((s) => s.value == v, orElse: () => sending);
}

/// Message orchestration layer.
///
/// Owns the local drift DB and drives the Rust `libsession::Network` facade
/// for every snode RPC. All encryption + onion routing happens inside Rust —
/// this class holds no keys, no crypto, and no direct HTTP.
class MessageService {
  final AppDatabase _db;
  final KeyService _keyService;

  Timer? _pollTimer;
  bool _polling = false;
  bool _lastHashLoaded = false;
  String _lastHash = '';

  MessageService(this._db, this._keyService);

  Stream<List<Thread>> watchThreads() => _db.watchAllThreads();

  Stream<List<Message>> watchMessages(String threadId) => _db.watchMessages(threadId);

  // -------------------------------------------------------------------------
  // Polling
  // -------------------------------------------------------------------------

  void startPolling({Duration interval = const Duration(seconds: 4)}) {
    if (_pollTimer != null) return;
    Log.i(_tag, 'Starting message polling (interval=${interval.inSeconds}s)');
    _pollOnce();
    _pollTimer = Timer.periodic(interval, (_) => _pollOnce());
  }

  void stopPolling() {
    Log.i(_tag, 'Stopping message polling');
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  Future<void> _pollOnce() async {
    if (_polling) return;
    _polling = true;
    try {
      final sessionId = await _keyService.getSessionId();
      final secretKeyHex = await _keyService.getSecretKeyHex();
      if (sessionId == null || secretKeyHex == null) {
        return;
      }

      if (!_lastHashLoaded) {
        _lastHash = (await _keyService.getLastPollHash()) ?? '';
        _lastHashLoaded = true;
        if (_lastHash.isNotEmpty) {
          Log.i(_tag, 'Resuming poll from saved lastHash');
        }
      }

      final skBytes = _hexToBytes(secretKeyHex);

      final messages = await rust.pollMessages(
        myEd25519SecretKey: skBytes,
        mySessionId: sessionId,
        lastHash: _lastHash,
      );

      if (messages.isEmpty) return;

      Log.i(_tag, 'Received ${messages.length} decrypted message(s)');
      for (final m in messages) {
        // Advance _lastHash regardless of storage outcome: the snode has
        // already handed this message to us, re-fetching it gains nothing.
        // Per-message try/catch isolates bad rows so one failure doesn't
        // skip the rest of the batch (e.g. thread FK issue, disk error).
        try {
          await _storeIncomingMessage(m);
        } catch (e) {
          Log.w(_tag, 'Failed to store message ${m.hash}: $e');
        }
        if (m.hash.isNotEmpty) _lastHash = m.hash;
      }
      if (_lastHash.isNotEmpty) {
        await _keyService.saveLastPollHash(_lastHash);
      }
    } catch (e) {
      Log.w(_tag, 'Poll failed: $e');
    } finally {
      _polling = false;
    }
  }

  Future<void> _storeIncomingMessage(rust.PolledMessage m) async {
    if (m.body.isEmpty) return; // control / config messages

    final threadId = m.senderSessionId;
    final msgTime = m.timestampMs > 0
        ? DateTime.fromMillisecondsSinceEpoch(m.timestampMs)
        : DateTime.now();
    final messageId =
        m.hash.isNotEmpty ? m.hash : DateTime.now().microsecondsSinceEpoch.toRadixString(36);

    await _db.upsertThread(ThreadsCompanion(
      id: Value(threadId),
      recipientSessionId: Value(threadId),
      lastMessage: Value(m.body),
      lastMessageTimestamp: Value(msgTime),
    ));

    await _db.insertMessage(MessagesCompanion(
      id: Value(messageId),
      threadId: Value(threadId),
      senderSessionId: Value(m.senderSessionId),
      body: Value(m.body),
      timestamp: Value(msgTime),
      status: Value(MessageStatus.delivered.value),
      isOutgoing: const Value(false),
    ));
  }

  // -------------------------------------------------------------------------
  // Send
  // -------------------------------------------------------------------------

  Future<String> startConversation(String recipientSessionId, {String? displayName}) async {
    Log.i(_tag, 'Starting conversation with ${recipientSessionId.substring(0, 8)}...');
    await _db.upsertThread(ThreadsCompanion(
      id: Value(recipientSessionId),
      recipientSessionId: Value(recipientSessionId),
      displayName: Value(displayName),
    ));
    return recipientSessionId;
  }

  Future<void> sendMessage({
    required String threadId,
    required String body,
    String? quoteId,
    String? quoteBody,
  }) async {
    final mySessionId = await _keyService.getSessionId();
    final secretKeyHex = await _keyService.getSecretKeyHex();
    if (mySessionId == null || secretKeyHex == null) {
      Log.e(_tag, 'Cannot send: no session keys');
      return;
    }

    final messageId = DateTime.now().microsecondsSinceEpoch.toRadixString(36);
    final now = DateTime.now();
    final timestampMs = now.millisecondsSinceEpoch;

    Log.i(_tag, 'Sending message to ${threadId.substring(0, 8)}... body=${body.length} chars');

    // Insert locally as "sending".
    await _db.insertMessage(MessagesCompanion(
      id: Value(messageId),
      threadId: Value(threadId),
      senderSessionId: Value(mySessionId),
      body: Value(body),
      timestamp: Value(now),
      status: Value(MessageStatus.sending.value),
      isOutgoing: const Value(true),
      quoteId: Value(quoteId),
      quoteBody: Value(quoteBody),
    ));

    await _db.upsertThread(ThreadsCompanion(
      id: Value(threadId),
      recipientSessionId: Value(threadId),
      lastMessage: Value(body),
      lastMessageTimestamp: Value(now),
    ));

    try {
      final skBytes = _hexToBytes(secretKeyHex);
      await rust.sendMessage(
        senderEd25519SecretKey: skBytes,
        recipientSessionId: threadId,
        text: body,
        timestampMs: timestampMs,
      );
      await _db.updateMessageStatus(messageId, MessageStatus.sent.value);
      Log.i(_tag, 'Message sent successfully: $messageId');
    } catch (e, stack) {
      Log.e(_tag, 'Failed to send message', e, stack);
      await _db.updateMessageStatus(messageId, MessageStatus.failed.value);
    }
  }

  List<int> _hexToBytes(String hex) {
    final bytes = <int>[];
    for (var i = 0; i < hex.length; i += 2) {
      bytes.add(int.parse(hex.substring(i, i + 2), radix: 16));
    }
    return bytes;
  }
}

