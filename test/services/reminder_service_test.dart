import 'package:appoint/models/reminder.dart';
import 'package:appoint/models/reminder_analytics.dart';
import 'package:appoint/services/reminder_service.dart';
import 'package:appoint/services/business_subscription_service.dart';
import 'package:appoint/services/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockUser extends Mock implements User {}
class MockBusinessSubscriptionService extends Mock implements BusinessSubscriptionService {}
class MockNotificationService extends Mock implements NotificationService {}

void main() {
  group('ReminderService', () {
    late ReminderService reminderService;
    late FakeFirebaseFirestore fakeFirestore;
    late MockFirebaseAuth mockAuth;
    late MockUser mockUser;
    late MockBusinessSubscriptionService mockSubscriptionService;
    late MockNotificationService mockNotificationService;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      mockAuth = MockFirebaseAuth();
      mockUser = MockUser();
      mockSubscriptionService = MockBusinessSubscriptionService();
      mockNotificationService = MockNotificationService();

      when(() => mockUser.uid).thenReturn('test-user-id');
      when(() => mockAuth.currentUser).thenReturn(mockUser);
      when(() => mockNotificationService.initialize()).thenAnswer((_) async {});

      reminderService = ReminderService(
        firestore: fakeFirestore,
        auth: mockAuth,
        subscriptionService: mockSubscriptionService,
        notificationService: mockNotificationService,
      );
    });

    group('createReminder', () {
      test('should create time-based reminder successfully', () async {
        // Arrange
        final triggerTime = DateTime.now().add(const Duration(hours: 1));

        // Act
        final reminder = await reminderService.createReminder(
          title: 'Test Reminder',
          description: 'Test Description',
          type: ReminderType.timeBased,
          triggerTime: triggerTime,
          priority: ReminderPriority.high,
        );

        // Assert
        expect(reminder.title, 'Test Reminder');
        expect(reminder.description, 'Test Description');
        expect(reminder.type, ReminderType.timeBased);
        expect(reminder.triggerTime, triggerTime);
        expect(reminder.priority, ReminderPriority.high);
        expect(reminder.status, ReminderStatus.active);
        expect(reminder.userId, 'test-user-id');

        // Verify reminder was saved to Firestore
        final remindersCollection = fakeFirestore.collection('reminders');
        final reminderDoc = await remindersCollection.doc(reminder.id).get();
        expect(reminderDoc.exists, true);
      });

      test('should enforce subscription restrictions for location-based reminders', () async {
        // Arrange
        when(() => mockSubscriptionService.canLoadMap()).thenAnswer((_) async => false);

        // Act & Assert
        expect(
          () => reminderService.createReminder(
            title: 'Location Reminder',
            description: 'Test Description',
            type: ReminderType.locationBased,
            location: const ReminderLocation(
              latitude: 37.7749,
              longitude: -122.4194,
              address: 'Test Address',
            ),
          ),
          throwsA(isA<REDACTED_TOKEN>()),
        );

        verify(() => mockSubscriptionService.canLoadMap()).called(1);
      });

      test('should allow location-based reminders for paid users', () async {
        // Arrange
        when(() => mockSubscriptionService.canLoadMap()).thenAnswer((_) async => true);
        when(() => mockSubscriptionService.recordMapUsage()).thenAnswer((_) async {});

        const location = ReminderLocation(
          latitude: 37.7749,
          longitude: -122.4194,
          address: 'Test Address',
          name: 'Test Location',
        );

        // Act
        final reminder = await reminderService.createReminder(
          title: 'Location Reminder',
          description: 'Test Description',
          type: ReminderType.locationBased,
          location: location,
        );

        // Assert
        expect(reminder.type, ReminderType.locationBased);
        expect(reminder.location, location);
        verify(() => mockSubscriptionService.canLoadMap()).called(1);
        verify(() => mockSubscriptionService.recordMapUsage()).called(1);
      });

      test('should require authentication', () async {
        // Arrange
        when(() => mockAuth.currentUser).thenReturn(null);

        // Act & Assert
        expect(
          () => reminderService.createReminder(
            title: 'Test',
            description: 'Test',
            type: ReminderType.timeBased,
          ),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('subscription enforcement', () {
      test('canCreateLocationReminders should return true for paid users', () async {
        // Arrange
        when(() => mockSubscriptionService.canLoadMap()).thenAnswer((_) async => true);

        // Act
        final canCreate = await reminderService.canCreateLocationReminders();

        // Assert
        expect(canCreate, true);
        verify(() => mockSubscriptionService.canLoadMap()).called(1);
      });

      test('canCreateLocationReminders should return false for free users', () async {
        // Arrange
        when(() => mockSubscriptionService.canLoadMap()).thenAnswer((_) async => false);

        // Act
        final canCreate = await reminderService.canCreateLocationReminders();

        // Assert
        expect(canCreate, false);
        verify(() => mockSubscriptionService.canLoadMap()).called(1);
      });
    });

    group('reminder actions', () {
      test('should complete reminder and track analytics', () async {
        // Arrange
        const reminderId = 'test-reminder-id';
        await fakeFirestore.collection('reminders').doc(reminderId).set({
          'id': reminderId,
          'userId': 'test-user-id',
          'title': 'Test Reminder',
          'description': 'Test',
          'type': 'timeBased',
          'status': 'active',
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
          'isCompleted': false,
          'notificationsEnabled': true,
          'snoozeCount': 0,
          'tags': [],
          'priority': 'medium',
          'notificationMethods': ['push', 'local'],
        });

        // Act
        await reminderService.completeReminder(reminderId);

        // Assert
        final reminderDoc = await fakeFirestore.collection('reminders').doc(reminderId).get();
        final reminderData = reminderDoc.data() as Map<String, dynamic>;
        expect(reminderData['status'], 'completed');
        expect(reminderData['isCompleted'], true);
        expect(reminderData['completedAt'], isNotNull);
      });

      test('should snooze reminder and increment snooze count', () async {
        // Arrange
        const reminderId = 'test-reminder-id';
        await fakeFirestore.collection('reminders').doc(reminderId).set({
          'id': reminderId,
          'userId': 'test-user-id',
          'title': 'Test Reminder',
          'description': 'Test',
          'type': 'timeBased',
          'status': 'active',
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
          'isCompleted': false,
          'notificationsEnabled': true,
          'snoozeCount': 0,
          'tags': [],
          'priority': 'medium',
          'notificationMethods': ['push', 'local'],
        });

        final snoozeDuration = const Duration(minutes: 15);

        // Act
        await reminderService.snoozeReminder(reminderId, snoozeDuration);

        // Assert
        final reminderDoc = await fakeFirestore.collection('reminders').doc(reminderId).get();
        final reminderData = reminderDoc.data() as Map<String, dynamic>;
        expect(reminderData['status'], 'snoozed');
        expect(reminderData['snoozeCount'], 1);
        expect(reminderData['snoozedUntil'], isNotNull);
      });
    });
  });
}