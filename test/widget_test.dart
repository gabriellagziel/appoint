import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'fake_firebase_setup.dart';

// Minimal smoke test for the app.

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await initializeTestFirebase();

  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Text('Business Dashboard'),
      ),
    );
    expect(find.text('Business Dashboard'), findsOneWidget);
  });
}
