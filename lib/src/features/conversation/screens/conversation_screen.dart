import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection.dart';
import '../../../core/storage/database.dart';
import '../../../services/message_service.dart';
import '../bloc/conversation_bloc.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_input.dart';

class ConversationScreen extends StatelessWidget {
  final String threadId;
  final String? displayName;

  const ConversationScreen({
    super.key,
    required this.threadId,
    this.displayName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ConversationBloc(getIt<MessageService>())
        ..add(ConversationStarted(threadId)),
      child: _ConversationBody(
        threadId: threadId,
        displayName: displayName,
      ),
    );
  }
}

class _ConversationBody extends StatelessWidget {
  final String threadId;
  final String? displayName;

  const _ConversationBody({
    required this.threadId,
    this.displayName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = displayName ?? (threadId.length >= 8 ? '${threadId.substring(0, 8)}...' : threadId);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 16)),
            Text(
              threadId.length >= 16 ? '${threadId.substring(0, 16)}...' : threadId,
              style: TextStyle(
                fontSize: 11,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // TODO: Conversation settings
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ConversationBloc, ConversationState>(
              builder: (context, state) {
                if (state is ConversationLoaded) {
                  return _MessageList(messages: state.messages);
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
          MessageInput(
            onSend: (text) {
              context.read<ConversationBloc>().add(MessageSent(text));
            },
          ),
        ],
      ),
    );
  }
}

class _MessageList extends StatefulWidget {
  final List<Message> messages;
  const _MessageList({required this.messages});

  @override
  State<_MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<_MessageList> {
  final _scrollController = ScrollController();

  @override
  void didUpdateWidget(covariant _MessageList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.messages.length > oldWidget.messages.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.messages.isEmpty) {
      return Center(
        child: Text(
          'No messages yet.\nSay hello!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: widget.messages.length,
      itemBuilder: (context, index) {
        final message = widget.messages[index];
        final showDate = index == 0 ||
            !_sameDay(widget.messages[index - 1].timestamp, message.timestamp);
        return Column(
          children: [
            if (showDate) _DateSeparator(date: message.timestamp),
            MessageBubble(
              body: message.body,
              isOutgoing: message.isOutgoing,
              timestamp: message.timestamp,
              status: MessageStatus.fromValue(message.status),
              onLongPress: () => _showMessageActions(context, message),
            ),
          ],
        );
      },
    );
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  void _showMessageActions(BuildContext context, Message message) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Copy'),
              onTap: () {
                Clipboard.setData(ClipboardData(text: message.body));
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Copied')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('Delete'),
              onTap: () {
                // TODO: Delete message
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DateSeparator extends StatelessWidget {
  final DateTime date;
  const _DateSeparator({required this.date});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    String text;
    if (_sameDay(date, now)) {
      text = 'Today';
    } else if (_sameDay(date, now.subtract(const Duration(days: 1)))) {
      text = 'Yesterday';
    } else {
      text = '${date.day}/${date.month}/${date.year}';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
