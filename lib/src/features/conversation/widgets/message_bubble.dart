import 'package:flutter/material.dart';
import '../../../services/message_service.dart';

class MessageBubble extends StatelessWidget {
  final String body;
  final bool isOutgoing;
  final DateTime timestamp;
  final MessageStatus status;
  final VoidCallback? onLongPress;

  const MessageBubble({
    super.key,
    required this.body,
    required this.isOutgoing,
    required this.timestamp,
    required this.status,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bubbleColor = isOutgoing
        ? theme.colorScheme.primary
        : theme.colorScheme.surface;
    final textColor = isOutgoing
        ? Colors.white
        : theme.colorScheme.onSurface;
    final metaColor = isOutgoing
        ? Colors.white.withValues(alpha: 0.7)
        : theme.colorScheme.onSurface.withValues(alpha: 0.5);

    return Align(
      alignment: isOutgoing ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: onLongPress,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          margin: const EdgeInsets.symmetric(vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(isOutgoing ? 16 : 4),
              bottomRight: Radius.circular(isOutgoing ? 4 : 16),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                body,
                style: TextStyle(color: textColor, fontSize: 15),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatTime(timestamp),
                    style: TextStyle(fontSize: 11, color: metaColor),
                  ),
                  if (isOutgoing) ...[
                    const SizedBox(width: 4),
                    _StatusIcon(status: status, color: metaColor),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

class _StatusIcon extends StatelessWidget {
  final MessageStatus status;
  final Color color;

  const _StatusIcon({required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case MessageStatus.sending:
        return Icon(Icons.access_time, size: 14, color: color);
      case MessageStatus.sent:
        return Icon(Icons.check, size: 14, color: color);
      case MessageStatus.delivered:
        return Icon(Icons.done_all, size: 14, color: color);
      case MessageStatus.read:
        return Icon(Icons.done_all, size: 14, color: Colors.blue.shade300);
      case MessageStatus.failed:
        return const Icon(Icons.error_outline, size: 14, color: Colors.red);
    }
  }
}
