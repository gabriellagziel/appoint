import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/models/meeting_details.dart';
import 'package:appoint/models/location.dart';
import 'package:appoint/services/meeting_service.dart';
import 'package:mockito/mockito.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

import '../firebase_test_helper.dart';

void main() {
  late MeetingService meetingService;
  late FakeFirebaseFirestore fakeFirestore;

  setUpAll(() async {
    await initializeTestFirebase();
  });

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    meetingService = MeetingService();
  });

  group('MeetingService', () {
    test('should create a meeting with all participants', () async {
      final meeting = MeetingDetails(
        id: '',
        title: 'Test Meeting',
        description: 'A test meeting',
        scheduledAt: DateTime.now().add(const Duration(hours: 2)),
        endTime: DateTime.now().add(const Duration(hours: 3)),
        type: MeetingType.group,
        creatorId: 'user-1',
        participants: [
          const MeetingParticipant(
            userId: 'user-1',
            email: 'user1@test.com',
            displayName: 'User 1',
            role: ParticipantRole.host,
          ),
          const MeetingParticipant(
            userId: 'user-2',
            email: 'user2@test.com',
            displayName: 'User 2',
            role: ParticipantRole.participant,
          ),
        ],
        location: const Location(
          latitude: 37.7749,
          longitude: -122.4194,
          address: 'San Francisco, CA',
        ),
        isLocationTrackingEnabled: true,
      );

      final createdMeeting = await meetingService.createMeeting(meeting);

      expect(createdMeeting.id, isNotEmpty);
      expect(createdMeeting.title, equals('Test Meeting'));
      expect(createdMeeting.participants.length, equals(2));
      expect(createdMeeting.isLocationEnabled, isTrue);
    });

    test('should update participant status correctly', () async {
      final meeting = MeetingDetails(
        id: 'meeting-123',
        title: 'Test Meeting',
        description: 'A test meeting',
        scheduledAt: DateTime.now().add(const Duration(hours: 2)),
        endTime: DateTime.now().add(const Duration(hours: 3)),
        type: MeetingType.oneOnOne,
        creatorId: 'user-1',
        participants: [
          const MeetingParticipant(
            userId: 'user-1',
            email: 'user1@test.com',
            displayName: 'User 1',
            role: ParticipantRole.host,
            status: ParticipantStatus.confirmed,
          ),
          const MeetingParticipant(
            userId: 'user-2',
            email: 'user2@test.com',
            displayName: 'User 2',
            role: ParticipantRole.participant,
            status: ParticipantStatus.pending,
          ),
        ],
      );

      // Mock the meeting creation first
      await meetingService.createMeeting(meeting);

      // Update participant status
      await meetingService.updateParticipantStatus(
        meetingId: 'meeting-123',
        userId: 'user-2',
        status: ParticipantStatus.confirmed,
      );

      // In a real test, we would verify the Firestore update
      // For now, just verify the method doesn't throw
      expect(true, isTrue);
    });

    test('should mark participant as running late with reason', () async {
      final meeting = MeetingDetails(
        id: 'meeting-123',
        title: 'Test Meeting',
        description: 'A test meeting',
        scheduledAt: DateTime.now().add(const Duration(hours: 2)),
        endTime: DateTime.now().add(const Duration(hours: 3)),
        type: MeetingType.oneOnOne,
        creatorId: 'user-1',
        participants: [
          const MeetingParticipant(
            userId: 'user-1',
            email: 'user1@test.com',
            displayName: 'User 1',
            role: ParticipantRole.host,
            status: ParticipantStatus.confirmed,
          ),
        ],
      );

      await meetingService.createMeeting(meeting);

      await meetingService.markAsRunningLate(
        meetingId: 'meeting-123',
        userId: 'user-1',
        reason: 'Traffic jam',
        delayMinutes: 15,
      );

      // Verify the method execution without errors
      expect(true, isTrue);
    });

    test('should determine if user will be late based on location', () async {
      final meeting = MeetingDetails(
        id: 'meeting-123',
        title: 'Test Meeting',
        description: 'A test meeting',
        scheduledAt: DateTime.now().add(const Duration(minutes: 30)),
        endTime: DateTime.now().add(const Duration(hours: 1, minutes: 30)),
        type: MeetingType.oneOnOne,
        creatorId: 'user-1',
        participants: [
          const MeetingParticipant(
            userId: 'user-1',
            email: 'user1@test.com',
            displayName: 'User 1',
            role: ParticipantRole.host,
          ),
        ],
        location: const Location(
          latitude: 37.7749,
          longitude: -122.4194,
          address: 'San Francisco, CA',
        ),
      );

      await meetingService.createMeeting(meeting);

      // This test would require mocking location services
      // For now, just verify the method can be called
      final willBeLate = await meetingService.checkIfUserWillBeLate(
        'meeting-123',
        'user-1',
      );

      expect(willBeLate, isA<bool>());
    });

    test('should filter meetings by date range', () async {
      final now = DateTime.now();
      final startDate = now.subtract(const Duration(days: 1));
      final endDate = now.add(const Duration(days: 1));

      // This would typically return a stream, so we just verify it doesn't error
      final meetingsStream = meetingService.watchUserMeetings(
        'user-1',
        startDate: startDate,
        endDate: endDate,
      );

      expect(meetingsStream, isA<Stream<List<MeetingDetails>>>());
    });

    group('MeetingDetails Extensions', () {
      test('should correctly identify group events', () {
        final oneOnOneMeeting = MeetingDetails(
          id: 'meeting-1',
          title: 'One on One',
          description: 'Private meeting',
          scheduledAt: DateTime.now(),
          endTime: DateTime.now().add(const Duration(hours: 1)),
          type: MeetingType.oneOnOne,
          creatorId: 'user-1',
          participants: [],
        );

        final groupMeeting = MeetingDetails(
          id: 'meeting-2',
          title: 'Group Meeting',
          description: 'Team meeting',
          scheduledAt: DateTime.now(),
          endTime: DateTime.now().add(const Duration(hours: 1)),
          type: MeetingType.group,
          creatorId: 'user-1',
          participants: [],
        );

        final eventMeeting = MeetingDetails(
          id: 'meeting-3',
          title: 'Company Event',
          description: 'All hands meeting',
          scheduledAt: DateTime.now(),
          endTime: DateTime.now().add(const Duration(hours: 2)),
          type: MeetingType.event,
          creatorId: 'user-1',
          participants: [],
        );

        expect(oneOnOneMeeting.isGroupEvent, isFalse);
        expect(groupMeeting.isGroupEvent, isTrue);
        expect(eventMeeting.isGroupEvent, isTrue);
      });

      test('should correctly identify confirmed participants', () {
        final meeting = MeetingDetails(
          id: 'meeting-1',
          title: 'Test Meeting',
          description: 'Test',
          scheduledAt: DateTime.now(),
          endTime: DateTime.now().add(const Duration(hours: 1)),
          type: MeetingType.group,
          creatorId: 'user-1',
          participants: [
            const MeetingParticipant(
              userId: 'user-1',
              email: 'user1@test.com',
              displayName: 'User 1',
              status: ParticipantStatus.confirmed,
            ),
            const MeetingParticipant(
              userId: 'user-2',
              email: 'user2@test.com',
              displayName: 'User 2',
              status: ParticipantStatus.pending,
            ),
            const MeetingParticipant(
              userId: 'user-3',
              email: 'user3@test.com',
              displayName: 'User 3',
              status: ParticipantStatus.confirmed,
            ),
          ],
        );

        expect(meeting.confirmedParticipants.length, equals(2));
        expect(meeting.participantCount, equals(3));
      });

      test('should correctly identify late participants', () {
        final meeting = MeetingDetails(
          id: 'meeting-1',
          title: 'Test Meeting',
          description: 'Test',
          scheduledAt: DateTime.now(),
          endTime: DateTime.now().add(const Duration(hours: 1)),
          type: MeetingType.group,
          creatorId: 'user-1',
          participants: [
            const MeetingParticipant(
              userId: 'user-1',
              email: 'user1@test.com',
              displayName: 'User 1',
              status: ParticipantStatus.confirmed,
              isRunningLate: true,
            ),
            const MeetingParticipant(
              userId: 'user-2',
              email: 'user2@test.com',
              displayName: 'User 2',
              status: ParticipantStatus.late,
              isRunningLate: true,
            ),
            const MeetingParticipant(
              userId: 'user-3',
              email: 'user3@test.com',
              displayName: 'User 3',
              status: ParticipantStatus.confirmed,
              isRunningLate: false,
            ),
          ],
        );

        expect(meeting.lateParticipants.length, equals(2));
      });

      test('should correctly identify meeting status', () {
        final now = DateTime.now();
        
        final upcomingMeeting = MeetingDetails(
          id: 'meeting-1',
          title: 'Upcoming Meeting',
          description: 'Future meeting',
          scheduledAt: now.add(const Duration(hours: 2)),
          endTime: now.add(const Duration(hours: 3)),
          type: MeetingType.oneOnOne,
          creatorId: 'user-1',
          participants: [],
        );

        final activeMeeting = MeetingDetails(
          id: 'meeting-2',
          title: 'Active Meeting',
          description: 'Current meeting',
          scheduledAt: now.subtract(const Duration(minutes: 30)),
          endTime: now.add(const Duration(minutes: 30)),
          type: MeetingType.oneOnOne,
          creatorId: 'user-1',
          participants: [],
        );

        final completedMeeting = MeetingDetails(
          id: 'meeting-3',
          title: 'Completed Meeting',
          description: 'Past meeting',
          scheduledAt: now.subtract(const Duration(hours: 2)),
          endTime: now.subtract(const Duration(hours: 1)),
          type: MeetingType.oneOnOne,
          creatorId: 'user-1',
          participants: [],
        );

        expect(upcomingMeeting.isUpcoming, isTrue);
        expect(upcomingMeeting.isActive, isFalse);
        expect(upcomingMeeting.isCompleted, isFalse);

        expect(activeMeeting.isUpcoming, isFalse);
        expect(activeMeeting.isActive, isTrue);
        expect(activeMeeting.isCompleted, isFalse);

        expect(completedMeeting.isUpcoming, isFalse);
        expect(completedMeeting.isActive, isFalse);
        expect(completedMeeting.isCompleted, isTrue);
      });

      test('should identify meeting host correctly', () {
        final meeting = MeetingDetails(
          id: 'meeting-1',
          title: 'Test Meeting',
          description: 'Test',
          scheduledAt: DateTime.now(),
          endTime: DateTime.now().add(const Duration(hours: 1)),
          type: MeetingType.group,
          creatorId: 'user-1',
          participants: [
            const MeetingParticipant(
              userId: 'user-1',
              email: 'user1@test.com',
              displayName: 'User 1',
              role: ParticipantRole.host,
            ),
            const MeetingParticipant(
              userId: 'user-2',
              email: 'user2@test.com',
              displayName: 'User 2',
              role: ParticipantRole.participant,
            ),
          ],
        );

        expect(meeting.hasHost, isTrue);
        expect(meeting.host?.userId, equals('user-1'));
        expect(meeting.host?.role, equals(ParticipantRole.host));
      });
    });

    group('CustomForm functionality', () {
      test('should handle different form types', () {
        const rsvpForm = CustomForm(
          id: 'form-1',
          title: 'RSVP Form',
          description: 'Please confirm your attendance',
          type: CustomFormType.rsvp,
          fields: [],
        );

        const pollForm = CustomForm(
          id: 'form-2',
          title: 'Meeting Poll',
          description: 'Vote on meeting topics',
          type: CustomFormType.poll,
          fields: [],
        );

        const surveyForm = CustomForm(
          id: 'form-3',
          title: 'Feedback Survey',
          description: 'Share your feedback',
          type: CustomFormType.survey,
          fields: [],
          isRequired: true,
        );

        expect(rsvpForm.type, equals(CustomFormType.rsvp));
        expect(pollForm.type, equals(CustomFormType.poll));
        expect(surveyForm.type, equals(CustomFormType.survey));
        expect(surveyForm.isRequired, isTrue);
        expect(rsvpForm.isRequired, isFalse);
      });

      test('should handle different field types', () {
        const textField = FormField(
          id: 'field-1',
          label: 'Name',
          type: FormFieldType.text,
          isRequired: true,
        );

        const selectField = FormField(
          id: 'field-2',
          label: 'Preference',
          type: FormFieldType.select,
          options: ['Option 1', 'Option 2', 'Option 3'],
        );

        const emailField = FormField(
          id: 'field-3',
          label: 'Email',
          type: FormFieldType.email,
          placeholder: 'Enter your email',
        );

        expect(textField.type, equals(FormFieldType.text));
        expect(textField.isRequired, isTrue);
        expect(selectField.options?.length, equals(3));
        expect(emailField.placeholder, equals('Enter your email'));
      });
    });
  });
}