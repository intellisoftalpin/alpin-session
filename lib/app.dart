import 'package:flutter/material.dart';
import 'src/core/theme/alpin_theme.dart';
import 'src/core/router/app_router.dart';

class AlpinSessionApp extends StatelessWidget {
  final bool hasAccount;

  const AlpinSessionApp({super.key, required this.hasAccount});

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter(hasAccount: hasAccount);
    return MaterialApp.router(
      title: 'Alpin Session',
      debugShowCheckedModeBanner: false,
      theme: AlpinTheme.light(),
      darkTheme: AlpinTheme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: appRouter.router,
    );
  }
}
