import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/di/injection.dart';
import '../../../services/session_service.dart';
import '../bloc/onboarding_bloc.dart';

class RestoreScreen extends StatelessWidget {
  const RestoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingBloc(getIt<SessionService>()),
      child: const _RestoreBody(),
    );
  }
}

class _RestoreBody extends StatefulWidget {
  const _RestoreBody();

  @override
  State<_RestoreBody> createState() => _RestoreBodyState();
}

class _RestoreBodyState extends State<_RestoreBody> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if (state is AccountRestored) {
          context.go('/display-name');
        } else if (state is OnboardingError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Text(
                  'Restore your account',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter your 13-word recovery phrase to restore your account.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _controller,
                  autofocus: true,
                  maxLines: 4,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    hintText: 'Enter your recovery phrase',
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const Spacer(),
                BlocBuilder<OnboardingBloc, OnboardingState>(
                  builder: (context, state) {
                    final loading = state is OnboardingLoading;
                    final hasText = _controller.text.trim().isNotEmpty;
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: (loading || !hasText)
                            ? null
                            : () => context
                                .read<OnboardingBloc>()
                                .add(RestoreAccountRequested(_controller.text)),
                        child: loading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Restore'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
