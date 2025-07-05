import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:appoint/services/user_deletion_service.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_test_config.dart';

void main() {
  group('UserDeletionService', () {
    late FakeFirebaseFirestore fakeFirestore;
    late MockFirebaseAuth mockAuth;
    late MockUser mockUser;
    late UserDeletionService service;

    setUpAll(() async => await setupFirebaseMocks());

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      mockUser = MockUser(
        uid: 'test-user-id',
        email: 'test@example.com',
        isAnonymous: false,
      );
      mockAuth = MockFirebaseAuth(mockUser: mockUser);
      service = UserDeletionService();
    });

    group('deleteCurrentUser', () {
      test('should delete user data and sign out', () async {
        // Arrange - Create test data
        await fakeFirestore.collection('users').doc('test-user-id').set({
          'name': 'Test User',
          'email': 'test@example.com',
        });

        await fakeFirestore.collection('bookings').add({
          'userId': 'test-user-id',
          'businessId': 'business-1',
          'date': '2024-01-01',
        });

        await fakeFirestore.collection('messages').add({
          'userId': 'test-user-id',
          'businessId': 'business-1',
          'message': 'Test message',
        });

        // Act
        await service.deleteCurrentUser();

        // Assert - Verify user data is deleted
        final userDoc =
            await fakeFirestore.collection('users').doc('test-user-id').get();
        expect(userDoc.exists, isFalse);

        final bookings = await fakeFirestore.collection('bookings').get();
        expect(bookings.docs, isEmpty);

        final messages = await fakeFirestore.collection('messages').get();
        expect(messages.docs, isEmpty);
      });

      test('should throw exception when no user is authenticated', () async {
        // Arrange - No authenticated user
        final unauthenticatedAuth = MockFirebaseAuth();
        final unauthenticatedService = UserDeletionService();

        // Act & Assert
        expect(
          () => unauthenticatedService.deleteCurrentUser(),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('_deleteUserData', () {
      test('should delete all user-related data', () async {
        // Arrange - Create comprehensive test data
        final userId = 'test-user-id';

        // User profile
        await fakeFirestore.collection('users').doc(userId).set({
          'name': 'Test User',
          'email': 'test@example.com',
        });

        // User settings
        await fakeFirestore
            .collection('users')
            .doc(userId)
            .collection('settings')
            .doc('notifications')
            .set({
          'push': true,
          'email': true,
        });

        // Business profile
        await fakeFirestore.collection('business_profiles').doc(userId).set({
          'name': 'Test Business',
          'description': 'Test business description',
        });

        // Business settings
        await fakeFirestore.collection('businessSettings').doc(userId).set({
          'notificationsEnabled': true,
          'autoConfirmBookings': false,
        });

        // Bookings as client
        await fakeFirestore.collection('bookings').add({
          'userId': userId,
          'businessId': 'business-1',
          'date': '2024-01-01',
        });

        // Bookings as business owner
        await fakeFirestore.collection('bookings').add({
          'userId': 'client-1',
          'businessId': userId,
          'date': '2024-01-01',
        });

        // Chat messages as user
        await fakeFirestore.collection('messages').add({
          'userId': userId,
          'businessId': 'business-1',
          'message': 'Test message from user',
        });

        // Chat messages as business
        await fakeFirestore.collection('messages').add({
          'userId': 'client-1',
          'businessId': userId,
          'message': 'Test message to business',
        });

        // Personal appointments
        await fakeFirestore.collection('personalAppointments').add({
          'userId': userId,
          'title': 'Test appointment',
          'date': '2024-01-01',
        });

        // Notifications
        await fakeFirestore.collection('notifications').add({
          'userId': userId,
          'title': 'Test notification',
          'message': 'Test notification message',
        });

        // Payments
        await fakeFirestore.collection('payments').add({
          'userId': userId,
          'amount': 100,
          'status': 'completed',
        });

        // Ambassador record
        await fakeFirestore.collection('ambassadors').add({
          'userId': userId,
          'status': 'active',
        });

        // Family invitations as parent
        await fakeFirestore.collection('family_invitations').add({
          'parentId': userId,
          'childId': 'child-1',
          'status': 'pending',
        });

        // Family invitations as child
        await fakeFirestore.collection('family_invitations').add({
          'parentId': 'parent-1',
          'childId': userId,
          'status': 'pending',
        });

        // Playtime sessions
        await fakeFirestore.collection('playtime_sessions').add({
          'userId': userId,
          'gameId': 'game-1',
          'duration': 30,
        });

        // Survey responses
        await fakeFirestore.collection('surveys').add({
          'title': 'Test Survey',
          'status': 'active',
        });

        final surveyDoc = await fakeFirestore.collection('surveys').get();
        final surveyId = surveyDoc.docs.first.id;

        await fakeFirestore
            .collection('surveys')
            .doc(surveyId)
            .collection('responses')
            .add({
          'userId': userId,
          'response': {'question1': 'answer1'},
        });

        // Act
        await service.deleteCurrentUser();

        // Assert - Verify all data is deleted
        final userDoc =
            await fakeFirestore.collection('users').doc(userId).get();
        expect(userDoc.exists, isFalse);

        final userSettingsDoc = await fakeFirestore
            .collection('users')
            .doc(userId)
            .collection('settings')
            .doc('notifications')
            .get();
        expect(userSettingsDoc.exists, isFalse);

        final businessProfileDoc = await fakeFirestore
            .collection('business_profiles')
            .doc(userId)
            .get();
        expect(businessProfileDoc.exists, isFalse);

        final businessSettingsDoc = await fakeFirestore
            .collection('businessSettings')
            .doc(userId)
            .get();
        expect(businessSettingsDoc.exists, isFalse);

        final bookings = await fakeFirestore.collection('bookings').get();
        expect(bookings.docs, isEmpty);

        final messages = await fakeFirestore.collection('messages').get();
        expect(messages.docs, isEmpty);

        final personalAppointments =
            await fakeFirestore.collection('personalAppointments').get();
        expect(personalAppointments.docs, isEmpty);

        final notifications =
            await fakeFirestore.collection('notifications').get();
        expect(notifications.docs, isEmpty);

        final payments = await fakeFirestore.collection('payments').get();
        expect(payments.docs, isEmpty);

        final ambassadors = await fakeFirestore.collection('ambassadors').get();
        expect(ambassadors.docs, isEmpty);

        final familyInvitations =
            await fakeFirestore.collection('family_invitations').get();
        expect(familyInvitations.docs, isEmpty);

        final playtimeSessions =
            await fakeFirestore.collection('playtime_sessions').get();
        expect(playtimeSessions.docs, isEmpty);

        final surveyResponses = await fakeFirestore
            .collection('surveys')
            .doc(surveyId)
            .collection('responses')
            .get();
        expect(surveyResponses.docs, isEmpty);
      });
    });
  });
}
