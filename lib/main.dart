import 'package:flutter/material.dart';
import 'package:session_app/src/rust/frb_generated.dart';
import 'src/core/di/injection.dart';
import 'src/core/logging.dart';
import 'src/services/session_service.dart';
import 'app.dart';

const _tag = 'Main';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Log.i(_tag, 'Starting Alpin Session...');

  await RustLib.init();
  Log.i(_tag, 'Rust bridge initialized');

  await configureDependencies();
  Log.i(_tag, 'Dependencies configured');

  final sessionService = getIt<SessionService>();
  final hasAccount = await sessionService.hasAccount();
  Log.i(_tag, 'Has account: $hasAccount');

  if (hasAccount) {
    final sessionId = await sessionService.getSessionId();
    Log.i(_tag, 'Session ID: ${sessionId?.substring(0, 16)}...');
  }

  runApp(AlpinSessionApp(hasAccount: hasAccount));
}
