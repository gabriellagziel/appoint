import 'package:appoint/features/personal_app/ui/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'firebase_test_helper.dart';

void main() {
  setUpAll(() async {});
  group('EditProfileScreen', () {
    testWidgets('renders form fields and save button', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: EditProfileScreen()));

      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text('Username'), findsOneWidget);
      expect(find.text('Bio'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
    });
  });
}
