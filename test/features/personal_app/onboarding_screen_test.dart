import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/features/personal_app/onboarding_screen.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('OnboardingScreen', () {
    testWidgets('shows onboarding screen text', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: OnboardingScreen()));

      expect(find.text('Onboarding Screen'), findsOneWidget);
    });
  });
}
