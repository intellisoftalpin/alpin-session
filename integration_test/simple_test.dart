import 'package:flutter_test/flutter_test.dart';
import 'package:session_app/app.dart';
import 'package:session_app/src/rust/frb_generated.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async => await RustLib.init());
  testWidgets('App launches to landing screen', (WidgetTester tester) async {
    await tester.pumpWidget(const AlpinSessionApp(hasAccount: false));
    expect(find.text('Alpin Session'), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);
  });
}
