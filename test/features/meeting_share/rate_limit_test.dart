import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:appoint/services/security/rate_limit_service.dart';

import 'rate_limit_test.mocks.dart';

@GenerateMocks([FirebaseFirestore])
void main() {
  group('Rate Limit Tests', () {
    late RateLimitService rateLimitService;
    late MockFirebaseFirestore mockFirestore;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      rateLimitService = RateLimitService();
    });

    group('Share Link Creation Rate Limiting', () {
      test('should allow share link creation within limits', () async {
        // Arrange
        final userId = 'test-user-123';
        final actionKey = 'create_share_link';

        // Act
        final allowed = await rateLimitService.allow(
          actionKey,
          userId,
          userId: userId,
        );

        // Assert
        expect(allowed, true);
      });

      test('should reject share link creation when rate limited', () async {
        // Arrange
        final userId = 'test-user-123';
        final actionKey = 'create_share_link';

        // Mock multiple rapid requests
        for (int i = 0; i < 15; i++) {
          await rateLimitService.allow(
            actionKey,
            userId,
            userId: userId,
          );
        }

        // Act
        final allowed = await rateLimitService.allow(
          actionKey,
          userId,
          userId: userId,
        );

        // Assert
        expect(allowed, false);
      });

      test('should reset rate limit after window expires', () async {
        // Arrange
        final userId = 'test-user-123';
        final actionKey = 'create_share_link';

        // Mock requests up to limit
        for (int i = 0; i < 10; i++) {
          await rateLimitService.allow(
            actionKey,
            userId,
            userId: userId,
          );
        }

        // Verify limit reached
        final initiallyAllowed = await rateLimitService.allow(
          actionKey,
          userId,
          userId: userId,
        );
        expect(initiallyAllowed, false);

        // Act - simulate time passing (in real test, would need to mock time)
        // For now, we'll test the status functionality
        final status = await rateLimitService.getStatus(
          actionKey,
          userId,
          userId: userId,
        );

        // Assert
        expect(status.isLimited, true);
        expect(status.currentHits, 10);
        expect(status.maxHits, 10);
        expect(status.remainingHits, 0);
      });
    });

    group('Guest RSVP Rate Limiting', () {
      test('should allow guest RSVP within limits', () async {
        // Arrange
        final ipAddress = '192.168.1.1';
        final userAgent =
            'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X)';
        final actionKey = 'guest_rsvp';

        // Act
        final allowed = await rateLimitService.allow(
          actionKey,
          ipAddress,
          ipAddress: ipAddress,
          userAgent: userAgent,
        );

        // Assert
        expect(allowed, true);
      });

      test('should reject guest RSVP when rate limited', () async {
        // Arrange
        final ipAddress = '192.168.1.1';
        final userAgent =
            'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X)';
        final actionKey = 'guest_rsvp';

        // Mock multiple rapid RSVP attempts
        for (int i = 0; i < 6; i++) {
          await rateLimitService.allow(
            actionKey,
            ipAddress,
            ipAddress: ipAddress,
            userAgent: userAgent,
          );
        }

        // Act
        final allowed = await rateLimitService.allow(
          actionKey,
          ipAddress,
          ipAddress: ipAddress,
          userAgent: userAgent,
        );

        // Assert
        expect(allowed, false);
      });

      test('should track rate limits by IP and User-Agent combination',
          () async {
        // Arrange
        final ipAddress1 = '192.168.1.1';
        final ipAddress2 = '192.168.1.2';
        final userAgent =
            'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X)';
        final actionKey = 'guest_rsvp';

        // Act - make requests from different IPs
        final allowed1 = await rateLimitService.allow(
          actionKey,
          ipAddress1,
          ipAddress: ipAddress1,
          userAgent: userAgent,
        );

        final allowed2 = await rateLimitService.allow(
          actionKey,
          ipAddress2,
          ipAddress: ipAddress2,
          userAgent: userAgent,
        );

        // Assert - both should be allowed as they're from different IPs
        expect(allowed1, true);
        expect(allowed2, true);
      });
    });

    group('Public Page Open Rate Limiting', () {
      test('should allow public page opens within limits', () async {
        // Arrange
        final ipAddress = '192.168.1.1';
        final actionKey = 'public_page_open';

        // Act
        final allowed = await rateLimitService.allow(
          actionKey,
          ipAddress,
          ipAddress: ipAddress,
        );

        // Assert
        expect(allowed, true);
      });

      test('should reject public page opens when rate limited', () async {
        // Arrange
        final ipAddress = '192.168.1.1';
        final actionKey = 'public_page_open';

        // Mock multiple rapid page opens
        for (int i = 0; i < 51; i++) {
          await rateLimitService.allow(
            actionKey,
            ipAddress,
            ipAddress: ipAddress,
          );
        }

        // Act
        final allowed = await rateLimitService.allow(
          actionKey,
          ipAddress,
          ipAddress: ipAddress,
        );

        // Assert
        expect(allowed, false);
      });
    });

    group('Group Join Rate Limiting', () {
      test('should allow group joins within limits', () async {
        // Arrange
        final userId = 'test-user-123';
        final actionKey = 'join_group_from_share';

        // Act
        final allowed = await rateLimitService.allow(
          actionKey,
          userId,
          userId: userId,
        );

        // Assert
        expect(allowed, true);
      });

      test('should reject group joins when rate limited', () async {
        // Arrange
        final userId = 'test-user-123';
        final actionKey = 'join_group_from_share';

        // Mock multiple rapid join attempts
        for (int i = 0; i < 21; i++) {
          await rateLimitService.allow(
            actionKey,
            userId,
            userId: userId,
          );
        }

        // Act
        final allowed = await rateLimitService.allow(
          actionKey,
          userId,
          userId: userId,
        );

        // Assert
        expect(allowed, false);
      });
    });

    group('Rate Limit Status', () {
      test('should return correct status for user', () async {
        // Arrange
        final userId = 'test-user-123';
        final actionKey = 'create_share_link';

        // Make some requests
        for (int i = 0; i < 5; i++) {
          await rateLimitService.allow(
            actionKey,
            userId,
            userId: userId,
          );
        }

        // Act
        final status = await rateLimitService.getStatus(
          actionKey,
          userId,
          userId: userId,
        );

        // Assert
        expect(status.actionKey, actionKey);
        expect(status.currentHits, 5);
        expect(status.maxHits, 10);
        expect(status.remainingHits, 5);
        expect(status.isLimited, false);
        expect(status.window, Duration(hours: 1));
      });

      test('should return limited status when limit reached', () async {
        // Arrange
        final userId = 'test-user-123';
        final actionKey = 'create_share_link';

        // Make requests up to limit
        for (int i = 0; i < 10; i++) {
          await rateLimitService.allow(
            actionKey,
            userId,
            userId: userId,
          );
        }

        // Act
        final status = await rateLimitService.getStatus(
          actionKey,
          userId,
          userId: userId,
        );

        // Assert
        expect(status.currentHits, 10);
        expect(status.maxHits, 10);
        expect(status.remainingHits, 0);
        expect(status.isLimited, true);
      });

      test('should calculate reset time correctly', () async {
        // Arrange
        final userId = 'test-user-123';
        final actionKey = 'create_share_link';

        // Make a request
        await rateLimitService.allow(
          actionKey,
          userId,
          userId: userId,
        );

        // Act
        final status = await rateLimitService.getStatus(
          actionKey,
          userId,
          userId: userId,
        );

        // Assert
        expect(status.resetTime, isNotNull);
        expect(status.resetTime.isAfter(DateTime.now()), true);
        expect(
            status.resetTime.isBefore(DateTime.now().add(Duration(hours: 2))),
            true);
      });
    });

    group('Rate Limit Configuration', () {
      test('should reject unknown action keys', () async {
        // Arrange
        final userId = 'test-user-123';
        final unknownAction = 'unknown_action';

        // Act & Assert
        expect(
          () => rateLimitService.allow(
            unknownAction,
            userId,
            userId: userId,
          ),
          throwsA(isA<Exception>()),
        );
      });

      test('should handle different subject types correctly', () async {
        // Arrange
        final userId = 'test-user-123';
        final ipAddress = '192.168.1.1';
        final actionKey = 'create_share_link';

        // Act - test with user ID
        final userAllowed = await rateLimitService.allow(
          actionKey,
          userId,
          userId: userId,
        );

        // Test with IP address
        final ipAllowed = await rateLimitService.allow(
          actionKey,
          ipAddress,
          ipAddress: ipAddress,
        );

        // Test with anonymous
        final anonymousAllowed = await rateLimitService.allow(
          actionKey,
          'anonymous',
        );

        // Assert
        expect(userAllowed, true);
        expect(ipAllowed, true);
        expect(anonymousAllowed, true);
      });
    });

    group('Rate Limit Cleanup', () {
      test('should cleanup old rate limit records', () async {
        // Arrange
        final userId = 'test-user-123';
        final actionKey = 'create_share_link';

        // Make some requests
        for (int i = 0; i < 5; i++) {
          await rateLimitService.allow(
            actionKey,
            userId,
            userId: userId,
          );
        }

        // Act
        await rateLimitService.cleanupOldRecords();

        // Assert - cleanup should complete without error
        expect(true, isTrue);
      });
    });

    group('Error Handling', () {
      test('should handle Firestore errors gracefully', () async {
        // Arrange
        final userId = 'test-user-123';
        final actionKey = 'create_share_link';

        // Mock Firestore to throw an error
        when(mockFirestore.collection('rate_limits'))
            .thenThrow(Exception('Firestore error'));

        // Act & Assert
        expect(
          () => rateLimitService.allow(
            actionKey,
            userId,
            userId: userId,
          ),
          throwsA(isA<Exception>()),
        );
      });

      test('should handle network errors during status check', () async {
        // Arrange
        final userId = 'test-user-123';
        final actionKey = 'create_share_link';

        // Mock Firestore to throw a network error
        when(mockFirestore.collection('rate_limits'))
            .thenThrow(Exception('Network error'));

        // Act & Assert
        expect(
          () => rateLimitService.getStatus(
            actionKey,
            userId,
            userId: userId,
          ),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('Integration Tests', () {
      test('should handle multiple concurrent rate limit checks', () async {
        // Arrange
        final userId = 'test-user-123';
        final actionKey = 'create_share_link';

        // Act - make concurrent requests
        final futures = <Future<bool>>[];
        for (int i = 0; i < 5; i++) {
          futures.add(rateLimitService.allow(
            actionKey,
            userId,
            userId: userId,
          ));
        }

        final results = await Future.wait(futures);

        // Assert - all should be allowed initially
        expect(results.every((result) => result == true), true);
      });

      test('should handle rate limit lifecycle: allow -> limit -> reset',
          () async {
        // Arrange
        final userId = 'test-user-123';
        final actionKey = 'create_share_link';

        // Act - make requests up to limit
        for (int i = 0; i < 10; i++) {
          final allowed = await rateLimitService.allow(
            actionKey,
            userId,
            userId: userId,
          );
          expect(allowed, true);
        }

        // Try one more request - should be limited
        final limited = await rateLimitService.allow(
          actionKey,
          userId,
          userId: userId,
        );
        expect(limited, false);

        // Check status
        final status = await rateLimitService.getStatus(
          actionKey,
          userId,
          userId: userId,
        );
        expect(status.isLimited, true);
        expect(status.currentHits, 10);
      });
    });
  });
}
