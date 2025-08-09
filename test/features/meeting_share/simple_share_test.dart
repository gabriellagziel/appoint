import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/models/meeting.dart';

void main() {
  group('Simple Share Tests', () {
    test('should create meeting with visibility controls', () {
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

      // Assert
      expect(meeting.id, 'test-meeting-123');
      expect(meeting.groupId, 'test-group-789');
      expect(meeting.visibility?.groupMembersOnly, true);
      expect(meeting.visibility?.allowGuestsRSVP, true);
      expect(meeting.isEvent, true);
    });

    test('should handle meeting visibility correctly', () {
      // Arrange
      final groupOnlyMeeting = Meeting(
        id: 'group-only-meeting',
        organizerId: 'test-organizer',
        title: 'Group Only Meeting',
        startTime: DateTime.now().add(Duration(days: 1)),
        endTime: DateTime.now().add(Duration(days: 1, hours: 2)),
        participants: [],
        meetingType: MeetingType.event,
        groupId: 'test-group',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        visibility: MeetingVisibility(
          groupMembersOnly: true,
          allowGuestsRSVP: false,
        ),
      );

      final publicMeeting = Meeting(
        id: 'public-meeting',
        organizerId: 'test-organizer',
        title: 'Public Meeting',
        startTime: DateTime.now().add(Duration(days: 1)),
        endTime: DateTime.now().add(Duration(days: 1, hours: 2)),
        participants: [],
        meetingType: MeetingType.event,
        groupId: 'test-group',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        visibility: MeetingVisibility(
          groupMembersOnly: false,
          allowGuestsRSVP: true,
        ),
      );

      // Act & Assert
      expect(groupOnlyMeeting.visibility?.groupMembersOnly, true);
      expect(groupOnlyMeeting.visibility?.allowGuestsRSVP, false);

      expect(publicMeeting.visibility?.groupMembersOnly, false);
      expect(publicMeeting.visibility?.allowGuestsRSVP, true);
    });

    test('should serialize and deserialize meeting with visibility', () {
      // Arrange
      final originalMeeting = Meeting(
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
          allowGuestsRSVP: true,
        ),
      );

      // Act
      final json = originalMeeting.toJson();
      final deserializedMeeting = Meeting.fromJson(json);

      // Assert
      expect(deserializedMeeting.id, originalMeeting.id);
      expect(deserializedMeeting.groupId, originalMeeting.groupId);
      expect(deserializedMeeting.visibility?.groupMembersOnly,
          originalMeeting.visibility?.groupMembersOnly);
      expect(deserializedMeeting.visibility?.allowGuestsRSVP,
          originalMeeting.visibility?.allowGuestsRSVP);
    });

    test('should handle meeting type correctly', () {
      // Arrange
      final eventMeeting = Meeting(
        id: 'event-meeting',
        organizerId: 'test-organizer',
        title: 'Event Meeting',
        startTime: DateTime.now().add(Duration(days: 1)),
        endTime: DateTime.now().add(Duration(days: 1, hours: 2)),
        participants: [],
        meetingType: MeetingType.event,
        groupId: 'test-group',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final personalMeeting = Meeting(
        id: 'personal-meeting',
        organizerId: 'test-organizer',
        title: 'Personal Meeting',
        startTime: DateTime.now().add(Duration(days: 1)),
        endTime: DateTime.now().add(Duration(days: 1, hours: 2)),
        participants: [],
        meetingType: MeetingType.personal,
        groupId: 'test-group',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final playtimeMeeting = Meeting(
        id: 'playtime-meeting',
        organizerId: 'test-organizer',
        title: 'Playtime Meeting',
        startTime: DateTime.now().add(Duration(days: 1)),
        endTime: DateTime.now().add(Duration(days: 1, hours: 2)),
        participants: [],
        meetingType: MeetingType.playtime,
        groupId: 'test-group',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Act & Assert
      expect(eventMeeting.isEvent, true);
      expect(eventMeeting.typeDisplayName, 'Event');

      expect(personalMeeting.isPersonalMeeting, true);
      expect(personalMeeting.typeDisplayName, 'Meeting');

      expect(playtimeMeeting.isPlaytime, true);
      expect(playtimeMeeting.typeDisplayName, 'Playtime');
    });

    test('should handle copyWith with visibility', () {
      // Arrange
      final originalMeeting = Meeting(
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
          allowGuestsRSVP: true,
        ),
      );

      // Act
      final updatedMeeting = originalMeeting.copyWith(
        visibility: MeetingVisibility(
          groupMembersOnly: false,
          allowGuestsRSVP: true,
        ),
      );

      // Assert
      expect(updatedMeeting.id, originalMeeting.id);
      expect(updatedMeeting.visibility?.groupMembersOnly, false);
      expect(updatedMeeting.visibility?.allowGuestsRSVP, true);
    });
  });
}
