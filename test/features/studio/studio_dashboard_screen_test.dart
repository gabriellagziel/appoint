import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/features/studio/ui/studio_dashboard_screen.dart';
import '../../fake_firebase_setup.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await initializeTestFirebase();
  group('StudioDashboardScreen', () {
    testWidgets('shows welcome text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: StudioDashboardScreen(),
        ),
      );

      expect(find.text('Welcome to your studio'), findsOneWidget);
    });
  });
}
