import 'package:appoint/features/family/ui/parental_consent_prompt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fake_firebase_setup.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await initializeTestFirebase();

  group('ParentalConsentPrompt', () {
    testWidgets('shows both consent buttons', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: ParentalConsentPrompt()));

      expect(find.text('I Consent'), findsOneWidget);
      expect(find.text('I Do Not Consent'), findsOneWidget);
    });
  });
}
