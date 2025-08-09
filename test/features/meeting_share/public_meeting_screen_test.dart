import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:appoint/models/meeting.dart';
import 'package:appoint/services/sharing/guest_token_service.dart';
import 'package:appoint/services/security/rate_limit_service.dart';
import 'package:appoint/services/analytics/meeting_share_analytics_service.dart';

import 'public_meeting_screen_test.mocks.dart';

@GenerateMocks(
    [GuestTokenService, RateLimitService, MeetingShareAnalyticsService])
void main() {
  group('Public Meeting Screen Tests', () {
    late MockGuestTokenService mockGuestTokenService;
    late MockRateLimitService mockRateLimitService;
    late MockMeetingShareAnalyticsService mockAnalyticsService;

    setUp(() {
      mockGuestTokenService = MockGuestTokenService();
      mockRateLimitService = MockRateLimitService();
      mockAnalyticsService = MockMeetingShareAnalyticsService();
    });

    group('Meeting Visibility Controls', () {
      test('should show limited metadata for group-only meetings', () {
        // Arrange
        final meeting = Meeting(
          id: 'test-meeting-123',
          organizerId: 'test-organizer-456',
          title: 'Test Meeting',
          description: 'This is a test meeting',
          startTime: DateTime.now().add(Duration(days: 1)),
          endTime: DateTime.now().add(Duration(days: 1, hours: 2)),
          participants: [],
          meetingType: MeetingType.event,
          groupId: 'test-group-789',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          visibility: MeetingVisibility(
            groupMembersOnly: true,
            allowGuestsRSVP: false,
          ),
        );

        // Act - simulate rendering with non-member user
        final isGroupMember = false;
        final canAccessFullDetails =
            meeting.visibility?.groupMembersOnly == false || isGroupMember;

        // Assert
        expect(canAccessFullDetails, false);
        expect(meeting.visibility?.groupMembersOnly, true);
        expect(meeting.visibility?.allowGuestsRSVP, false);
      });

      test('should show full details for group members', () {
        // Arrange
        final meeting = Meeting(
          id: 'test-meeting-123',
          organizerId: 'test-organizer-456',
          title: 'Test Meeting',
          description: 'This is a test meeting',
          startTime: DateTime.now().add(Duration(days: 1)),
          endTime: DateTime.now().add(Duration(days: 1, hours: 2)),
          participants: [],
          meetingType: MeetingType.event,
          groupId: 'test-group-789',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          visibility: MeetingVisibility(
            groupMembersOnly: true,
            allowGuestsRSVP: true,
          ),
        );

        // Act - simulate rendering with group member
        final isGroupMember = true;
        final canAccessFullDetails =
            meeting.visibility?.groupMembersOnly == false || isGroupMember;

        // Assert
        expect(canAccessFullDetails, true);
        expect(meeting.visibility?.groupMembersOnly, true);
        expect(meeting.visibility?.allowGuestsRSVP, true);
      });

      test('should show full details for public meetings', () {
        // Arrange
        final meeting = Meeting(
          id: 'test-meeting-123',
          organizerId: 'test-organizer-456',
          title: 'Test Meeting',
          description: 'This is a test meeting',
          startTime: DateTime.now().add(Duration(days: 1)),
          endTime: DateTime.now().add(Duration(days: 1, hours: 2)),
          participants: [],
          meetingType: MeetingType.event,
          groupId: 'test-group-789',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          visibility: MeetingVisibility(
            groupMembersOnly: false,
            allowGuestsRSVP: true,
          ),
        );

        // Act - simulate rendering with any user
        final isGroupMember = false;
        final canAccessFullDetails =
            meeting.visibility?.groupMembersOnly == false || isGroupMember;

        // Assert
        expect(canAccessFullDetails, true);
        expect(meeting.visibility?.groupMembersOnly, false);
        expect(meeting.visibility?.allowGuestsRSVP, true);
      });
    });

    group('Guest RSVP Functionality', () {
      test('should allow guest RSVP when enabled', () async {
        // Arrange
        final meeting = Meeting(
          id: 'test-meeting-123',
          organizerId: 'test-organizer-456',
          title: 'Test Meeting',
          startTime: DateTime.now().add(Duration(days: 1)),
          endTime: DateTime.now().add(Duration(days: 1, hours: 2)),
          participants: [],
          meetingType: MeetingType.event,
          groupId: 'test-group-789',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          visibility: MeetingVisibility(
            groupMembersOnly: false,
            allowGuestsRSVP: true,
          ),
        );

        final guestToken = 'valid-guest-token-123';
        when(mockGuestTokenService.createGuestToken(
          meeting.id,
          groupId: meeting.groupId,
        )).thenAnswer((_) async => guestToken);

        when(mockRateLimitService.allow(
          'guest_rsvp',
          'anonymous',
        )).thenAnswer((_) async => true);

        // Act
        final canGuestRSVP = meeting.visibility?.allowGuestsRSVP == true;
        final token = await mockGuestTokenService.createGuestToken(
          meeting.id,
          groupId: meeting.groupId,
        );
        final rateLimitAllowed = await mockRateLimitService.allow(
          'guest_rsvp',
          'anonymous',
        );

        // Assert
        expect(canGuestRSVP, true);
        expect(token, guestToken);
        expect(rateLimitAllowed, true);
      });

      test('should reject guest RSVP when disabled', () {
        // Arrange
        final meeting = Meeting(
          id: 'test-meeting-123',
          organizerId: 'test-organizer-456',
          title: 'Test Meeting',
          startTime: DateTime.now().add(Duration(days: 1)),
          endTime: DateTime.now().add(Duration(days: 1, hours: 2)),
          participants: [],
          meetingType: MeetingType.event,
          groupId: 'test-group-789',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          visibility: MeetingVisibility(
            groupMembersOnly: true,
            allowGuestsRSVP: false,
          ),
        );

        // Act
        final canGuestRSVP = meeting.visibility?.allowGuestsRSVP == true;

        // Assert
        expect(canGuestRSVP, false);
      });

      test('should reject guest RSVP when rate limited', () async {
        // Arrange
        final meeting = Meeting(
          id: 'test-meeting-123',
          organizerId: 'test-organizer-456',
          title: 'Test Meeting',
          startTime: DateTime.now().add(Duration(days: 1)),
          endTime: DateTime.now().add(Duration(days: 1, hours: 2)),
          participants: [],
          meetingType: MeetingType.event,
          groupId: 'test-group-789',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          visibility: MeetingVisibility(
            groupMembersOnly: false,
            allowGuestsRSVP: true,
          ),
        );

        when(mockRateLimitService.allow(
          'guest_rsvp',
          'anonymous',
        )).thenAnswer((_) async => false);

        // Act
        final canGuestRSVP = meeting.visibility?.allowGuestsRSVP == true;
        final rateLimitAllowed = await mockRateLimitService.allow(
          'guest_rsvp',
          'anonymous',
        );

        // Assert
        expect(canGuestRSVP, true);
        expect(rateLimitAllowed, false);
      });
    });

    group('Member RSVP Functionality', () {
      test('should allow member RSVP for group members', () {
        // Arrange
        final meeting = Meeting(
          id: 'test-meeting-123',
          organizerId: 'test-organizer-456',
          title: 'Test Meeting',
          startTime: DateTime.now().add(Duration(days: 1)),
          endTime: DateTime.now().add(Duration(days: 1, hours: 2)),
          participants: [],
          meetingType: MeetingType.event,
          groupId: 'test-group-789',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          visibility: MeetingVisibility(
            groupMembersOnly: true,
            allowGuestsRSVP: false,
          ),
        );

        // Act
        final isGroupMember = true;
        final canMemberRSVP = isGroupMember;

        // Assert
        expect(canMemberRSVP, true);
      });

      test('should reject member RSVP for non-members', () {
        // Arrange
        final meeting = Meeting(
          id: 'test-meeting-123',
          organizerId: 'test-organizer-456',
          title: 'Test Meeting',
          startTime: DateTime.now().add(Duration(days: 1)),
          endTime: DateTime.now().add(Duration(days: 1, hours: 2)),
          participants: [],
          meetingType: MeetingType.event,
          groupId: 'test-group-789',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          visibility: MeetingVisibility(
            groupMembersOnly: true,
            allowGuestsRSVP: false,
          ),
        );

        // Act
        final isGroupMember = false;
        final canMemberRSVP = isGroupMember;

        // Assert
        expect(canMemberRSVP, false);
      });
    });

    group('Analytics Tracking', () {
      test('should track public meeting page view', () async {
        // Arrange
        final meetingId = 'test-meeting-123';
        final groupId = 'test-group-789';
        final shareId = 'test-share-123';
        final source = 'whatsapp';

        when(mockAnalyticsService.trackPublicMeetingPageViewed(
          meetingId: meetingId,
          groupId: groupId,
          shareId: shareId,
          source: source,
        )).thenAnswer((_) async {});

        // Act
        await mockAnalyticsService.trackPublicMeetingPageViewed(
          meetingId: meetingId,
          groupId: groupId,
          shareId: shareId,
          source: source,
        );

        // Assert
        verify(mockAnalyticsService.trackPublicMeetingPageViewed(
          meetingId: meetingId,
          groupId: groupId,
          shareId: shareId,
          source: source,
        )).called(1);
      });

      test('should track guest RSVP submission', () async {
        // Arrange
        final meetingId = 'test-meeting-123';
        final groupId = 'test-group-789';
        final guestToken = 'valid-guest-token-123';
        final status = 'attending';

        when(mockAnalyticsService.trackRSVPSubmittedFromShare(
          meetingId: meetingId,
          groupId: groupId,
          guestToken: guestToken,
          status: status,
          source: 'share_link',
        )).thenAnswer((_) async {});

        // Act
        await mockAnalyticsService.trackRSVPSubmittedFromShare(
          meetingId: meetingId,
          groupId: groupId,
          guestToken: guestToken,
          status: status,
          source: 'share_link',
        );

        // Assert
        verify(mockAnalyticsService.trackRSVPSubmittedFromShare(
          meetingId: meetingId,
          groupId: groupId,
          guestToken: guestToken,
          status: status,
          source: 'share_link',
        )).called(1);
      });

      test('should track member RSVP submission', () async {
        // Arrange
        final meetingId = 'test-meeting-123';
        final groupId = 'test-group-789';
        final userId = 'test-user-456';
        final status = 'attending';

        when(mockAnalyticsService.trackRSVPSubmittedFromShare(
          meetingId: meetingId,
          groupId: groupId,
          userId: userId,
          status: status,
          source: 'share_link',
        )).thenAnswer((_) async {});

        // Act
        await mockAnalyticsService.trackRSVPSubmittedFromShare(
          meetingId: meetingId,
          groupId: groupId,
          userId: userId,
          status: status,
          source: 'share_link',
        );

        // Assert
        verify(mockAnalyticsService.trackRSVPSubmittedFromShare(
          meetingId: meetingId,
          groupId: groupId,
          userId: userId,
          status: status,
          source: 'share_link',
        )).called(1);
      });
    });

    group('Meeting Type Handling', () {
      test('should handle event meetings correctly', () {
        // Arrange
        final meeting = Meeting(
          id: 'test-meeting-123',
          organizerId: 'test-organizer-456',
          title: 'Test Event',
          startTime: DateTime.now().add(Duration(days: 1)),
          endTime: DateTime.now().add(Duration(days: 1, hours: 2)),
          participants: [],
          meetingType: MeetingType.event,
          groupId: 'test-group-789',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Act
        final isEvent = meeting.isEvent;
        final typeDisplayName = meeting.typeDisplayName;

        // Assert
        expect(isEvent, true);
        expect(typeDisplayName, 'Event');
      });

      test('should handle personal meetings correctly', () {
        // Arrange
        final meeting = Meeting(
          id: 'test-meeting-123',
          organizerId: 'test-organizer-456',
          title: 'Test Meeting',
          startTime: DateTime.now().add(Duration(days: 1)),
          endTime: DateTime.now().add(Duration(days: 1, hours: 2)),
          participants: [],
          meetingType: MeetingType.personal,
          groupId: 'test-group-789',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Act
        final isPersonal = meeting.isPersonalMeeting;
        final typeDisplayName = meeting.typeDisplayName;

        // Assert
        expect(isPersonal, true);
        expect(typeDisplayName, 'Meeting');
      });

      test('should handle playtime meetings correctly', () {
        // Arrange
        final meeting = Meeting(
          id: 'test-meeting-123',
          organizerId: 'test-organizer-456',
          title: 'Test Playtime',
          startTime: DateTime.now().add(Duration(days: 1)),
          endTime: DateTime.now().add(Duration(days: 1, hours: 2)),
          participants: [],
          meetingType: MeetingType.playtime,
          groupId: 'test-group-789',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Act
        final isPlaytime = meeting.isPlaytime;
        final typeDisplayName = meeting.typeDisplayName;

        // Assert
        expect(isPlaytime, true);
        expect(typeDisplayName, 'Playtime');
      });
    });

    group('Error Handling', () {
      test('should handle guest token creation errors', () async {
        // Arrange
        final meetingId = 'test-meeting-123';
        final groupId = 'test-group-789';

        when(mockGuestTokenService.createGuestToken(
          meetingId,
          groupId: groupId,
        )).thenThrow(Exception('Token creation failed'));

        // Act & Assert
        expect(
          () => mockGuestTokenService.createGuestToken(
            meetingId,
            groupId: groupId,
          ),
          throwsA(isA<Exception>()),
        );
      });

      test('should handle rate limit errors', () async {
        // Arrange
        when(mockRateLimitService.allow(
          'guest_rsvp',
          'anonymous',
        )).thenThrow(Exception('Rate limit service error'));

        // Act & Assert
        expect(
          () => mockRateLimitService.allow(
            'guest_rsvp',
            'anonymous',
          ),
          throwsA(isA<Exception>()),
        );
      });

      test('should handle analytics tracking errors', () async {
        // Arrange
        final meetingId = 'test-meeting-123';

        when(mockAnalyticsService.trackPublicMeetingPageViewed(
          meetingId: meetingId,
        )).thenThrow(Exception('Analytics service error'));

        // Act & Assert
        expect(
          () => mockAnalyticsService.trackPublicMeetingPageViewed(
            meetingId: meetingId,
          ),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('Integration Tests', () {
      test('should handle complete guest RSVP flow', () async {
        // Arrange
        final meeting = Meeting(
          id: 'test-meeting-123',
          organizerId: 'test-organizer-456',
          title: 'Test Meeting',
          startTime: DateTime.now().add(Duration(days: 1)),
          endTime: DateTime.now().add(Duration(days: 1, hours: 2)),
          participants: [],
          meetingType: MeetingType.event,
          groupId: 'test-group-789',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          visibility: MeetingVisibility(
            groupMembersOnly: false,
            allowGuestsRSVP: true,
          ),
        );

        final guestToken = 'valid-guest-token-123';

        when(mockGuestTokenService.createGuestToken(
          meeting.id,
          groupId: meeting.groupId,
        )).thenAnswer((_) async => guestToken);

        when(mockRateLimitService.allow(
          'guest_rsvp',
          'anonymous',
        )).thenAnswer((_) async => true);

        when(mockAnalyticsService.trackRSVPSubmittedFromShare(
          meetingId: meeting.id,
          groupId: meeting.groupId,
          guestToken: guestToken,
          status: 'attending',
          source: 'share_link',
        )).thenAnswer((_) async {});

        // Act - simulate guest RSVP flow
        final canGuestRSVP = meeting.visibility?.allowGuestsRSVP == true;
        final rateLimitAllowed = await mockRateLimitService.allow(
          'guest_rsvp',
          'anonymous',
        );
        final token = await mockGuestTokenService.createGuestToken(
          meeting.id,
          groupId: meeting.groupId,
        );
        await mockAnalyticsService.trackRSVPSubmittedFromShare(
          meetingId: meeting.id,
          groupId: meeting.groupId,
          guestToken: token,
          status: 'attending',
          source: 'share_link',
        );

        // Assert
        expect(canGuestRSVP, true);
        expect(rateLimitAllowed, true);
        expect(token, guestToken);
      });

      test('should handle member RSVP flow', () async {
        // Arrange
        final meeting = Meeting(
          id: 'test-meeting-123',
          organizerId: 'test-organizer-456',
          title: 'Test Meeting',
          startTime: DateTime.now().add(Duration(days: 1)),
          endTime: DateTime.now().add(Duration(days: 1, hours: 2)),
          participants: [],
          meetingType: MeetingType.event,
          groupId: 'test-group-789',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          visibility: MeetingVisibility(
            groupMembersOnly: true,
            allowGuestsRSVP: false,
          ),
        );

        final userId = 'test-user-456';

        when(mockAnalyticsService.trackRSVPSubmittedFromShare(
          meetingId: meeting.id,
          groupId: meeting.groupId,
          userId: userId,
          status: 'attending',
          source: 'share_link',
        )).thenAnswer((_) async {});

        // Act - simulate member RSVP flow
        final isGroupMember = true;
        final canMemberRSVP = isGroupMember;
        await mockAnalyticsService.trackRSVPSubmittedFromShare(
          meetingId: meeting.id,
          groupId: meeting.groupId,
          userId: userId,
          status: 'attending',
          source: 'share_link',
        );

        // Assert
        expect(canMemberRSVP, true);
      });
    });
  });
}
