import 'package:go_router/go_router.dart';
import '../../features/onboarding/screens/landing_screen.dart';
import '../../features/onboarding/screens/display_name_screen.dart';
import '../../features/onboarding/screens/recovery_phrase_screen.dart';
import '../../features/onboarding/screens/restore_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/home/screens/new_conversation_screen.dart';
import '../../features/conversation/screens/conversation_screen.dart';

class AppRouter {
  final bool hasAccount;

  AppRouter({required this.hasAccount});

  late final router = GoRouter(
    initialLocation: hasAccount ? '/home' : '/landing',
    routes: [
      GoRoute(
        path: '/landing',
        builder: (context, state) => const LandingScreen(),
      ),
      GoRoute(
        path: '/display-name',
        builder: (context, state) => const DisplayNameScreen(),
      ),
      GoRoute(
        path: '/recovery-phrase',
        builder: (context, state) => const RecoveryPhraseScreen(),
      ),
      GoRoute(
        path: '/restore',
        builder: (context, state) => const RestoreScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/new-conversation',
        builder: (context, state) => const NewConversationScreen(),
      ),
      GoRoute(
        path: '/conversation/:threadId',
        builder: (context, state) {
          final threadId = state.pathParameters['threadId']!;
          final displayName = state.extra as String?;
          return ConversationScreen(
            threadId: threadId,
            displayName: displayName,
          );
        },
      ),
    ],
  );
}
