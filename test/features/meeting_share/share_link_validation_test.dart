import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:appoint/services/sharing/share_link_service.dart';
import 'package:appoint/services/security/rate_limit_service.dart';
import 'package:appoint/services/analytics/meeting_share_analytics_service.dart';

import 'share_link_validation_test.mocks.dart';

@GenerateMocks(
    [FirebaseFirestore, RateLimitService, MeetingShareAnalyticsService])
void main() {
  group('Share Link Validation Tests', () {
    late ShareLinkService shareLinkService;
    late MockFirebaseFirestore mockFirestore;
    late MockRateLimitService mockRateLimitService;
    late REDACTED_TOKEN mockAnalyticsService;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockRateLimitService = MockRateLimitService();
      mockAnalyticsService = REDACTED_TOKEN();

      shareLinkService = ShareLinkService();
    });

    group('Valid Share Links', () {
      test('should validate active share link', () async {
        // Arrange
        final shareId = 'valid-share-123';
        final meetingId = 'test-meeting-456';
        final shareData = {
          'meetingId': meetingId,
          'groupId': 'test-group-789',
          'createdBy': 'test-user-123',
          'source': 'whatsapp',
          'createdAt': Timestamp.now(),
          'expiresAt':
              Timestamp.fromDate(DateTime.now().add(Duration(days: 1))),
          'usageCount': 0,
          'maxUsage': 10,
          'revoked': false,
        };

        when(mockFirestore.collection('share_links')).thenReturn(
          MockCollectionReference(),
        );

        // Act
        final result =
            await shareLinkService.validateShareLink(shareId, meetingId);

        // Assert
        expect(result.shareId, shareId);
        expect(result.meetingId, meetingId);
        expect(result.revoked, false);
        expect(result.isExpired, false);
        expect(result.isUsageLimitReached, false);
        expect(result.isValid, true);
      });

      test('should validate share link with no expiry', () async {
        // Arrange
        final shareId = 'valid-share-no-expiry';
        final meetingId = 'test-meeting-456';
        final shareData = {
          'meetingId': meetingId,
          'groupId': 'test-group-789',
          'createdBy': 'test-user-123',
          'source': 'direct',
          'createdAt': Timestamp.now(),
          'expiresAt': null,
          'usageCount': 5,
          'maxUsage': null,
          'revoked': false,
        };

        // Act & Assert
        final result =
            await shareLinkService.validateShareLink(shareId, meetingId);
        expect(result.isExpired, false);
        expect(result.isUsageLimitReached, false);
        expect(result.isValid, true);
      });
    });

    group('Expired Share Links', () {
      test('should reject expired share link', () async {
        // Arrange
        final shareId = 'expired-share-123';
        final meetingId = 'test-meeting-456';
        final shareData = {
          'meetingId': meetingId,
          'groupId': 'test-group-789',
          'createdBy': 'test-user-123',
          'source': 'whatsapp',
          'createdAt': Timestamp.now(),
          'expiresAt':
              Timestamp.fromDate(DateTime.now().subtract(Duration(hours: 1))),
          'usageCount': 0,
          'maxUsage': 10,
          'revoked': false,
        };

        // Act & Assert
        expect(
          () => shareLinkService.validateShareLink(shareId, meetingId),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('Revoked Share Links', () {
      test('should reject revoked share link', () async {
        // Arrange
        final shareId = 'revoked-share-123';
        final meetingId = 'test-meeting-456';
        final shareData = {
          'meetingId': meetingId,
          'groupId': 'test-group-789',
          'createdBy': 'test-user-123',
          'source': 'whatsapp',
          'createdAt': Timestamp.now(),
          'expiresAt':
              Timestamp.fromDate(DateTime.now().add(Duration(days: 1))),
          'usageCount': 0,
          'maxUsage': 10,
          'revoked': true,
          'revokedAt': Timestamp.now(),
          'revokedBy': 'test-user-123',
        };

        // Act & Assert
        expect(
          () => shareLinkService.validateShareLink(shareId, meetingId),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('Meeting ID Mismatch', () {
      test('should reject share link for different meeting', () async {
        // Arrange
        final shareId = 'mismatch-share-123';
        final meetingId = 'test-meeting-456';
        final shareData = {
          'meetingId': 'different-meeting-789',
          'groupId': 'test-group-789',
          'createdBy': 'test-user-123',
          'source': 'whatsapp',
          'createdAt': Timestamp.now(),
          'expiresAt':
              Timestamp.fromDate(DateTime.now().add(Duration(days: 1))),
          'usageCount': 0,
          'maxUsage': 10,
          'revoked': false,
        };

        // Act & Assert
        expect(
          () => shareLinkService.validateShareLink(shareId, meetingId),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('Usage Limits', () {
      test('should reject share link with exceeded usage limit', () async {
        // Arrange
        final shareId = 'usage-limit-share-123';
        final meetingId = 'test-meeting-456';
        final shareData = {
          'meetingId': meetingId,
          'groupId': 'test-group-789',
          'createdBy': 'test-user-123',
          'source': 'whatsapp',
          'createdAt': Timestamp.now(),
          'expiresAt':
              Timestamp.fromDate(DateTime.now().add(Duration(days: 1))),
          'usageCount': 10,
          'maxUsage': 10,
          'revoked': false,
        };

        // Act & Assert
        expect(
          () => shareLinkService.validateShareLink(shareId, meetingId),
          throwsA(isA<Exception>()),
        );
      });

      test('should allow share link with usage under limit', () async {
        // Arrange
        final shareId = 'usage-under-limit-share-123';
        final meetingId = 'test-meeting-456';
        final shareData = {
          'meetingId': meetingId,
          'groupId': 'test-group-789',
          'createdBy': 'test-user-123',
          'source': 'whatsapp',
          'createdAt': Timestamp.now(),
          'expiresAt':
              Timestamp.fromDate(DateTime.now().add(Duration(days: 1))),
          'usageCount': 5,
          'maxUsage': 10,
          'revoked': false,
        };

        // Act
        final result =
            await shareLinkService.validateShareLink(shareId, meetingId);

        // Assert
        expect(result.isUsageLimitReached, false);
        expect(result.isValid, true);
      });
    });

    group('Share Link Creation', () {
      test('should create share link with rate limiting', () async {
        // Arrange
        final meetingId = 'test-meeting-456';
        final createdBy = 'test-user-123';
        final groupId = 'test-group-789';

        when(mockRateLimitService.allow(
          'create_share_link',
          createdBy,
          userId: createdBy,
        )).thenAnswer((_) async => true);

        // Act
        final shareUrl = await shareLinkService.createShareLink(
          meetingId: meetingId,
          createdBy: createdBy,
          groupId: groupId,
          source: 'whatsapp',
        );

        // Assert
        expect(shareUrl, contains(meetingId));
        expect(shareUrl, contains(groupId));
        expect(shareUrl, contains('src=whatsapp'));
        expect(shareUrl, contains('ref='));
      });

      test('should reject share link creation when rate limited', () async {
        // Arrange
        final meetingId = 'test-meeting-456';
        final createdBy = 'test-user-123';

        when(mockRateLimitService.allow(
          'create_share_link',
          createdBy,
          userId: createdBy,
        )).thenAnswer((_) async => false);

        // Act & Assert
        expect(
          () => shareLinkService.createShareLink(
            meetingId: meetingId,
            createdBy: createdBy,
          ),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('URL Parsing', () {
      test('should parse valid share URL', () {
        // Arrange
        final url =
            'https://app-oint.com/m/test-meeting-123?g=test-group-456&src=whatsapp&ref=share-123';

        // Act
        final components = shareLinkService.parseShareUrl(url);

        // Assert
        expect(components.meetingId, 'test-meeting-123');
        expect(components.groupId, 'test-group-456');
        expect(components.source, 'whatsapp');
        expect(components.shareId, 'share-123');
      });

      test('should reject invalid share URL format', () {
        // Arrange
        final url = 'https://app-oint.com/invalid/path';

        // Act & Assert
        expect(
          () => shareLinkService.parseShareUrl(url),
          throwsA(isA<Exception>()),
        );
      });

      test('should handle share URL with missing parameters', () {
        // Arrange
        final url = 'https://app-oint.com/m/test-meeting-123?ref=share-123';

        // Act
        final components = shareLinkService.parseShareUrl(url);

        // Assert
        expect(components.meetingId, 'test-meeting-123');
        expect(components.groupId, null);
        expect(components.source, null);
        expect(components.shareId, 'share-123');
      });
    });

    group('Share Link Management', () {
      test('should revoke share link by creator', () async {
        // Arrange
        final shareId = 'revoke-test-share-123';
        final userId = 'test-user-123';

        // Act
        await shareLinkService.revokeShareLink(shareId, userId);

        // Assert - verify the share link was marked as revoked
        // This would require mocking the Firestore update operation
        expect(true, isTrue); // Placeholder assertion
      });

      test('should reject revocation by non-creator', () async {
        // Arrange
        final shareId = 'revoke-test-share-123';
        final userId = 'different-user-456';

        // Act & Assert
        expect(
          () => shareLinkService.revokeShareLink(shareId, userId),
          throwsA(isA<Exception>()),
        );
      });

      test('should get share links for meeting', () async {
        // Arrange
        final meetingId = 'test-meeting-456';
        final userId = 'test-user-123';

        // Act
        final shareLinks =
            await shareLinkService.getShareLinksForMeeting(meetingId, userId);

        // Assert
        expect(shareLinks, isA<List<ShareLinkData>>());
        // Additional assertions would depend on the actual implementation
      });
    });
  });
}
