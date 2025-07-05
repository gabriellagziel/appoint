import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mocktail/mocktail.dart';
import 'package:appoint/services/auth_service.dart';
import '../test_setup.dart';

class MockAuthCredential extends Mock implements AuthCredential {}

void main() {
  setupFirebaseMocks();

  group('AuthService', () {
    late AuthService authService;

    setUp(() {
      authService = AuthService();
    });

    group('Social Account Conflict Detection', () {
      test('should detect account-exists-with-different-credential as conflict',
          () {
        final exception = FirebaseAuthException(
          code: 'account-exists-with-different-credential',
          message: 'Test error',
        );
        expect(authService.isSocialAccountConflict(exception), isTrue);
      });

      test('should detect credential-already-in-use as conflict', () {
        final exception = FirebaseAuthException(
          code: 'credential-already-in-use',
          message: 'Test error',
        );
        expect(authService.isSocialAccountConflict(exception), isTrue);
      });

      test('should not detect user-not-found as conflict', () {
        final exception = FirebaseAuthException(
          code: 'user-not-found',
          message: 'Test error',
        );
        expect(authService.isSocialAccountConflict(exception), isFalse);
      });
    });

    group('Conflicting Email Extraction', () {
      test(
          'should extract email from account-exists-with-different-credential error',
          () {
        final exception = FirebaseAuthException(
          code: 'account-exists-with-different-credential',
          message: 'Test error',
          email: 'test@example.com',
        );
        expect(authService.getConflictingEmail(exception),
            equals('test@example.com'));
      });

      test('should return null for non-conflict errors', () {
        final exception = FirebaseAuthException(
          code: 'user-not-found',
          message: 'Test error',
          email: 'test@example.com',
        );
        expect(authService.getConflictingEmail(exception), isNull);
      });
    });

    group('Conflicting Credential Extraction', () {
      test(
          'should extract credential from account-exists-with-different-credential error',
          () {
        final mockCredential = MockAuthCredential();
        final exception = FirebaseAuthException(
          code: 'account-exists-with-different-credential',
          message: 'Test error',
          credential: mockCredential,
        );
        expect(authService.getConflictingCredential(exception),
            equals(mockCredential));
      });

      test('should return null for non-conflict errors', () {
        final mockCredential = MockAuthCredential();
        final exception = FirebaseAuthException(
          code: 'user-not-found',
          message: 'Test error',
          credential: mockCredential,
        );
        expect(authService.getConflictingCredential(exception), isNull);
      });
    });
  });
}
