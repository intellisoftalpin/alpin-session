import 'package:get_it/get_it.dart';
import '../storage/database.dart';
import '../../services/session_service.dart';
import '../../services/key_service.dart';
import '../../services/message_service.dart';
import '../../rust/api/simple.dart' as rust;

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Initialise the Rust onion-routed network orchestrator once at start.
  // All snode RPCs leave the device onion-wrapped from here on.
  rust.initNetwork();

  getIt.registerLazySingleton<AppDatabase>(() => AppDatabase());
  getIt.registerLazySingleton<KeyService>(() => KeyService());
  getIt.registerLazySingleton<SessionService>(() => SessionService(getIt<KeyService>()));
  getIt.registerLazySingleton<MessageService>(
    () => MessageService(getIt<AppDatabase>(), getIt<KeyService>()),
  );
}
