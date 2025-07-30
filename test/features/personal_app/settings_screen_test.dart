import 'package:appoint/features/personal_app/ui/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'firebase_test_helper.dart';

void main() {
  setUpAll(() async {});

  group('SettingsScreen', () {
    testWidgets('shows settings text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: SettingsScreen()),
        ),
      );

      expect(find.text('Settings'), findsOneWidget);
    });
  });
}
