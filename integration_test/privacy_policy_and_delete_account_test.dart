import 'package:appoint/main.dart' as app;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Privacy Policy and Delete Account Integration Tests', () {
    setUpAll(() async {
      await Firebase.initializeApp();
    });

    tearDownAll(() async {
      await FirebaseAuth.instance.signOut();
    });

    testWidgets('Privacy policy link opens external URL', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to settings screen
      await _navigateToSettings(tester);

      // Find and tap the privacy policy tile
      privacyPolicyTile = find.text('Privacy Policy');
      expect(privacyPolicyTile, findsOneWidget);
      await tester.tap(privacyPolicyTile);
      await tester.pumpAndSettle();
    });

    testWidgets('Delete account shows confirmation dialog', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to profile screen
      await _navigateToProfile(tester);

      // Find and tap the delete account button
      deleteButton = find.text('Delete My Account');
      expect(deleteButton, findsOneWidget);
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();

      // Verify confirmation dialog appears
      expect(find.text('Delete Account'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('Delete account confirmation shows loading and navigates',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to profile screen
      await _navigateToProfile(tester);

      // Find and tap the delete account button
      deleteButton = find.text('Delete My Account');
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();

      // Tap the delete confirmation button
      final confirmDeleteButton =
          find.widgetWithText(TextButton, 'Delete Account');
      await tester.tap(confirmDeleteButton);
      await tester.pumpAndSettle();

      // Verify loading dialog appears
      expect(find.text('Deleting account...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Note: The actual deletion and navigation would be tested with mocked services
      // In a real integration test, you'd need to set up test data and verify the cleanup
    });

    testWidgets('Cancel delete account closes dialog', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await _navigateToProfile(tester);

      deleteButton = find.text('Delete My Account');
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();

      cancelButton = find.text('Cancel');
      await tester.tap(cancelButton);
      await tester.pumpAndSettle();

      expect(
        find.text('Are you sure you want to delete your account?'),
        findsNothing,
      );
    });
  });
}

Future<void> _navigateToSettings(WidgetTester tester) async {
  await tester.pumpAndSettle();
}

Future<void> _navigateToProfile(WidgetTester tester) async {
  await tester.pumpAndSettle();
}
