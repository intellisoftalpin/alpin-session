import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

class Threads extends Table {
  TextColumn get id => text()();
  TextColumn get recipientSessionId => text()();
  TextColumn get displayName => text().nullable()();
  TextColumn get lastMessage => text().nullable()();
  DateTimeColumn get lastMessageTimestamp => dateTime().nullable()();
  IntColumn get unreadCount => integer().withDefault(const Constant(0))();
  BoolColumn get isPinned => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class Messages extends Table {
  TextColumn get id => text()();
  TextColumn get threadId => text().references(Threads, #id)();
  TextColumn get senderSessionId => text()();
  TextColumn get body => text()();
  DateTimeColumn get timestamp => dateTime()();
  IntColumn get status => integer().withDefault(const Constant(0))();
  BoolColumn get isOutgoing => boolean()();
  TextColumn get quoteId => text().nullable()();
  TextColumn get quoteBody => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Threads, Messages])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Thread queries
  Stream<List<Thread>> watchAllThreads() {
    return (select(threads)
          ..orderBy([
            (t) => OrderingTerm.desc(t.lastMessageTimestamp),
          ]))
        .watch();
  }

  Future<Thread?> getThread(String id) {
    return (select(threads)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<void> upsertThread(ThreadsCompanion thread) {
    return into(threads).insertOnConflictUpdate(thread);
  }

  // Message queries
  Stream<List<Message>> watchMessages(String threadId) {
    return (select(messages)
          ..where((m) => m.threadId.equals(threadId))
          ..orderBy([
            (m) => OrderingTerm.asc(m.timestamp),
          ]))
        .watch();
  }

  /// Inserts a message, silently skipping the write if a row with the same
  /// id (snode hash for incoming, local id for outgoing) already exists.
  /// Incoming messages are content-addressable by hash, so re-inserts are
  /// a normal condition — e.g. when the poller re-fetches a batch after a
  /// crash, or when overlapping polls observe the same message. Status
  /// transitions for outgoing messages go through `updateMessageStatus`.
  Future<void> insertMessage(MessagesCompanion message) {
    return into(messages).insert(message, mode: InsertMode.insertOrIgnore);
  }

  Future<void> updateMessageStatus(String messageId, int status) {
    return (update(messages)..where((m) => m.id.equals(messageId)))
        .write(MessagesCompanion(status: Value(status)));
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'alpin_session.db'));
    return NativeDatabase.createInBackground(file);
  });
}
