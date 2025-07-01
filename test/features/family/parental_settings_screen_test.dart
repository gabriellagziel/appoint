import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/features/family/ui/parental_settings_screen.dart';
import '../../fake_firebase_setup.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await initializeTestFirebase();

  group('ParentalSettingsScreen', () {
    testWidgets('shows toggle and manage accounts button', (final tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: ParentalSettingsScreen()),
      );

      expect(find.text('Restrict mature content'), findsOneWidget);
      expect(find.text('Manage Child Accounts'), findsOneWidget);
    });
  });
}
