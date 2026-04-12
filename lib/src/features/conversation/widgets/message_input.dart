import 'package:flutter/material.dart';

class MessageInput extends StatefulWidget {
  final void Function(String text) onSend;

  const MessageInput({super.key, required this.onSend});

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final _controller = TextEditingController();
  bool _hasText = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
    setState(() => _hasText = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.only(
        left: 12,
        right: 8,
        top: 8,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              // TODO: Attachment picker
            },
            color: theme.colorScheme.primary,
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              maxLines: 5,
              minLines: 1,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'Message',
                filled: true,
                fillColor: theme.colorScheme.surface,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (text) {
                final has = text.trim().isNotEmpty;
                if (has != _hasText) setState(() => _hasText = has);
              },
              onSubmitted: (_) => _send(),
            ),
          ),
          const SizedBox(width: 4),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            child: _hasText
                ? IconButton(
                    key: const ValueKey('send'),
                    icon: const Icon(Icons.send_rounded),
                    onPressed: _send,
                    color: theme.colorScheme.primary,
                  )
                : IconButton(
                    key: const ValueKey('mic'),
                    icon: const Icon(Icons.mic_outlined),
                    onPressed: () {
                      // TODO: Voice message
                    },
                    color: theme.colorScheme.primary,
                  ),
          ),
        ],
      ),
    );
  }
}
