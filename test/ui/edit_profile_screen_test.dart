import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:appoint/features/profile/ui/edit_profile_screen.dart';
import '../fake_firebase_setup.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await initializeTestFirebase();

  group('EditProfileScreen bio field', () {
    testWidgets('shows live character count and enforces max length',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(home: EditProfileScreen()));

      final bioField = find.byType(TextFormField);
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
