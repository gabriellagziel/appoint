import 'package:appoint/services/auth_service.dart';
import 'package:appoint/widgets/social_account_conflict_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../firebase_test_helper.dart';
import '../test_service_factory.dart';

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  group('AuthService Social Account Conflict Tests', () {
    late AuthService authService;

    setUp(() {
      authService = TestServiceFactory.createMockAuthService();
    });

    group('isSocialAccountConflict', () {
      test('should return true for account-exists-with-different-credential',
          () {
        final exception = FirebaseAuthException(
          code: 'account-exists-with-different-credential',
          message: 'Test error',
        );
        expect(authService.isSocialAccountConflict(exception), true);
      });

      test('should return true for credential-already-in-use', () {
        final exception = FirebaseAuthException(
          code: 'credential-already-in-use',
          message: 'Test error',
        );
        expect(authService.isSocialAccountConflict(exception), true);
      });

      test('should return false for other error codes', () {
        final exception = FirebaseAuthException(
          code: 'user-not-found',
          message: 'Test error',
        );
        expect(authService.isSocialAccountConflict(exception), false);
      });
    });

    group('getConflictingEmail', () {
      test('should return email for account-exists-with-different-credential',
          () {
        final exception = FirebaseAuthException(
          code: 'account-exists-with-different-credential',
          message: 'Test error',
          email: 'test@example.com',
        );
        expect(authService.getConflictingEmail(exception), 'test@example.com');
      });

      test('should return null for other error codes', () {
        final exception = FirebaseAuthException(
          code: 'user-not-found',
          message: 'Test error',
        );
        expect(authService.getConflictingEmail(exception), isNull);
      });
    });

    group('handleSocialAccountConflict', () {
      testWidgets('should show dialog for social account conflict',
          (WidgetTester tester) async {
        final exception = FirebaseAuthException(
          code: 'account-exists-with-different-credential',
          message: 'Test error',
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () async {
                    await authService.handleSocialAccountConflict(
                      context,
                      exception,
                    );
                  },
                  child: const Text('Test Conflict'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Test Conflict'));
        await tester.pumpAndSettle();

        // Verify dialog is shown
        expect(find.byType(SocialAccountConflictDialog), findsOneWidget);
        expect(find.text('Account Already Exists'), findsOneWidget);
        expect(find.textContaining('test@example.com'), findsOneWidget);
      });

      testWidgets('should not show dialog for non-conflict errors',
          (WidgetTester tester) async {
        final exception = FirebaseAuthException(
          code: 'user-not-found',
          message: 'Test error',
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () async {
                    await authService.handleSocialAccountConflict(
                      context,
                      exception,
                    );
                  },
                  child: const Text('Test Non-Conflict'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Test Non-Conflict'));
        await tester.pumpAndSettle();

        // Verify dialog is not shown
        expect(find.byType(SocialAccountConflictDialog), findsNothing);
      });

      testWidgets(
          'should return correct result when user chooses link accounts',
          (WidgetTester tester) async {
        final exception = FirebaseAuthException(
          code: 'account-exists-with-different-credential',
          message: 'Test error',
          email: 'test@example.com',
        );

        String? result;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () async {
                    result = await authService.handleSocialAccountConflict(
                      context,
                      exception,
                    );
                  },
                  child: const Text('Test Link'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Test Link'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Link Accounts'));
        await tester.pumpAndSettle();

        expect(result, equals('link'));
      });

      testWidgets(
          'should return correct result when user chooses existing method',
          (WidgetTester tester) async {
        final exception = FirebaseAuthException(
          code: 'account-exists-with-different-credential',
          message: 'Test error',
          email: 'test@example.com',
        );

        String? result;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () async {
                    result = await authService.handleSocialAccountConflict(
                      context,
                      exception,
                    );
                  },
                  child: const Text('Test Existing'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Test Existing'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Sign in with existing method'));
        await tester.pumpAndSettle();

        expect(result, equals('existing'));
      });

      testWidgets('should return correct result when user cancels',
          (WidgetTester tester) async {
        final exception = FirebaseAuthException(
          code: 'account-exists-with-different-credential',
          message: 'Test error',
          email: 'test@example.com',
        );

        String? result;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () async {
                    result = await authService.handleSocialAccountConflict(
                      context,
                      exception,
                    );
                  },
                  child: const Text('Test Cancel'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Test Cancel'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        expect(result, equals('cancel'));
      });
    });
  });
}
