import 'package:appoint/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  REDACTED_TOKEN.ensureInitialized();

  testWidgets('edit profile flow', (tester) async {
    await app.appMain();
    await tester.pumpAndSettle();

    expect(find.text('Welcome'), findsOneWidget);

    await tester.tap(find.text('My Profile'));
    await tester.pumpAndSettle();

    expect(find.text('Profile'), findsOneWidget);
    await tester.tap(find.text('Edit Profile'));
    await tester.pumpAndSettle();

    await tester.enterText(find.bySemanticsLabel('Name'), 'John Doe');
    await tester.enterText(find.bySemanticsLabel('Bio'), 'Hello');
    await tester.enterText(find.bySemanticsLabel('Location'), 'Earth');

    await tester.tap(find.text('Save Changes'));
    await tester.pumpAndSettle();

    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('Hello'), findsOneWidget);
  });

  testWidgets('referral copy flow', (tester) async {
    await app.appMain();
    await tester.pumpAndSettle();

    // Login screen should appear
    expect(find.text('Login'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextField, 'Email'),
      'test@example.com',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Password'),
      'password',
    );
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    // Navigate directly to onboarding
    navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.pushNamed('/ambassador-onboarding');
    await tester.pumpAndSettle();

    expect(find.text('Ambassador Onboarding'), findsOneWidget);

    // Verify referral elements
    expect(find.text('Copy Link'), findsOneWidget);
    await tester.tap(find.text('Copy Link'));
    await tester.pump();

    expect(find.text('Link copied to clipboard!'), findsOneWidget);
  });
}
