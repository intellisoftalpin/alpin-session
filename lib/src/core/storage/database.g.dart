// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ThreadsTable extends Threads with TableInfo<$ThreadsTable, Thread> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ThreadsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recipientSessionIdMeta =
      const VerificationMeta('recipientSessionId');
  @override
  late final GeneratedColumn<String> recipientSessionId =
      GeneratedColumn<String>(
        'recipient_session_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastMessageMeta = const VerificationMeta(
    'lastMessage',
  );
  @override
  late final GeneratedColumn<String> lastMessage = GeneratedColumn<String>(
    'last_message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastMessageTimestampMeta =
      const VerificationMeta('lastMessageTimestamp');
  @override
  late final GeneratedColumn<DateTime> lastMessageTimestamp =
      GeneratedColumn<DateTime>(
        'last_message_timestamp',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _unreadCountMeta = const VerificationMeta(
    'unreadCount',
  );
  @override
  late final GeneratedColumn<int> unreadCount = GeneratedColumn<int>(
    'unread_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isPinnedMeta = const VerificationMeta(
    'isPinned',
  );
  @override
  late final GeneratedColumn<bool> isPinned = GeneratedColumn<bool>(
    'is_pinned',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_pinned" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    recipientSessionId,
    displayName,
    lastMessage,
    lastMessageTimestamp,
    unreadCount,
    isPinned,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'threads';
  @override
  VerificationContext validateIntegrity(
    Insertable<Thread> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('recipient_session_id')) {
      context.handle(
        _recipientSessionIdMeta,
        recipientSessionId.isAcceptableOrUnknown(
          data['recipient_session_id']!,
          _recipientSessionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recipientSessionIdMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    if (data.containsKey('last_message')) {
      context.handle(
        _lastMessageMeta,
        lastMessage.isAcceptableOrUnknown(
          data['last_message']!,
          _lastMessageMeta,
        ),
      );
    }
    if (data.containsKey('last_message_timestamp')) {
      context.handle(
        _lastMessageTimestampMeta,
        lastMessageTimestamp.isAcceptableOrUnknown(
          data['last_message_timestamp']!,
          _lastMessageTimestampMeta,
        ),
      );
    }
    if (data.containsKey('unread_count')) {
      context.handle(
        _unreadCountMeta,
        unreadCount.isAcceptableOrUnknown(
          data['unread_count']!,
          _unreadCountMeta,
        ),
      );
    }
    if (data.containsKey('is_pinned')) {
      context.handle(
        _isPinnedMeta,
        isPinned.isAcceptableOrUnknown(data['is_pinned']!, _isPinnedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Thread map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Thread(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      recipientSessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recipient_session_id'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      ),
      lastMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_message'],
      ),
      lastMessageTimestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_message_timestamp'],
      ),
      unreadCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unread_count'],
      )!,
      isPinned: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_pinned'],
      )!,
    );
  }

  @override
  $ThreadsTable createAlias(String alias) {
    return $ThreadsTable(attachedDatabase, alias);
  }
}

class Thread extends DataClass implements Insertable<Thread> {
  final String id;
  final String recipientSessionId;
  final String? displayName;
  final String? lastMessage;
  final DateTime? lastMessageTimestamp;
  final int unreadCount;
  final bool isPinned;
  const Thread({
    required this.id,
    required this.recipientSessionId,
    this.displayName,
    this.lastMessage,
    this.lastMessageTimestamp,
    required this.unreadCount,
    required this.isPinned,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['recipient_session_id'] = Variable<String>(recipientSessionId);
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    if (!nullToAbsent || lastMessage != null) {
      map['last_message'] = Variable<String>(lastMessage);
    }
    if (!nullToAbsent || lastMessageTimestamp != null) {
      map['last_message_timestamp'] = Variable<DateTime>(lastMessageTimestamp);
    }
    map['unread_count'] = Variable<int>(unreadCount);
    map['is_pinned'] = Variable<bool>(isPinned);
    return map;
  }

  ThreadsCompanion toCompanion(bool nullToAbsent) {
    return ThreadsCompanion(
      id: Value(id),
      recipientSessionId: Value(recipientSessionId),
      displayName: displayName == null && nullToAbsent
          ? const Value.absent()
          : Value(displayName),
      lastMessage: lastMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(lastMessage),
      lastMessageTimestamp: lastMessageTimestamp == null && nullToAbsent
          ? const Value.absent()
          : Value(lastMessageTimestamp),
      unreadCount: Value(unreadCount),
      isPinned: Value(isPinned),
    );
  }

  factory Thread.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Thread(
      id: serializer.fromJson<String>(json['id']),
      recipientSessionId: serializer.fromJson<String>(
        json['recipientSessionId'],
      ),
      displayName: serializer.fromJson<String?>(json['displayName']),
      lastMessage: serializer.fromJson<String?>(json['lastMessage']),
      lastMessageTimestamp: serializer.fromJson<DateTime?>(
        json['lastMessageTimestamp'],
      ),
      unreadCount: serializer.fromJson<int>(json['unreadCount']),
      isPinned: serializer.fromJson<bool>(json['isPinned']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'recipientSessionId': serializer.toJson<String>(recipientSessionId),
      'displayName': serializer.toJson<String?>(displayName),
      'lastMessage': serializer.toJson<String?>(lastMessage),
      'lastMessageTimestamp': serializer.toJson<DateTime?>(
        lastMessageTimestamp,
      ),
      'unreadCount': serializer.toJson<int>(unreadCount),
      'isPinned': serializer.toJson<bool>(isPinned),
    };
  }

  Thread copyWith({
    String? id,
    String? recipientSessionId,
    Value<String?> displayName = const Value.absent(),
    Value<String?> lastMessage = const Value.absent(),
    Value<DateTime?> lastMessageTimestamp = const Value.absent(),
    int? unreadCount,
    bool? isPinned,
  }) => Thread(
    id: id ?? this.id,
    recipientSessionId: recipientSessionId ?? this.recipientSessionId,
    displayName: displayName.present ? displayName.value : this.displayName,
    lastMessage: lastMessage.present ? lastMessage.value : this.lastMessage,
    lastMessageTimestamp: lastMessageTimestamp.present
        ? lastMessageTimestamp.value
        : this.lastMessageTimestamp,
    unreadCount: unreadCount ?? this.unreadCount,
    isPinned: isPinned ?? this.isPinned,
  );
  Thread copyWithCompanion(ThreadsCompanion data) {
    return Thread(
      id: data.id.present ? data.id.value : this.id,
      recipientSessionId: data.recipientSessionId.present
          ? data.recipientSessionId.value
          : this.recipientSessionId,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      lastMessage: data.lastMessage.present
          ? data.lastMessage.value
          : this.lastMessage,
      lastMessageTimestamp: data.lastMessageTimestamp.present
          ? data.lastMessageTimestamp.value
          : this.lastMessageTimestamp,
      unreadCount: data.unreadCount.present
          ? data.unreadCount.value
          : this.unreadCount,
      isPinned: data.isPinned.present ? data.isPinned.value : this.isPinned,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Thread(')
          ..write('id: $id, ')
          ..write('recipientSessionId: $recipientSessionId, ')
          ..write('displayName: $displayName, ')
          ..write('lastMessage: $lastMessage, ')
          ..write('lastMessageTimestamp: $lastMessageTimestamp, ')
          ..write('unreadCount: $unreadCount, ')
          ..write('isPinned: $isPinned')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    recipientSessionId,
    displayName,
    lastMessage,
    lastMessageTimestamp,
    unreadCount,
    isPinned,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Thread &&
          other.id == this.id &&
          other.recipientSessionId == this.recipientSessionId &&
          other.displayName == this.displayName &&
          other.lastMessage == this.lastMessage &&
          other.lastMessageTimestamp == this.lastMessageTimestamp &&
          other.unreadCount == this.unreadCount &&
          other.isPinned == this.isPinned);
}

class ThreadsCompanion extends UpdateCompanion<Thread> {
  final Value<String> id;
  final Value<String> recipientSessionId;
  final Value<String?> displayName;
  final Value<String?> lastMessage;
  final Value<DateTime?> lastMessageTimestamp;
  final Value<int> unreadCount;
  final Value<bool> isPinned;
  final Value<int> rowid;
  const ThreadsCompanion({
    this.id = const Value.absent(),
    this.recipientSessionId = const Value.absent(),
    this.displayName = const Value.absent(),
    this.lastMessage = const Value.absent(),
    this.lastMessageTimestamp = const Value.absent(),
    this.unreadCount = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ThreadsCompanion.insert({
    required String id,
    required String recipientSessionId,
    this.displayName = const Value.absent(),
    this.lastMessage = const Value.absent(),
    this.lastMessageTimestamp = const Value.absent(),
    this.unreadCount = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       recipientSessionId = Value(recipientSessionId);
  static Insertable<Thread> custom({
    Expression<String>? id,
    Expression<String>? recipientSessionId,
    Expression<String>? displayName,
    Expression<String>? lastMessage,
    Expression<DateTime>? lastMessageTimestamp,
    Expression<int>? unreadCount,
    Expression<bool>? isPinned,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recipientSessionId != null)
        'recipient_session_id': recipientSessionId,
      if (displayName != null) 'display_name': displayName,
      if (lastMessage != null) 'last_message': lastMessage,
      if (lastMessageTimestamp != null)
        'last_message_timestamp': lastMessageTimestamp,
      if (unreadCount != null) 'unread_count': unreadCount,
      if (isPinned != null) 'is_pinned': isPinned,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ThreadsCompanion copyWith({
    Value<String>? id,
    Value<String>? recipientSessionId,
    Value<String?>? displayName,
    Value<String?>? lastMessage,
    Value<DateTime?>? lastMessageTimestamp,
    Value<int>? unreadCount,
    Value<bool>? isPinned,
    Value<int>? rowid,
  }) {
    return ThreadsCompanion(
      id: id ?? this.id,
      recipientSessionId: recipientSessionId ?? this.recipientSessionId,
      displayName: displayName ?? this.displayName,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTimestamp: lastMessageTimestamp ?? this.lastMessageTimestamp,
      unreadCount: unreadCount ?? this.unreadCount,
      isPinned: isPinned ?? this.isPinned,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (recipientSessionId.present) {
      map['recipient_session_id'] = Variable<String>(recipientSessionId.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (lastMessage.present) {
      map['last_message'] = Variable<String>(lastMessage.value);
    }
    if (lastMessageTimestamp.present) {
      map['last_message_timestamp'] = Variable<DateTime>(
        lastMessageTimestamp.value,
      );
    }
    if (unreadCount.present) {
      map['unread_count'] = Variable<int>(unreadCount.value);
    }
    if (isPinned.present) {
      map['is_pinned'] = Variable<bool>(isPinned.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ThreadsCompanion(')
          ..write('id: $id, ')
          ..write('recipientSessionId: $recipientSessionId, ')
          ..write('displayName: $displayName, ')
          ..write('lastMessage: $lastMessage, ')
          ..write('lastMessageTimestamp: $lastMessageTimestamp, ')
          ..write('unreadCount: $unreadCount, ')
          ..write('isPinned: $isPinned, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MessagesTable extends Messages with TableInfo<$MessagesTable, Message> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _threadIdMeta = const VerificationMeta(
    'threadId',
  );
  @override
  late final GeneratedColumn<String> threadId = GeneratedColumn<String>(
    'thread_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES threads (id)',
    ),
  );
  static const VerificationMeta _senderSessionIdMeta = const VerificationMeta(
    'senderSessionId',
  );
  @override
  late final GeneratedColumn<String> senderSessionId = GeneratedColumn<String>(
    'sender_session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isOutgoingMeta = const VerificationMeta(
    'isOutgoing',
  );
  @override
  late final GeneratedColumn<bool> isOutgoing = GeneratedColumn<bool>(
    'is_outgoing',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_outgoing" IN (0, 1))',
    ),
  );
  static const VerificationMeta _quoteIdMeta = const VerificationMeta(
    'quoteId',
  );
  @override
  late final GeneratedColumn<String> quoteId = GeneratedColumn<String>(
    'quote_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quoteBodyMeta = const VerificationMeta(
    'quoteBody',
  );
  @override
  late final GeneratedColumn<String> quoteBody = GeneratedColumn<String>(
    'quote_body',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    threadId,
    senderSessionId,
    body,
    timestamp,
    status,
    isOutgoing,
    quoteId,
    quoteBody,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<Message> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('thread_id')) {
      context.handle(
        _threadIdMeta,
        threadId.isAcceptableOrUnknown(data['thread_id']!, _threadIdMeta),
      );
    } else if (isInserting) {
      context.missing(_threadIdMeta);
    }
    if (data.containsKey('sender_session_id')) {
      context.handle(
        _senderSessionIdMeta,
        senderSessionId.isAcceptableOrUnknown(
          data['sender_session_id']!,
          _senderSessionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_senderSessionIdMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('is_outgoing')) {
      context.handle(
        _isOutgoingMeta,
        isOutgoing.isAcceptableOrUnknown(data['is_outgoing']!, _isOutgoingMeta),
      );
    } else if (isInserting) {
      context.missing(_isOutgoingMeta);
    }
    if (data.containsKey('quote_id')) {
      context.handle(
        _quoteIdMeta,
        quoteId.isAcceptableOrUnknown(data['quote_id']!, _quoteIdMeta),
      );
    }
    if (data.containsKey('quote_body')) {
      context.handle(
        _quoteBodyMeta,
        quoteBody.isAcceptableOrUnknown(data['quote_body']!, _quoteBodyMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Message map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Message(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      threadId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thread_id'],
      )!,
      senderSessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sender_session_id'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}status'],
      )!,
      isOutgoing: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_outgoing'],
      )!,
      quoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quote_id'],
      ),
      quoteBody: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quote_body'],
      ),
    );
  }

  @override
  $MessagesTable createAlias(String alias) {
    return $MessagesTable(attachedDatabase, alias);
  }
}

class Message extends DataClass implements Insertable<Message> {
  final String id;
  final String threadId;
  final String senderSessionId;
  final String body;
  final DateTime timestamp;
  final int status;
  final bool isOutgoing;
  final String? quoteId;
  final String? quoteBody;
  const Message({
    required this.id,
    required this.threadId,
    required this.senderSessionId,
    required this.body,
    required this.timestamp,
    required this.status,
    required this.isOutgoing,
    this.quoteId,
    this.quoteBody,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['thread_id'] = Variable<String>(threadId);
    map['sender_session_id'] = Variable<String>(senderSessionId);
    map['body'] = Variable<String>(body);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['status'] = Variable<int>(status);
    map['is_outgoing'] = Variable<bool>(isOutgoing);
    if (!nullToAbsent || quoteId != null) {
      map['quote_id'] = Variable<String>(quoteId);
    }
    if (!nullToAbsent || quoteBody != null) {
      map['quote_body'] = Variable<String>(quoteBody);
    }
    return map;
  }

  MessagesCompanion toCompanion(bool nullToAbsent) {
    return MessagesCompanion(
      id: Value(id),
      threadId: Value(threadId),
      senderSessionId: Value(senderSessionId),
      body: Value(body),
      timestamp: Value(timestamp),
      status: Value(status),
      isOutgoing: Value(isOutgoing),
      quoteId: quoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(quoteId),
      quoteBody: quoteBody == null && nullToAbsent
          ? const Value.absent()
          : Value(quoteBody),
    );
  }

  factory Message.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Message(
      id: serializer.fromJson<String>(json['id']),
      threadId: serializer.fromJson<String>(json['threadId']),
      senderSessionId: serializer.fromJson<String>(json['senderSessionId']),
      body: serializer.fromJson<String>(json['body']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      status: serializer.fromJson<int>(json['status']),
      isOutgoing: serializer.fromJson<bool>(json['isOutgoing']),
      quoteId: serializer.fromJson<String?>(json['quoteId']),
      quoteBody: serializer.fromJson<String?>(json['quoteBody']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'threadId': serializer.toJson<String>(threadId),
      'senderSessionId': serializer.toJson<String>(senderSessionId),
      'body': serializer.toJson<String>(body),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'status': serializer.toJson<int>(status),
      'isOutgoing': serializer.toJson<bool>(isOutgoing),
      'quoteId': serializer.toJson<String?>(quoteId),
      'quoteBody': serializer.toJson<String?>(quoteBody),
    };
  }

  Message copyWith({
    String? id,
    String? threadId,
    String? senderSessionId,
    String? body,
    DateTime? timestamp,
    int? status,
    bool? isOutgoing,
    Value<String?> quoteId = const Value.absent(),
    Value<String?> quoteBody = const Value.absent(),
  }) => Message(
    id: id ?? this.id,
    threadId: threadId ?? this.threadId,
    senderSessionId: senderSessionId ?? this.senderSessionId,
    body: body ?? this.body,
    timestamp: timestamp ?? this.timestamp,
    status: status ?? this.status,
    isOutgoing: isOutgoing ?? this.isOutgoing,
    quoteId: quoteId.present ? quoteId.value : this.quoteId,
    quoteBody: quoteBody.present ? quoteBody.value : this.quoteBody,
  );
  Message copyWithCompanion(MessagesCompanion data) {
    return Message(
      id: data.id.present ? data.id.value : this.id,
      threadId: data.threadId.present ? data.threadId.value : this.threadId,
      senderSessionId: data.senderSessionId.present
          ? data.senderSessionId.value
          : this.senderSessionId,
      body: data.body.present ? data.body.value : this.body,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      status: data.status.present ? data.status.value : this.status,
      isOutgoing: data.isOutgoing.present
          ? data.isOutgoing.value
          : this.isOutgoing,
      quoteId: data.quoteId.present ? data.quoteId.value : this.quoteId,
      quoteBody: data.quoteBody.present ? data.quoteBody.value : this.quoteBody,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Message(')
          ..write('id: $id, ')
          ..write('threadId: $threadId, ')
          ..write('senderSessionId: $senderSessionId, ')
          ..write('body: $body, ')
          ..write('timestamp: $timestamp, ')
          ..write('status: $status, ')
          ..write('isOutgoing: $isOutgoing, ')
          ..write('quoteId: $quoteId, ')
          ..write('quoteBody: $quoteBody')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    threadId,
    senderSessionId,
    body,
    timestamp,
    status,
    isOutgoing,
    quoteId,
    quoteBody,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Message &&
          other.id == this.id &&
          other.threadId == this.threadId &&
          other.senderSessionId == this.senderSessionId &&
          other.body == this.body &&
          other.timestamp == this.timestamp &&
          other.status == this.status &&
          other.isOutgoing == this.isOutgoing &&
          other.quoteId == this.quoteId &&
          other.quoteBody == this.quoteBody);
}

class MessagesCompanion extends UpdateCompanion<Message> {
  final Value<String> id;
  final Value<String> threadId;
  final Value<String> senderSessionId;
  final Value<String> body;
  final Value<DateTime> timestamp;
  final Value<int> status;
  final Value<bool> isOutgoing;
  final Value<String?> quoteId;
  final Value<String?> quoteBody;
  final Value<int> rowid;
  const MessagesCompanion({
    this.id = const Value.absent(),
    this.threadId = const Value.absent(),
    this.senderSessionId = const Value.absent(),
    this.body = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.status = const Value.absent(),
    this.isOutgoing = const Value.absent(),
    this.quoteId = const Value.absent(),
    this.quoteBody = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MessagesCompanion.insert({
    required String id,
    required String threadId,
    required String senderSessionId,
    required String body,
    required DateTime timestamp,
    this.status = const Value.absent(),
    required bool isOutgoing,
    this.quoteId = const Value.absent(),
    this.quoteBody = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       threadId = Value(threadId),
       senderSessionId = Value(senderSessionId),
       body = Value(body),
       timestamp = Value(timestamp),
       isOutgoing = Value(isOutgoing);
  static Insertable<Message> custom({
    Expression<String>? id,
    Expression<String>? threadId,
    Expression<String>? senderSessionId,
    Expression<String>? body,
    Expression<DateTime>? timestamp,
    Expression<int>? status,
    Expression<bool>? isOutgoing,
    Expression<String>? quoteId,
    Expression<String>? quoteBody,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (threadId != null) 'thread_id': threadId,
      if (senderSessionId != null) 'sender_session_id': senderSessionId,
      if (body != null) 'body': body,
      if (timestamp != null) 'timestamp': timestamp,
      if (status != null) 'status': status,
      if (isOutgoing != null) 'is_outgoing': isOutgoing,
      if (quoteId != null) 'quote_id': quoteId,
      if (quoteBody != null) 'quote_body': quoteBody,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MessagesCompanion copyWith({
    Value<String>? id,
    Value<String>? threadId,
    Value<String>? senderSessionId,
    Value<String>? body,
    Value<DateTime>? timestamp,
    Value<int>? status,
    Value<bool>? isOutgoing,
    Value<String?>? quoteId,
    Value<String?>? quoteBody,
    Value<int>? rowid,
  }) {
    return MessagesCompanion(
      id: id ?? this.id,
      threadId: threadId ?? this.threadId,
      senderSessionId: senderSessionId ?? this.senderSessionId,
      body: body ?? this.body,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      isOutgoing: isOutgoing ?? this.isOutgoing,
      quoteId: quoteId ?? this.quoteId,
      quoteBody: quoteBody ?? this.quoteBody,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (threadId.present) {
      map['thread_id'] = Variable<String>(threadId.value);
    }
    if (senderSessionId.present) {
      map['sender_session_id'] = Variable<String>(senderSessionId.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (isOutgoing.present) {
      map['is_outgoing'] = Variable<bool>(isOutgoing.value);
    }
    if (quoteId.present) {
      map['quote_id'] = Variable<String>(quoteId.value);
    }
    if (quoteBody.present) {
      map['quote_body'] = Variable<String>(quoteBody.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessagesCompanion(')
          ..write('id: $id, ')
          ..write('threadId: $threadId, ')
          ..write('senderSessionId: $senderSessionId, ')
          ..write('body: $body, ')
          ..write('timestamp: $timestamp, ')
          ..write('status: $status, ')
          ..write('isOutgoing: $isOutgoing, ')
          ..write('quoteId: $quoteId, ')
          ..write('quoteBody: $quoteBody, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ThreadsTable threads = $ThreadsTable(this);
  late final $MessagesTable messages = $MessagesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [threads, messages];
}

typedef $$ThreadsTableCreateCompanionBuilder =
    ThreadsCompanion Function({
      required String id,
      required String recipientSessionId,
      Value<String?> displayName,
      Value<String?> lastMessage,
      Value<DateTime?> lastMessageTimestamp,
      Value<int> unreadCount,
      Value<bool> isPinned,
      Value<int> rowid,
    });
typedef $$ThreadsTableUpdateCompanionBuilder =
    ThreadsCompanion Function({
      Value<String> id,
      Value<String> recipientSessionId,
      Value<String?> displayName,
      Value<String?> lastMessage,
      Value<DateTime?> lastMessageTimestamp,
      Value<int> unreadCount,
      Value<bool> isPinned,
      Value<int> rowid,
    });

final class $$ThreadsTableReferences
    extends BaseReferences<_$AppDatabase, $ThreadsTable, Thread> {
  $$ThreadsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MessagesTable, List<Message>> _messagesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.messages,
    aliasName: $_aliasNameGenerator(db.threads.id, db.messages.threadId),
  );

  $$MessagesTableProcessedTableManager get messagesRefs {
    final manager = $$MessagesTableTableManager(
      $_db,
      $_db.messages,
    ).filter((f) => f.threadId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_messagesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ThreadsTableFilterComposer
    extends Composer<_$AppDatabase, $ThreadsTable> {
  $$ThreadsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recipientSessionId => $composableBuilder(
    column: $table.recipientSessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastMessage => $composableBuilder(
    column: $table.lastMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastMessageTimestamp => $composableBuilder(
    column: $table.lastMessageTimestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unreadCount => $composableBuilder(
    column: $table.unreadCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPinned => $composableBuilder(
    column: $table.isPinned,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> messagesRefs(
    Expression<bool> Function($$MessagesTableFilterComposer f) f,
  ) {
    final $$MessagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.messages,
      getReferencedColumn: (t) => t.threadId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessagesTableFilterComposer(
            $db: $db,
            $table: $db.messages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ThreadsTableOrderingComposer
    extends Composer<_$AppDatabase, $ThreadsTable> {
  $$ThreadsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recipientSessionId => $composableBuilder(
    column: $table.recipientSessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastMessage => $composableBuilder(
    column: $table.lastMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastMessageTimestamp => $composableBuilder(
    column: $table.lastMessageTimestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unreadCount => $composableBuilder(
    column: $table.unreadCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPinned => $composableBuilder(
    column: $table.isPinned,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ThreadsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ThreadsTable> {
  $$ThreadsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get recipientSessionId => $composableBuilder(
    column: $table.recipientSessionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastMessage => $composableBuilder(
    column: $table.lastMessage,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastMessageTimestamp => $composableBuilder(
    column: $table.lastMessageTimestamp,
    builder: (column) => column,
  );

  GeneratedColumn<int> get unreadCount => $composableBuilder(
    column: $table.unreadCount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPinned =>
      $composableBuilder(column: $table.isPinned, builder: (column) => column);

  Expression<T> messagesRefs<T extends Object>(
    Expression<T> Function($$MessagesTableAnnotationComposer a) f,
  ) {
    final $$MessagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.messages,
      getReferencedColumn: (t) => t.threadId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessagesTableAnnotationComposer(
            $db: $db,
            $table: $db.messages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ThreadsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ThreadsTable,
          Thread,
          $$ThreadsTableFilterComposer,
          $$ThreadsTableOrderingComposer,
          $$ThreadsTableAnnotationComposer,
          $$ThreadsTableCreateCompanionBuilder,
          $$ThreadsTableUpdateCompanionBuilder,
          (Thread, $$ThreadsTableReferences),
          Thread,
          PrefetchHooks Function({bool messagesRefs})
        > {
  $$ThreadsTableTableManager(_$AppDatabase db, $ThreadsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ThreadsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ThreadsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ThreadsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> recipientSessionId = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<String?> lastMessage = const Value.absent(),
                Value<DateTime?> lastMessageTimestamp = const Value.absent(),
                Value<int> unreadCount = const Value.absent(),
                Value<bool> isPinned = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ThreadsCompanion(
                id: id,
                recipientSessionId: recipientSessionId,
                displayName: displayName,
                lastMessage: lastMessage,
                lastMessageTimestamp: lastMessageTimestamp,
                unreadCount: unreadCount,
                isPinned: isPinned,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String recipientSessionId,
                Value<String?> displayName = const Value.absent(),
                Value<String?> lastMessage = const Value.absent(),
                Value<DateTime?> lastMessageTimestamp = const Value.absent(),
                Value<int> unreadCount = const Value.absent(),
                Value<bool> isPinned = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ThreadsCompanion.insert(
                id: id,
                recipientSessionId: recipientSessionId,
                displayName: displayName,
                lastMessage: lastMessage,
                lastMessageTimestamp: lastMessageTimestamp,
                unreadCount: unreadCount,
                isPinned: isPinned,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ThreadsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({messagesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (messagesRefs) db.messages],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (messagesRefs)
                    await $_getPrefetchedData<Thread, $ThreadsTable, Message>(
                      currentTable: table,
                      referencedTable: $$ThreadsTableReferences
                          ._messagesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ThreadsTableReferences(db, table, p0).messagesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.threadId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ThreadsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ThreadsTable,
      Thread,
      $$ThreadsTableFilterComposer,
      $$ThreadsTableOrderingComposer,
      $$ThreadsTableAnnotationComposer,
      $$ThreadsTableCreateCompanionBuilder,
      $$ThreadsTableUpdateCompanionBuilder,
      (Thread, $$ThreadsTableReferences),
      Thread,
      PrefetchHooks Function({bool messagesRefs})
    >;
typedef $$MessagesTableCreateCompanionBuilder =
    MessagesCompanion Function({
      required String id,
      required String threadId,
      required String senderSessionId,
      required String body,
      required DateTime timestamp,
      Value<int> status,
      required bool isOutgoing,
      Value<String?> quoteId,
      Value<String?> quoteBody,
      Value<int> rowid,
    });
typedef $$MessagesTableUpdateCompanionBuilder =
    MessagesCompanion Function({
      Value<String> id,
      Value<String> threadId,
      Value<String> senderSessionId,
      Value<String> body,
      Value<DateTime> timestamp,
      Value<int> status,
      Value<bool> isOutgoing,
      Value<String?> quoteId,
      Value<String?> quoteBody,
      Value<int> rowid,
    });

final class $$MessagesTableReferences
    extends BaseReferences<_$AppDatabase, $MessagesTable, Message> {
  $$MessagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ThreadsTable _threadIdTable(_$AppDatabase db) => db.threads
      .createAlias($_aliasNameGenerator(db.messages.threadId, db.threads.id));

  $$ThreadsTableProcessedTableManager get threadId {
    final $_column = $_itemColumn<String>('thread_id')!;

    final manager = $$ThreadsTableTableManager(
      $_db,
      $_db.threads,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_threadIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MessagesTableFilterComposer
    extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get senderSessionId => $composableBuilder(
    column: $table.senderSessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isOutgoing => $composableBuilder(
    column: $table.isOutgoing,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quoteId => $composableBuilder(
    column: $table.quoteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quoteBody => $composableBuilder(
    column: $table.quoteBody,
    builder: (column) => ColumnFilters(column),
  );

  $$ThreadsTableFilterComposer get threadId {
    final $$ThreadsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.threadId,
      referencedTable: $db.threads,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ThreadsTableFilterComposer(
            $db: $db,
            $table: $db.threads,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get senderSessionId => $composableBuilder(
    column: $table.senderSessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isOutgoing => $composableBuilder(
    column: $table.isOutgoing,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quoteId => $composableBuilder(
    column: $table.quoteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quoteBody => $composableBuilder(
    column: $table.quoteBody,
    builder: (column) => ColumnOrderings(column),
  );

  $$ThreadsTableOrderingComposer get threadId {
    final $$ThreadsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.threadId,
      referencedTable: $db.threads,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ThreadsTableOrderingComposer(
            $db: $db,
            $table: $db.threads,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get senderSessionId => $composableBuilder(
    column: $table.senderSessionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get isOutgoing => $composableBuilder(
    column: $table.isOutgoing,
    builder: (column) => column,
  );

  GeneratedColumn<String> get quoteId =>
      $composableBuilder(column: $table.quoteId, builder: (column) => column);

  GeneratedColumn<String> get quoteBody =>
      $composableBuilder(column: $table.quoteBody, builder: (column) => column);

  $$ThreadsTableAnnotationComposer get threadId {
    final $$ThreadsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.threadId,
      referencedTable: $db.threads,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ThreadsTableAnnotationComposer(
            $db: $db,
            $table: $db.threads,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MessagesTable,
          Message,
          $$MessagesTableFilterComposer,
          $$MessagesTableOrderingComposer,
          $$MessagesTableAnnotationComposer,
          $$MessagesTableCreateCompanionBuilder,
          $$MessagesTableUpdateCompanionBuilder,
          (Message, $$MessagesTableReferences),
          Message,
          PrefetchHooks Function({bool threadId})
        > {
  $$MessagesTableTableManager(_$AppDatabase db, $MessagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> threadId = const Value.absent(),
                Value<String> senderSessionId = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<int> status = const Value.absent(),
                Value<bool> isOutgoing = const Value.absent(),
                Value<String?> quoteId = const Value.absent(),
                Value<String?> quoteBody = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MessagesCompanion(
                id: id,
                threadId: threadId,
                senderSessionId: senderSessionId,
                body: body,
                timestamp: timestamp,
                status: status,
                isOutgoing: isOutgoing,
                quoteId: quoteId,
                quoteBody: quoteBody,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String threadId,
                required String senderSessionId,
                required String body,
                required DateTime timestamp,
                Value<int> status = const Value.absent(),
                required bool isOutgoing,
                Value<String?> quoteId = const Value.absent(),
                Value<String?> quoteBody = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MessagesCompanion.insert(
                id: id,
                threadId: threadId,
                senderSessionId: senderSessionId,
                body: body,
                timestamp: timestamp,
                status: status,
                isOutgoing: isOutgoing,
                quoteId: quoteId,
                quoteBody: quoteBody,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MessagesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({threadId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (threadId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.threadId,
                                referencedTable: $$MessagesTableReferences
                                    ._threadIdTable(db),
                                referencedColumn: $$MessagesTableReferences
                                    ._threadIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MessagesTable,
      Message,
      $$MessagesTableFilterComposer,
      $$MessagesTableOrderingComposer,
      $$MessagesTableAnnotationComposer,
      $$MessagesTableCreateCompanionBuilder,
      $$MessagesTableUpdateCompanionBuilder,
      (Message, $$MessagesTableReferences),
      Message,
      PrefetchHooks Function({bool threadId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ThreadsTableTableManager get threads =>
      $$ThreadsTableTableManager(_db, _db.threads);
  $$MessagesTableTableManager get messages =>
      $$MessagesTableTableManager(_db, _db.messages);
}
