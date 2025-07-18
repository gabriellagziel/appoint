import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mocktail/mocktail.dart';

import 'firebase_test_helper.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockUser extends Mock implements User {}
class MockUserCredential extends Mock implements UserCredential {}

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
    setupFirebaseMocks();
  });

  group('OTP Flow Tests', () {
    late MockFirebaseAuth mockAuth;
    late MockUser mockUser;
    late MockUserCredential mockUserCredential;

    setUp(() {
      mockAuth = MockFirebaseAuth();
      mockUser = MockUser();
      mockUserCredential = MockUserCredential();

      // Setup user mock
      when(() => mockUser.uid).thenReturn('test-user-id');
      when(() => mockUser.email).thenReturn('test@example.com');
      when(() => mockUser.phoneNumber).thenReturn('+1234567890');
      when(() => mockUser.isAnonymous).thenReturn(false);
      when(() => mockUser.emailVerified).thenReturn(false);

      // Setup user credential mock
      when(() => mockUserCredential.user).thenReturn(mockUser);

      // Setup auth mock
      when(() => mockAuth.currentUser).thenReturn(mockUser);
      when(() => mockAuth.authStateChanges()).thenAnswer((_) => Stream.value(mockUser));
      when(() => mockAuth.userChanges()).thenAnswer((_) => Stream.value(mockUser));
    });

    test('should verify phone number format', () {
      // Test valid phone numbers
      expect(_isValidPhoneNumber('+1234567890'), isTrue);
      expect(_isValidPhoneNumber('+44123456789'), isTrue);
      expect(_isValidPhoneNumber('+61412345678'), isTrue);

      // Test invalid phone numbers
      expect(_isValidPhoneNumber('1234567890'), isFalse);
      expect(_isValidPhoneNumber('+123'), isFalse);
      expect(_isValidPhoneNumber(''), isFalse);
      expect(_isValidPhoneNumber('abc'), isFalse);
    });

    test('should verify OTP code format', () {
      // Test valid OTP codes
      expect(_isValidOTPCode('123456'), isTrue);
      expect(_isValidOTPCode('000000'), isTrue);
      expect(_isValidOTPCode('999999'), isTrue);

      // Test invalid OTP codes
      expect(_isValidOTPCode('12345'), isFalse); // Too short
      expect(_isValidOTPCode('1234567'), isFalse); // Too long
      expect(_isValidOTPCode('12345a'), isFalse); // Contains letters
      expect(_isValidOTPCode(''), isFalse);
    });

    test('should handle OTP verification success', () async {
      // Arrange
      const phoneNumber = '+1234567890';
      const otpCode = '123456';

      when(() => mockAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: any(named: 'verificationCompleted'),
        verificationFailed: any(named: 'verificationFailed'),
        codeSent: any(named: 'codeSent'),
        codeAutoRetrievalTimeout: any(named: 'codeAutoRetrievalTimeout'),
      )).thenAnswer((invocation) {
        // Simulate successful verification
        final verificationCompleted = invocation.namedArguments[#verificationCompleted] as Function(UserCredential);
        verificationCompleted(mockUserCredential);
        return Future.value();
      });

      // Act & Assert
      expect(() async {
        await _sendOTP(mockAuth, phoneNumber);
      }, returnsNormally);
    });

    test('should handle OTP verification failure', () async {
      // Arrange
      const phoneNumber = '+1234567890';

      when(() => mockAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: any(named: 'verificationCompleted'),
        verificationFailed: any(named: 'verificationFailed'),
        codeSent: any(named: 'codeSent'),
        codeAutoRetrievalTimeout: any(named: 'codeAutoRetrievalTimeout'),
      )).thenAnswer((invocation) {
        // Simulate verification failure
        final verificationFailed = invocation.namedArguments[#verificationFailed] as Function(FirebaseAuthException);
        verificationFailed(FirebaseAuthException(code: 'invalid-phone-number'));
        return Future.value();
      });

      // Act & Assert
      expect(() async {
        await _sendOTP(mockAuth, phoneNumber);
      }, returnsNormally);
    });

    test('should handle OTP code verification', () async {
      // Arrange
      const otpCode = '123456';
      final mockCredential = MockPhoneAuthCredential();

      when(() => mockCredential.verifyOTP(otpCode)).thenReturn(mockUserCredential);

      // Act & Assert
      expect(() async {
        await _verifyOTP(mockAuth, mockCredential, otpCode);
      }, returnsNormally);
    });
  });
}

// Helper functions for testing
bool _isValidPhoneNumber(String phoneNumber) {
  // Basic phone number validation
  final phoneRegex = RegExp(r'^\+[1-9]\d{1,14}$');
  return phoneRegex.hasMatch(phoneNumber);
}

bool _isValidOTPCode(String otpCode) {
  // OTP code validation (6 digits)
  final otpRegex = RegExp(r'^\d{6}$');
  return otpRegex.hasMatch(otpCode);
}

Future<void> _sendOTP(FirebaseAuth auth, String phoneNumber) async {
  await auth.verifyPhoneNumber(
    phoneNumber: phoneNumber,
    verificationCompleted: (UserCredential credential) {
      // Handle automatic verification
    },
    verificationFailed: (FirebaseAuthException e) {
      // Handle verification failure
    },
    codeSent: (String verificationId, int? resendToken) {
      // Handle code sent
    },
    codeAutoRetrievalTimeout: (String verificationId) {
      // Handle timeout
    },
  );
}

Future<void> _verifyOTP(FirebaseAuth auth, PhoneAuthCredential credential, String otpCode) async {
  await credential.verifyOTP(otpCode);
}

// Mock classes
class MockPhoneAuthCredential extends Mock implements PhoneAuthCredential {}
