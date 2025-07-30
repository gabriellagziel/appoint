import 'package:appoint/features/family/ui/parental_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'firebase_test_helper.dart';

void main() {
  setUpAll(() async {});

  group('ParentalSettingsScreen', () {
    testWidgets('shows toggle and manage accounts button', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: ParentalSettingsScreen()),
      );

      expect(find.text('Restrict mature content'), findsOneWidget);
      expect(find.text('Manage Child Accounts'), findsOneWidget);
    });
  });
}
