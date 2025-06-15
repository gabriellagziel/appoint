import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:appoint/main.dart';
import 'package:appoint/firebase_options.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  });
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const AppointApp());
    expect(find.text('Business Dashboard'), findsOneWidget);
  });
}
