import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:appoint/widgets/social_account_conflict_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import '../firebase_test_helper.dart';

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  group('SocialAccountConflictDialog', () {
    late FirebaseAuthException testError;

    setUp(() {
      testError = FirebaseAuthException(
        code: 'REDACTED_TOKEN',
        message: 'Test error',
        email: 'test@example.com',
      );
    });

    testWidgets('should display correct title and message',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
          ],
          locale: const Locale('en'),
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) =>
                      SocialAccountConflictDialog(error: testError),
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
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
          ],
          locale: const Locale('en'),
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) =>
                      SocialAccountConflictDialog(error: testError),
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
      var cancelCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
          ],
          locale: const Locale('en'),
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => SocialAccountConflictDialog(
                    error: testError,
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
      var existingMethodCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
          ],
          locale: const Locale('en'),
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => SocialAccountConflictDialog(
                    error: testError,
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
      var linkAccountsCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
          ],
          locale: const Locale('en'),
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => SocialAccountConflictDialog(
                    error: testError,
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
        code: 'REDACTED_TOKEN',
        message: 'Test error',
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
          ],
          locale: const Locale('en'),
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
}
