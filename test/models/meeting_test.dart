import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/models/meeting.dart';

void main() {
  group('Meeting Type Logic Tests', () {
    late DateTime startTime;
    late DateTime endTime;

    setUp(() {
      startTime = DateTime(2024, 1, 15, 10, 0);
      endTime = DateTime(2024, 1, 15, 11, 0);
    });

    test('Meeting with 1 participant (2 total) should be personal meeting', () {
      final meeting = Meeting(
        id: 'test-1',
        organizerId: 'organizer-1',
        title: 'Test Meeting',
        startTime: startTime,
        endTime: endTime,
        participants: [
          const MeetingParticipant(
            userId: 'user-1',
            name: 'Participant 1',
          ),
        ],
      );

      expect(meeting.meetingType, MeetingType.personal);
      expect(meeting.isPersonalMeeting, isTrue);
      expect(meeting.isEvent, isFalse);
      expect(meeting.typeDisplayName, 'Meeting');
      expect(meeting.totalParticipantCount, 2);
    });

    test('Meeting with 2 participants (3 total) should be personal meeting',
        () {
      final meeting = Meeting(
        id: 'test-2',
        organizerId: 'organizer-1',
        title: 'Test Meeting',
        startTime: startTime,
        endTime: endTime,
        participants: [
          const MeetingParticipant(
            userId: 'user-1',
            name: 'Participant 1',
          ),
          const MeetingParticipant(
            userId: 'user-2',
            name: 'Participant 2',
          ),
        ],
      );

      expect(meeting.meetingType, MeetingType.personal);
      expect(meeting.isPersonalMeeting, isTrue);
      expect(meeting.isEvent, isFalse);
      expect(meeting.totalParticipantCount, 3);
    });

    test('Meeting with 3 participants (4 total) should be event', () {
      final meeting = Meeting(
        id: 'test-3',
        organizerId: 'organizer-1',
        title: 'Test Event',
        startTime: startTime,
        endTime: endTime,
        participants: [
          const MeetingParticipant(
            userId: 'user-1',
            name: 'Participant 1',
          ),
          const MeetingParticipant(
            userId: 'user-2',
            name: 'Participant 2',
          ),
          const MeetingParticipant(
            userId: 'user-3',
            name: 'Participant 3',
          ),
        ],
      );

      expect(meeting.meetingType, MeetingType.event);
      expect(meeting.isEvent, isTrue);
      expect(meeting.isPersonalMeeting, isFalse);
      expect(meeting.typeDisplayName, 'Event');
      expect(meeting.totalParticipantCount, 4);
    });

    test('Meeting with many participants should be event', () {
      final participants = List.generate(
        10,
        (index) => MeetingParticipant(
          userId: 'user-$index',
          name: 'Participant $index',
        ),
      );

      final meeting = Meeting(
        id: 'test-large',
        organizerId: 'organizer-1',
        title: 'Large Event',
        startTime: startTime,
        endTime: endTime,
        participants: participants,
      );

      expect(meeting.meetingType, MeetingType.event);
      expect(meeting.isEvent, isTrue);
      expect(
          meeting.totalParticipantCount, 11); // 10 participants + 1 organizer
    });
  });

  group('Meeting Validation Tests', () {
    late DateTime startTime;
    late DateTime endTime;

    setUp(() {
      startTime = DateTime(2024, 1, 15, 10, 0);
      endTime = DateTime(2024, 1, 15, 11, 0);
    });

    test('Meeting with no participants should fail validation', () {
      final meeting = Meeting(
        id: 'test-empty',
        organizerId: 'organizer-1',
        title: 'Empty Meeting',
        startTime: startTime,
        endTime: endTime,
        participants: [],
      );

      final error = meeting.validateMeetingCreation();
      expect(error, isNotNull);
      expect(error, contains('at least one participant'));
    });

    test('Meeting with participants should pass validation', () {
      final meeting = Meeting(
        id: 'test-valid',
        organizerId: 'organizer-1',
        title: 'Valid Meeting',
        startTime: startTime,
        endTime: endTime,
        participants: [
          const MeetingParticipant(
            userId: 'user-1',
            name: 'Participant 1',
          ),
        ],
      );

      final error = meeting.validateMeetingCreation();
      expect(error, isNull);
    });
  });

  group('Participant Role Tests', () {
    late Meeting meeting;
    late DateTime startTime;
    late DateTime endTime;

    setUp(() {
      startTime = DateTime(2024, 1, 15, 10, 0);
      endTime = DateTime(2024, 1, 15, 11, 0);

      meeting = Meeting(
        id: 'test-roles',
        organizerId: 'organizer-1',
        title: 'Role Test Meeting',
        startTime: startTime,
        endTime: endTime,
        participants: [
          const MeetingParticipant(
            userId: 'admin-1',
            name: 'Admin User',
            role: ParticipantRole.admin,
          ),
          const MeetingParticipant(
            userId: 'participant-1',
            name: 'Regular Participant',
            role: ParticipantRole.participant,
          ),
          const MeetingParticipant(
            userId: 'participant-2',
            name: 'Another Participant',
            role: ParticipantRole.participant,
          ),
        ],
      );
    });

    test('Organizer should be identified correctly', () {
      expect(meeting.isOrganizer('organizer-1'), isTrue);
      expect(meeting.isOrganizer('admin-1'), isFalse);
      expect(meeting.isOrganizer('participant-1'), isFalse);
    });

    test('Admin roles should be identified correctly', () {
      expect(
          meeting.isAdmin('organizer-1'), isTrue); // Organizer is always admin
      expect(meeting.isAdmin('admin-1'), isTrue);
      expect(meeting.isAdmin('participant-1'), isFalse);
      expect(meeting.isAdmin('participant-2'), isFalse);
    });

    test('Event feature access should work correctly', () {
      // This meeting has 4 total participants, so it's an event
      expect(meeting.isEvent, isTrue);
      expect(meeting.canAccessEventFeatures('organizer-1'), isTrue);
      expect(meeting.canAccessEventFeatures('admin-1'), isTrue);
      expect(meeting.canAccessEventFeatures('participant-1'), isFalse);
    });

    test('Personal meeting should not have event feature access', () {
      final personalMeeting = meeting.copyWith(
        participants: [
          meeting.participants.first
        ], // Only 1 participant = personal meeting
      );

      expect(personalMeeting.isPersonalMeeting, isTrue);
      expect(personalMeeting.canAccessEventFeatures('organizer-1'), isFalse);
      expect(personalMeeting.canAccessEventFeatures('admin-1'), isFalse);
    });

    test('Get participant by user ID should work', () {
      final participant = meeting.getParticipant('admin-1');
      expect(participant, isNotNull);
      expect(participant!.name, 'Admin User');
      expect(participant.role, ParticipantRole.admin);

      final nonExistent = meeting.getParticipant('non-existent');
      expect(nonExistent, isNull);
    });
  });

  group('Event Features Tests', () {
    late Meeting eventMeeting;
    late Meeting personalMeeting;
    late DateTime startTime;
    late DateTime endTime;

    setUp(() {
      startTime = DateTime(2024, 1, 15, 10, 0);
      endTime = DateTime(2024, 1, 15, 11, 0);

      // Event with 4+ participants
      eventMeeting = Meeting(
        id: 'event-test',
        organizerId: 'organizer-1',
        title: 'Test Event',
        startTime: startTime,
        endTime: endTime,
        participants: List.generate(
          3,
          (index) => MeetingParticipant(
            userId: 'user-$index',
            name: 'Participant $index',
          ),
        ),
        customFormId: 'form-1',
        checklistId: 'checklist-1',
        groupChatId: 'chat-1',
      );

      // Personal meeting with 2 participants
      personalMeeting = Meeting(
        id: 'personal-test',
        organizerId: 'organizer-1',
        title: 'Test Meeting',
        startTime: startTime,
        endTime: endTime,
        participants: [
          const MeetingParticipant(
            userId: 'user-1',
            name: 'Participant 1',
          ),
        ],
      );
    });

    test('Event should have event features', () {
      expect(eventMeeting.hasCustomForm, isTrue);
      expect(eventMeeting.hasChecklist, isTrue);
      expect(eventMeeting.hasGroupChat, isTrue);
    });

    test('Personal meeting should not have event features', () {
      expect(personalMeeting.hasCustomForm, isFalse);
      expect(personalMeeting.hasChecklist, isFalse);
      expect(personalMeeting.hasGroupChat, isFalse);
    });
  });

  group('Participant Response Tests', () {
    test('Participant response tracking should work', () {
      final participant = MeetingParticipant(
        userId: 'user-1',
        name: 'Test User',
        hasResponded: true,
        willAttend: true,
        respondedAt: DateTime.now(),
      );

      expect(participant.hasResponded, isTrue);
      expect(participant.willAttend, isTrue);
      expect(participant.respondedAt, isNotNull);
    });

    test('Default participant values should be correct', () {
      const participant = MeetingParticipant(
        userId: 'user-1',
        name: 'Test User',
      );

      expect(participant.role, ParticipantRole.participant);
      expect(participant.hasResponded, isFalse);
      expect(participant.willAttend, isTrue);
      expect(participant.respondedAt, isNull);
    });
  });

  group('Meeting Status Tests', () {
    test('Meeting status should default to draft', () {
      final meeting = Meeting(
        id: 'status-test',
        organizerId: 'organizer-1',
        title: 'Status Test',
        startTime: DateTime.now(),
        endTime: DateTime.now().add(const Duration(hours: 1)),
        participants: [
          const MeetingParticipant(
            userId: 'user-1',
            name: 'Participant 1',
          ),
        ],
      );

      expect(meeting.status, MeetingStatus.draft);
    });

    test('Meeting status can be set to different values', () {
      final meeting = Meeting(
        id: 'status-test',
        organizerId: 'organizer-1',
        title: 'Status Test',
        startTime: DateTime.now(),
        endTime: DateTime.now().add(const Duration(hours: 1)),
        participants: [
          const MeetingParticipant(
            userId: 'user-1',
            name: 'Participant 1',
          ),
        ],
        status: MeetingStatus.scheduled,
      );

      expect(meeting.status, MeetingStatus.scheduled);
    });
  });

  group('Meeting Type Threshold Edge Cases', () {
    late DateTime startTime;
    late DateTime endTime;

    setUp(() {
      startTime = DateTime(2024, 1, 15, 10, 0);
      endTime = DateTime(2024, 1, 15, 11, 0);
    });

    test('Exactly 3 total participants (2 + organizer) should be personal', () {
      final meeting = Meeting(
        id: 'edge-3',
        organizerId: 'organizer-1',
        title: 'Edge Case 3',
        startTime: startTime,
        endTime: endTime,
        participants: [
          const MeetingParticipant(userId: 'user-1', name: 'User 1'),
          const MeetingParticipant(userId: 'user-2', name: 'User 2'),
        ],
      );

      expect(meeting.totalParticipantCount, 3);
      expect(meeting.meetingType, MeetingType.personal);
      expect(meeting.isPersonalMeeting, isTrue);
      expect(meeting.isEvent, isFalse);
    });

    test('Exactly 4 total participants (3 + organizer) should be event', () {
      final meeting = Meeting(
        id: 'edge-4',
        organizerId: 'organizer-1',
        title: 'Edge Case 4',
        startTime: startTime,
        endTime: endTime,
        participants: [
          const MeetingParticipant(userId: 'user-1', name: 'User 1'),
          const MeetingParticipant(userId: 'user-2', name: 'User 2'),
          const MeetingParticipant(userId: 'user-3', name: 'User 3'),
        ],
      );

      expect(meeting.totalParticipantCount, 4);
      expect(meeting.meetingType, MeetingType.event);
      expect(meeting.isEvent, isTrue);
      expect(meeting.isPersonalMeeting, isFalse);
    });
  });

  group('Meeting Serialization Tests', () {
    test('Meeting should serialize and deserialize correctly', () {
      final originalMeeting = Meeting(
        id: 'serialize-test',
        organizerId: 'organizer-1',
        title: 'Serialization Test',
        description: 'Test description',
        startTime: DateTime(2024, 1, 15, 10, 0),
        endTime: DateTime(2024, 1, 15, 11, 0),
        location: 'Test Location',
        virtualMeetingUrl: 'https://meet.example.com/test',
        participants: [
          const MeetingParticipant(
            userId: 'user-1',
            name: 'User 1',
            email: 'user1@example.com',
            role: ParticipantRole.admin,
          ),
        ],
        status: MeetingStatus.scheduled,
        customFormId: 'form-1',
        checklistId: 'checklist-1',
        groupChatId: 'chat-1',
        businessProfileId: 'business-1',
        isRecurring: true,
        recurringPattern: 'weekly',
      );

      final json = originalMeeting.toJson();
      final deserializedMeeting = Meeting.fromJson(json);

      expect(deserializedMeeting.id, originalMeeting.id);
      expect(deserializedMeeting.organizerId, originalMeeting.organizerId);
      expect(deserializedMeeting.title, originalMeeting.title);
      expect(deserializedMeeting.description, originalMeeting.description);
      expect(deserializedMeeting.participants.length,
          originalMeeting.participants.length);
      expect(deserializedMeeting.participants.first.userId,
          originalMeeting.participants.first.userId);
      expect(deserializedMeeting.meetingType, originalMeeting.meetingType);
      expect(deserializedMeeting.isEvent, originalMeeting.isEvent);
    });
  });
}
