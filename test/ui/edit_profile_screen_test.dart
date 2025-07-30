import 'package:appoint/features/profile/ui/edit_profile_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../firebase_test_helper.dart';

class MockFirebaseAnalytics extends Mock implements FirebaseAnalytics {}

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  group('EditProfileScreen bio field', () {
    testWidgets('shows live character count and enforces max length',
        (tester) async {
      await tester.pumpWidget(
        createTestAppWithFirebaseHandling(
          const MaterialApp(home: EditProfileScreen()),
        ),
      );

      await tester.pumpAndSettle();

      final bioField = find.byType(TextFormField);
      await tester.tap(bioField);
      await tester.enterText(bioField, 'a' * 10);
      await tester.pump();
      expect(find.text('10/150'), findsOneWidget);

      await tester.enterText(bioField, 'b' * 200);
      await tester.pump();

      final textField = tester.widget<TextFormField>(bioField);
      expect(textField.controller!.text.length, lessThanOrEqualTo(150));
      expect(find.text('150/150'), findsOneWidget);
    });
  });
}
