import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:appoint/widgets/social_account_conflict_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Test helper class that doesn't require Firebase initialization
class TestAuthService {
  /// Check if the error is a social account link conflict
  static bool isSocialAccountConflict(FirebaseAuthException e) =>
      e.code == 'account-exists-with-different-credential' ||
      e.code == 'credential-already-in-use';

  /// Get the email associated with the conflicting account
  static String? getConflictingEmail(FirebaseAuthException e) {
    if (e.code == 'account-exists-with-different-credential') {
      return e.email;
    }
    return null;
  }

  /// Get the credential that was used in the failed sign-in attempt
  static AuthCredential? getConflictingCredential(FirebaseAuthException e) {
    if (e.code == 'account-exists-with-different-credential') {
      return e.credential;
    }
    return null;
  }
}

void main() {
  group('Social Account Conflict Integration Tests', () {
    group('isSocialAccountConflict', () {
      test('should return true for account-exists-with-different-credential',
          () {
        final error = FirebaseAuthException(
          code: 'account-exists-with-different-credential',
          message: 'Test error',
          email: 'test@example.com',
        );

        expect(TestAuthService.isSocialAccountConflict(error), isTrue);
      });

      test('should return true for credential-already-in-use', () {
        final error = FirebaseAuthException(
          code: 'credential-already-in-use',
          message: 'Test error',
          email: 'test@example.com',
        );

        expect(TestAuthService.isSocialAccountConflict(error), isTrue);
      });

      test('should return false for other error codes', () {
        final error = FirebaseAuthException(
          code: 'user-not-found',
          message: 'Test error',
        );

        expect(TestAuthService.isSocialAccountConflict(error), isFalse);
      });
    });

    group('getConflictingEmail', () {
      test('should return email for account-exists-with-different-credential',
          () {
        final error = FirebaseAuthException(
          code: 'account-exists-with-different-credential',
          message: 'Test error',
          email: 'test@example.com',
        );

        expect(
          TestAuthService.getConflictingEmail(error),
          equals('test@example.com'),
        );
      });

      test('should return null for other error codes', () {
        final error = FirebaseAuthException(
          code: 'user-not-found',
          message: 'Test error',
          email: 'test@example.com',
        );

        expect(TestAuthService.getConflictingEmail(error), isNull);
      });
    });

    group('SocialAccountConflictDialog', () {
      testWidgets('should display correct title and message',
          (WidgetTester tester) async {
        final error = FirebaseAuthException(
          code: 'account-exists-with-different-credential',
          message: 'Test error',
          email: 'test@example.com',
        );

        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) =>
                        SocialAccountConflictDialog(error: error),
                  ),
                  child: const Text('Show Dialog'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        expect(find.text('Account Already Exists'), findsOneWidget);
        expect(find.textContaining('test@example.com'), findsOneWidget);
      });

      testWidgets('should display all three buttons',
          (WidgetTester tester) async {
        final error = FirebaseAuthException(
          code: 'account-exists-with-different-credential',
          message: 'Test error',
          email: 'test@example.com',
        );

        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) =>
                        SocialAccountConflictDialog(error: error),
                  ),
                  child: const Text('Show Dialog'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        expect(find.text('Cancel'), findsOneWidget);
        expect(find.text('Sign in with existing method'), findsOneWidget);
        expect(find.text('Link Accounts'), findsOneWidget);
      });

      testWidgets('should call onCancel when cancel button is pressed',
          (WidgetTester tester) async {
        final error = FirebaseAuthException(
          code: 'account-exists-with-different-credential',
          message: 'Test error',
          email: 'test@example.com',
        );

        var cancelCalled = false;

        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => SocialAccountConflictDialog(
                      error: error,
                      onCancel: () => cancelCalled = true,
                    ),
                  ),
                  child: const Text('Show Dialog'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        expect(cancelCalled, isTrue);
      });

      testWidgets(
          'should call onSignInWithExistingMethod when existing method button is pressed',
          (WidgetTester tester) async {
        final error = FirebaseAuthException(
          code: 'account-exists-with-different-credential',
          message: 'Test error',
          email: 'test@example.com',
        );

        var existingMethodCalled = false;

        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => SocialAccountConflictDialog(
                      error: error,
                      onSignInWithExistingMethod: () =>
                          existingMethodCalled = true,
                    ),
                  ),
                  child: const Text('Show Dialog'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Sign in with existing method'));
        await tester.pumpAndSettle();

        expect(existingMethodCalled, isTrue);
      });

      testWidgets(
          'should call onLinkAccounts when link accounts button is pressed',
          (WidgetTester tester) async {
        final error = FirebaseAuthException(
          code: 'account-exists-with-different-credential',
          message: 'Test error',
          email: 'test@example.com',
        );

        var linkAccountsCalled = false;

        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => SocialAccountConflictDialog(
                      error: error,
                      onLinkAccounts: () => linkAccountsCalled = true,
                    ),
                  ),
                  child: const Text('Show Dialog'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Link Accounts'));
        await tester.pumpAndSettle();

        expect(linkAccountsCalled, isTrue);
      });

      testWidgets('should handle missing email gracefully',
          (WidgetTester tester) async {
        final errorWithoutEmail = FirebaseAuthException(
          code: 'account-exists-with-different-credential',
          message: 'Test error',
        );

        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) =>
                        SocialAccountConflictDialog(error: errorWithoutEmail),
                  ),
                  child: const Text('Show Dialog'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        expect(find.textContaining('this email'), findsOneWidget);
      });
    });
  });
}
