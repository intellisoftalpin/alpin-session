import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/di/injection.dart';
import '../../../services/session_service.dart';
import '../bloc/onboarding_bloc.dart';

class DisplayNameScreen extends StatelessWidget {
  const DisplayNameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingBloc(getIt<SessionService>()),
      child: const _DisplayNameBody(),
    );
  }
}

class _DisplayNameBody extends StatefulWidget {
  const _DisplayNameBody();

  @override
  State<_DisplayNameBody> createState() => _DisplayNameBodyState();
}

class _DisplayNameBodyState extends State<_DisplayNameBody> {
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
        if (state is DisplayNameSaved) {
          context.go('/recovery-phrase');
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
                  'Pick your display name',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'This is the name other people will see when you message them. You can change it later.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _controller,
                  autofocus: true,
                  maxLength: 26,
                  decoration: const InputDecoration(
                    hintText: 'Enter a display name',
                    counterText: '',
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
                                .add(DisplayNameSubmitted(_controller.text.trim())),
                        child: const Text('Continue'),
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
