import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/di/injection.dart';
import '../../../services/session_service.dart';

class RecoveryPhraseScreen extends StatefulWidget {
  const RecoveryPhraseScreen({super.key});

  @override
  State<RecoveryPhraseScreen> createState() => _RecoveryPhraseScreenState();
}

class _RecoveryPhraseScreenState extends State<RecoveryPhraseScreen> {
  String? _recoveryPhrase;
  String? _sessionId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final service = getIt<SessionService>();
    final phrase = await service.getRecoveryPhrase();
    final id = await service.getSessionId();
    if (mounted) {
      setState(() {
        _recoveryPhrase = phrase;
        _sessionId = id;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                'Save your recovery phrase',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Save these words somewhere safe. You\'ll need them to restore your account if you lose access.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
                ),
                child: SelectableText(
                  _recoveryPhrase ?? 'Loading...',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    height: 1.8,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton.icon(
                  onPressed: _recoveryPhrase == null
                      ? null
                      : () {
                          Clipboard.setData(ClipboardData(text: _recoveryPhrase!));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Recovery phrase copied')),
                          );
                        },
                  icon: const Icon(Icons.copy, size: 18),
                  label: const Text('Copy phrase'),
                ),
              ),
              const SizedBox(height: 16),
              if (_sessionId != null) ...[
                Text(
                  'Your Session ID',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 4),
                SelectableText(
                  _sessionId!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go('/home'),
                  child: const Text('Continue'),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
