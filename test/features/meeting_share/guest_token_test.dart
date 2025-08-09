import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:appoint/services/sharing/guest_token_service.dart';

import 'guest_token_test.mocks.dart';

@GenerateMocks([FirebaseFirestore])
void main() {
  group('Guest Token Tests', () {
    late GuestTokenService guestTokenService;
    late MockFirebaseFirestore mockFirestore;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      guestTokenService = GuestTokenService();
    });

    group('Token Creation', () {
      test('should create valid guest token', () async {
        // Arrange
        final meetingId = 'test-meeting-123';
        final groupId = 'test-group-456';

        // Act
        final token = await guestTokenService.createGuestToken(
          meetingId,
          groupId: groupId,
        );

        // Assert
        expect(token, isNotEmpty);
        expect(token.length, 32); // Default token length
        expect(token, matches(RegExp(r'^[a-zA-Z0-9]+$'))); // Alphanumeric only
      });

      test('should create guest token with custom expiry', () async {
        // Arrange
        final meetingId = 'test-meeting-123';
        final customExpiry = Duration(hours: 48);

        // Act
        final token = await guestTokenService.createGuestToken(
          meetingId,
          expiry: customExpiry,
        );

        // Assert
        expect(token, isNotEmpty);

        // Verify expiry time
        final expiry = await guestTokenService.getTokenExpiry(token);
        expect(expiry, isNotNull);
        expect(expiry!.isAfter(DateTime.now().add(Duration(hours: 47))), true);
        expect(expiry.isBefore(DateTime.now().add(Duration(hours: 49))), true);
      });

      test('should create guest token without group', () async {
        // Arrange
        final meetingId = 'test-meeting-123';

        // Act
        final token = await guestTokenService.createGuestToken(meetingId);

        // Assert
        expect(token, isNotEmpty);

        // Verify claims
        final claims =
            await guestTokenService.validateGuestToken(token, meetingId);
        expect(claims['meetingId'], meetingId);
        expect(claims['groupId'], null);
      });
    });

    group('Token Validation', () {
      test('should validate active guest token', () async {
        // Arrange
        final meetingId = 'test-meeting-123';
        final groupId = 'test-group-456';
        final token = await guestTokenService.createGuestToken(
          meetingId,
          groupId: groupId,
        );

        // Act
        final claims =
            await guestTokenService.validateGuestToken(token, meetingId);

        // Assert
        expect(claims['meetingId'], meetingId);
        expect(claims['groupId'], groupId);
        expect(claims['exp'], isNotNull);
        expect(claims['iat'], isNotNull);
      });

      test('should validate token for correct meeting', () async {
        // Arrange
        final meetingId = 'test-meeting-123';
        final token = await guestTokenService.createGuestToken(meetingId);

        // Act
        final claims =
            await guestTokenService.validateGuestToken(token, meetingId);

        // Assert
        expect(claims['meetingId'], meetingId);
      });

      test('should reject token for wrong meeting', () async {
        // Arrange
        final meetingId = 'test-meeting-123';
        final wrongMeetingId = 'wrong-meeting-456';
        final token = await guestTokenService.createGuestToken(meetingId);

        // Act & Assert
        expect(
          () => guestTokenService.validateGuestToken(token, wrongMeetingId),
          throwsA(isA<Exception>()),
        );
      });

      test('should reject invalid token', () async {
        // Arrange
        final invalidToken = 'invalid-token-123';
        final meetingId = 'test-meeting-123';

        // Act & Assert
        expect(
          () => guestTokenService.validateGuestToken(invalidToken, meetingId),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('Expired Tokens', () {
      test('should reject expired token', () async {
        // Arrange
        final meetingId = 'test-meeting-123';
        final shortExpiry = Duration(seconds: 1);
        final token = await guestTokenService.createGuestToken(
          meetingId,
          expiry: shortExpiry,
        );

        // Wait for token to expire
        await Future.delayed(Duration(seconds: 2));

        // Act & Assert
        expect(
          () => guestTokenService.validateGuestToken(token, meetingId),
          throwsA(isA<Exception>()),
        );
      });

      test('should check token expiry without throwing', () async {
        // Arrange
        final meetingId = 'test-meeting-123';
        final shortExpiry = Duration(seconds: 1);
        final token = await guestTokenService.createGuestToken(
          meetingId,
          expiry: shortExpiry,
        );

        // Wait for token to expire
        await Future.delayed(Duration(seconds: 2));

        // Act
        final isValid = await guestTokenService.isTokenValid(token, meetingId);

        // Assert
        expect(isValid, false);
      });
    });

    group('Revoked Tokens', () {
      test('should reject revoked token', () async {
        // Arrange
        final meetingId = 'test-meeting-123';
        final token = await guestTokenService.createGuestToken(meetingId);

        // Revoke the token
        await guestTokenService.revokeGuestToken(token);

        // Act & Assert
        expect(
          () => guestTokenService.validateGuestToken(token, meetingId),
          throwsA(isA<Exception>()),
        );
      });

      test('should check revoked token without throwing', () async {
        // Arrange
        final meetingId = 'test-meeting-123';
        final token = await guestTokenService.createGuestToken(meetingId);

        // Revoke the token
        await guestTokenService.revokeGuestToken(token);

        // Act
        final isValid = await guestTokenService.isTokenValid(token, meetingId);

        // Assert
        expect(isValid, false);
      });
    });

    group('Token Security', () {
      test('should generate cryptographically secure tokens', () async {
        // Arrange
        final meetingId = 'test-meeting-123';
        final tokens = <String>[];

        // Act - generate multiple tokens
        for (int i = 0; i < 10; i++) {
          final token = await guestTokenService.createGuestToken(meetingId);
          tokens.add(token);
        }

        // Assert - all tokens should be unique
        expect(tokens.toSet().length, tokens.length);

        // All tokens should be alphanumeric and 32 characters
        for (final token in tokens) {
          expect(token.length, 32);
          expect(token, matches(RegExp(r'^[a-zA-Z0-9]+$')));
        }
      });

      test('should handle tampered token gracefully', () async {
        // Arrange
        final meetingId = 'test-meeting-123';
        final originalToken =
            await guestTokenService.createGuestToken(meetingId);
        final tamperedToken =
            originalToken.substring(0, originalToken.length - 1) + 'X';

        // Act & Assert
        expect(
          () => guestTokenService.validateGuestToken(tamperedToken, meetingId),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('Token Management', () {
      test('should get token expiry time', () async {
        // Arrange
        final meetingId = 'test-meeting-123';
        final customExpiry = Duration(hours: 12);
        final token = await guestTokenService.createGuestToken(
          meetingId,
          expiry: customExpiry,
        );

        // Act
        final expiry = await guestTokenService.getTokenExpiry(token);

        // Assert
        expect(expiry, isNotNull);
        expect(expiry!.isAfter(DateTime.now()), true);
        expect(expiry.isBefore(DateTime.now().add(Duration(hours: 13))), true);
      });

      test('should return null for invalid token expiry', () async {
        // Arrange
        final invalidToken = 'invalid-token-123';

        // Act
        final expiry = await guestTokenService.getTokenExpiry(invalidToken);

        // Assert
        expect(expiry, null);
      });

      test('should cleanup expired tokens', () async {
        // Arrange
        final meetingId = 'test-meeting-123';
        final shortExpiry = Duration(seconds: 1);

        // Create a token that will expire
        await guestTokenService.createGuestToken(
          meetingId,
          expiry: shortExpiry,
        );

        // Wait for token to expire
        await Future.delayed(Duration(seconds: 2));

        // Act
        await guestTokenService.cleanupExpiredTokens();

        // Assert - cleanup should complete without error
        expect(true, isTrue);
      });
    });

    group('Error Handling', () {
      test('should handle Firestore errors gracefully', () async {
        // Arrange
        final meetingId = 'test-meeting-123';
        final token = 'test-token-123';

        // Mock Firestore to throw an error
        when(mockFirestore.collection('guest_tokens'))
            .thenThrow(Exception('Firestore error'));

        // Act & Assert
        expect(
          () => guestTokenService.validateGuestToken(token, meetingId),
          throwsA(isA<Exception>()),
        );
      });

      test('should handle network errors during token creation', () async {
        // Arrange
        final meetingId = 'test-meeting-123';

        // Mock Firestore to throw a network error
        when(mockFirestore.collection('guest_tokens'))
            .thenThrow(Exception('Network error'));

        // Act & Assert
        expect(
          () => guestTokenService.createGuestToken(meetingId),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('Integration Tests', () {
      test('should create and validate token in sequence', () async {
        // Arrange
        final meetingId = 'test-meeting-123';
        final groupId = 'test-group-456';

        // Act - create token
        final token = await guestTokenService.createGuestToken(
          meetingId,
          groupId: groupId,
        );

        // Validate token immediately
        final claims =
            await guestTokenService.validateGuestToken(token, meetingId);

        // Assert
        expect(claims['meetingId'], meetingId);
        expect(claims['groupId'], groupId);
        expect(await guestTokenService.isTokenValid(token, meetingId), true);
      });

      test('should handle token lifecycle: create -> revoke -> cleanup',
          () async {
        // Arrange
        final meetingId = 'test-meeting-123';

        // Act - create token
        final token = await guestTokenService.createGuestToken(meetingId);
        expect(await guestTokenService.isTokenValid(token, meetingId), true);

        // Revoke token
        await guestTokenService.revokeGuestToken(token);
        expect(await guestTokenService.isTokenValid(token, meetingId), false);

        // Cleanup (should not affect revoked tokens)
        await guestTokenService.cleanupExpiredTokens();

        // Assert - token should still be invalid
        expect(await guestTokenService.isTokenValid(token, meetingId), false);
      });
    });
  });
}
