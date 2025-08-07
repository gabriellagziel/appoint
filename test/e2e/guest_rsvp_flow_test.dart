import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_oint/features/public_meeting/presentation/public_meeting_page.dart';
import 'package:app_oint/features/create_meeting/services/guest_participant_service.dart';
import 'package:app_oint/features/analytics/services/analytics_service.dart';
import 'package:app_oint/features/notifications/services/push_notification_service.dart';
import 'package:app_oint/features/security/services/abuse_prevention_service.dart';

void main() {
  group('Guest RSVP Flow E2E Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    group('Anonymous Guest RSVP Flow', () {
      testWidgets('should complete full anonymous RSVP flow', (WidgetTester tester) async {
        // Arrange
        const meetingId = 'test_meeting_123';
        const source = 'whatsapp';
        const groupId = 'test_group_456';

        // Act
        await tester.pumpWidget(
          ProviderScope(
            parent: container,
            child: MaterialApp(
              home: PublicMeetingPage(
                meetingId: meetingId,
                source: source,
                groupId: groupId,
              ),
            ),
          ),
        );

        // Wait for page to load
        await tester.pumpAndSettle();

        // Verify page loads correctly
        expect(find.text('Meeting Details'), findsOneWidget);
        expect(find.text('RSVP'), findsOneWidget);

        // Fill in guest information
        await tester.enterText(
          find.byKey(const Key('guest_name_field')),
          'John Guest',
        );
        await tester.enterText(
          find.byKey(const Key('guest_email_field')),
          'john@example.com',
        );

        // Submit RSVP
        await tester.tap(find.text('Accept'));
        await tester.pumpAndSettle();

        // Verify success message
        expect(find.text('RSVP submitted successfully!'), findsOneWidget);

        // Verify calendar options appear
        expect(find.text('Add to Calendar'), findsOneWidget);
        expect(find.text('Google Calendar'), findsOneWidget);
        expect(find.text('Download .ics'), findsOneWidget);

        // Verify signup prompt appears
        expect(find.text('Create Your Own Meeting?'), findsOneWidget);
      });

      testWidgets('should handle RSVP decline flow', (WidgetTester tester) async {
        // Arrange
        const meetingId = 'test_meeting_123';

        await tester.pumpWidget(
          ProviderScope(
            parent: container,
            child: MaterialApp(
              home: PublicMeetingPage(
                meetingId: meetingId,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Fill in guest information
        await tester.enterText(
          find.byKey(const Key('guest_name_field')),
          'Jane Guest',
        );

        // Decline RSVP
        await tester.tap(find.text('Decline'));
        await tester.pumpAndSettle();

        // Verify success message
        expect(find.text('RSVP submitted successfully!'), findsOneWidget);

        // Verify no calendar options for declined RSVP
        expect(find.text('Add to Calendar'), findsNothing);
      });
    });

    group('Logged-in User RSVP Flow', () {
      testWidgets('should auto-link RSVP for logged-in user', (WidgetTester tester) async {
        // Arrange
        const meetingId = 'test_meeting_123';

        // Mock logged-in user
        // TODO: Mock authentication state

        await tester.pumpWidget(
          ProviderScope(
            parent: container,
            child: MaterialApp(
              home: PublicMeetingPage(
                meetingId: meetingId,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify logged-in user message appears
        expect(find.text('You\'re signed in. Your RSVP will be linked to your account.'), findsOneWidget);

        // Verify no manual input fields for logged-in users
        expect(find.byKey(const Key('guest_name_field')), findsNothing);
        expect(find.byKey(const Key('guest_email_field')), findsNothing);

        // Submit RSVP
        await tester.tap(find.text('Accept'));
        await tester.pumpAndSettle();

        // Verify success message
        expect(find.text('RSVP submitted successfully!'), findsOneWidget);
      });
    });

    group('Security and Abuse Prevention', () {
      testWidgets('should prevent RSVP spam from same device', (WidgetTester tester) async {
        // Arrange
        const meetingId = 'test_meeting_123';
        const deviceId = 'spam_device_123';

        // Mock device limit exceeded
        // TODO: Mock AbusePreventionService

        await tester.pumpWidget(
          ProviderScope(
            parent: container,
            child: MaterialApp(
              home: PublicMeetingPage(
                meetingId: meetingId,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Fill in guest information
        await tester.enterText(
          find.byKey(const Key('guest_name_field')),
          'Spam User',
        );

        // Try to submit RSVP
        await tester.tap(find.text('Accept'));
        await tester.pumpAndSettle();

        // Verify error message
        expect(find.text('Device has exceeded RSVP limit for this meeting'), findsOneWidget);
      });

      testWidgets('should validate guest data for suspicious patterns', (WidgetTester tester) async {
        // Arrange
        const meetingId = 'test_meeting_123';

        await tester.pumpWidget(
          ProviderScope(
            parent: container,
            child: MaterialApp(
              home: PublicMeetingPage(
                meetingId: meetingId,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Try to submit with suspicious data
        await tester.enterText(
          find.byKey(const Key('guest_name_field')),
          'aa', // Very short name
        );
        await tester.enterText(
          find.byKey(const Key('guest_email_field')),
          'test@spam.com', // Suspicious email
        );

        await tester.tap(find.text('Accept'));
        await tester.pumpAndSettle();

        // Verify error message
        expect(find.text('Invalid guest data provided'), findsOneWidget);
      });
    });

    group('Firestore Integration', () {
      test('should save guest data to Firestore', () async {
        // Arrange
        const meetingId = 'test_meeting_123';
        const name = 'Test Guest';
        const email = 'test@example.com';
        const deviceId = 'test_device_123';

        // Act
        final guest = await GuestParticipantService.registerGuestParticipant(
          meetingId: meetingId,
          name: name,
          email: email,
          deviceId: deviceId,
          invitedVia: 'whatsapp',
          status: 'accepted',
        );

        // Assert
        expect(guest.meetingId, equals(meetingId));
        expect(guest.name, equals(name));
        expect(guest.email, equals(email));
        expect(guest.deviceId, equals(deviceId));
        expect(guest.status, equals('accepted'));
      });

      test('should update guest status in Firestore', () async {
        // Arrange
        const guestId = 'test_guest_123';
        const newStatus = 'declined';

        // Act
        final success = await GuestParticipantService.updateGuestStatus(
          guestId: guestId,
          status: newStatus,
        );

        // Assert
        expect(success, isTrue);
      });
    });

    group('Notifications Integration', () {
      test('should send notification to organizer on RSVP', () async {
        // Arrange
        const meetingId = 'test_meeting_123';
        const organizerId = 'organizer_123';
        const guestName = 'Test Guest';

        final guest = GuestParticipant(
          id: 'test_guest_123',
          meetingId: meetingId,
          name: guestName,
          status: 'accepted',
          createdAt: DateTime.now(),
          deviceId: 'test_device_123',
          invitedVia: 'whatsapp',
        );

        // Act
        final success = await PushNotificationService.notifyOrganizerOfGuestRsvp(
          meetingId: meetingId,
          organizerId: organizerId,
          guest: guest,
          rsvpStatus: 'accepted',
        );

        // Assert
        expect(success, isTrue);
      });
    });

    group('Analytics Integration', () {
      test('should track guest RSVP analytics', () async {
        // Arrange
        const meetingId = 'test_meeting_123';
        const guestName = 'Test Guest';

        final guest = GuestParticipant(
          id: 'test_guest_123',
          meetingId: meetingId,
          name: guestName,
          status: 'accepted',
          createdAt: DateTime.now(),
          deviceId: 'test_device_123',
          invitedVia: 'whatsapp',
        );

        // Act
        final success = await AnalyticsService.trackGuestRsvp(
          meetingId: meetingId,
          guest: guest,
          rsvpStatus: 'accepted',
        );

        // Assert
        expect(success, isTrue);
      });

      test('should get meeting analytics', () async {
        // Arrange
        const meetingId = 'test_meeting_123';

        // Act
        final analytics = await AnalyticsService.getMeetingAnalytics(meetingId);

        // Assert
        expect(analytics.meetingId, equals(meetingId));
        expect(analytics.totalInvited, greaterThan(0));
        expect(analytics.accepted, greaterThanOrEqualTo(0));
        expect(analytics.declined, greaterThanOrEqualTo(0));
        expect(analytics.pending, greaterThanOrEqualTo(0));
      });
    });

    group('Cross-platform Compatibility', () {
      testWidgets('should work on mobile browsers', (WidgetTester tester) async {
        // Arrange
        const meetingId = 'test_meeting_123';

        // Set mobile viewport
        tester.binding.window.physicalSizeTestValue = const Size(375, 812);
        tester.binding.window.devicePixelRatioTestValue = 3.0;

        await tester.pumpWidget(
          ProviderScope(
            parent: container,
            child: MaterialApp(
              home: PublicMeetingPage(
                meetingId: meetingId,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify mobile-friendly layout
        expect(find.text('Meeting Details'), findsOneWidget);
        expect(find.text('RSVP'), findsOneWidget);

        // Test mobile interactions
        await tester.enterText(
          find.byKey(const Key('guest_name_field')),
          'Mobile User',
        );

        await tester.tap(find.text('Accept'));
        await tester.pumpAndSettle();

        expect(find.text('RSVP submitted successfully!'), findsOneWidget);
      });

      testWidgets('should work on desktop browsers', (WidgetTester tester) async {
        // Arrange
        const meetingId = 'test_meeting_123';

        // Set desktop viewport
        tester.binding.window.physicalSizeTestValue = const Size(1920, 1080);
        tester.binding.window.devicePixelRatioTestValue = 1.0;

        await tester.pumpWidget(
          ProviderScope(
            parent: container,
            child: MaterialApp(
              home: PublicMeetingPage(
                meetingId: meetingId,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify desktop-friendly layout
        expect(find.text('Meeting Details'), findsOneWidget);
        expect(find.text('RSVP'), findsOneWidget);

        // Test desktop interactions
        await tester.enterText(
          find.byKey(const Key('guest_name_field')),
          'Desktop User',
        );

        await tester.tap(find.text('Accept'));
        await tester.pumpAndSettle();

        expect(find.text('RSVP submitted successfully!'), findsOneWidget);
      });
    });
  });
} 