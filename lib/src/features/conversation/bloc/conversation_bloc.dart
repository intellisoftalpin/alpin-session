import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/storage/database.dart';
import '../../../services/message_service.dart';

// Events
abstract class ConversationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ConversationStarted extends ConversationEvent {
  final String threadId;
  ConversationStarted(this.threadId);

  @override
  List<Object?> get props => [threadId];
}

class MessageSent extends ConversationEvent {
  final String body;
  final String? quoteId;
  final String? quoteBody;
  MessageSent(this.body, {this.quoteId, this.quoteBody});

  @override
  List<Object?> get props => [body, quoteId, quoteBody];
}

class MessagesUpdated extends ConversationEvent {
  final List<Message> messages;
  MessagesUpdated(this.messages);

  @override
  List<Object?> get props => [messages];
}

// States
abstract class ConversationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ConversationInitial extends ConversationState {}

class ConversationLoaded extends ConversationState {
  final List<Message> messages;
  final Thread? thread;

  ConversationLoaded({required this.messages, this.thread});

  @override
  List<Object?> get props => [messages, thread];
}

// BLoC
class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final MessageService _messageService;
  String? _threadId;
  StreamSubscription<List<Message>>? _messagesSub;

  ConversationBloc(this._messageService) : super(ConversationInitial()) {
    on<ConversationStarted>(_onStarted);
    on<MessageSent>(_onMessageSent);
    on<MessagesUpdated>(_onMessagesUpdated);
  }

  Future<void> _onStarted(
    ConversationStarted event,
    Emitter<ConversationState> emit,
  ) async {
    _threadId = event.threadId;
    await _messagesSub?.cancel();
    _messagesSub = _messageService.watchMessages(event.threadId).listen((messages) {
      add(MessagesUpdated(messages));
    });
  }

  void _onMessagesUpdated(
    MessagesUpdated event,
    Emitter<ConversationState> emit,
  ) {
    emit(ConversationLoaded(messages: event.messages));
  }

  Future<void> _onMessageSent(
    MessageSent event,
    Emitter<ConversationState> emit,
  ) async {
    if (_threadId == null) return;
    await _messageService.sendMessage(
      threadId: _threadId!,
      body: event.body,
      quoteId: event.quoteId,
      quoteBody: event.quoteBody,
    );
  }

  @override
  Future<void> close() {
    _messagesSub?.cancel();
    return super.close();
  }
}
