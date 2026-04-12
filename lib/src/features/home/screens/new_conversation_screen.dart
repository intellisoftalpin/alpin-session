import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/di/injection.dart';
import '../../../services/message_service.dart';
import '../../../services/session_service.dart';

class NewConversationScreen extends StatefulWidget {
  const NewConversationScreen({super.key});

  @override
  State<NewConversationScreen> createState() => _NewConversationScreenState();
}

class _NewConversationScreenState extends State<NewConversationScreen> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onStart() async {
    final input = _controller.text.trim();
    final sessionService = getIt<SessionService>();

    if (!sessionService.isValidSessionId(input)) {
      setState(() => _error = 'Invalid Session ID');
      return;
    }

    final messageService = getIt<MessageService>();
    final threadId = await messageService.startConversation(input);
    if (mounted) {
      // Replace the new-conversation screen with the conversation
      // so back returns to the home screen, not to new-conversation.
      context.pop();
      context.push('/conversation/$threadId');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('New Conversation')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter Session ID',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Paste a Session ID to start a private conversation.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _controller,
              autofocus: true,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: '05...',
                errorText: _error,
              ),
              onChanged: (_) => setState(() => _error = null),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onStart,
                child: const Text('Start Conversation'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
