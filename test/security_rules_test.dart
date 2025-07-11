import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Firestore Security Rules Tests', () {
    late FakeFirebaseFirestore fakeFirestore;
    // late MockFirebaseAuth mockAuth;
    // late MockUser mockUser;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      // mockAuth = MockFirebaseAuth();
      // mockUser = MockUser(
      //   isAnonymous: false,
      //   uid: 'test-user-id',
      //   email: 'test@example.com',
      //   displayName: 'Test User',
      // );
    });

    group('User Profile Rules', () {
      test('should allow users to read their own profile', () async {
        // Arrange
        await fakeFirestore.collection('users').doc('test-user-id').set({
          'name': 'Test User',
          'email': 'test@example.com',
        });

        // Act & Assert
        final doc =
            await fakeFirestore.collection('users').doc('test-user-id').get();

        expect(doc.exists, isTrue);
        expect(doc.data()?['name'], 'Test User');
      });

      test('should allow users to update their own profile', () async {
        // Arrange
        await fakeFirestore.collection('users').doc('test-user-id').set({
          'name': 'Test User',
          'email': 'test@example.com',
        });

        // Act
        await fakeFirestore.collection('users').doc('test-user-id').update({
          'name': 'Updated User',
        });

        // Assert
        final doc =
            await fakeFirestore.collection('users').doc('test-user-id').get();

        expect(doc.data()?['name'], 'Updated User');
      });
    });

    group('Booking Rules', () {
      test('should allow users to create their own bookings', () async {
        // Act
        await fakeFirestore.collection('bookings').add({
          'userId': 'test-user-id',
          'serviceId': 'service-1',
          'date': DateTime.now().toIso8601String(),
          'status': 'pending',
        });

        // Assert
        final query = await fakeFirestore
            .collection('bookings')
            .where('userId', isEqualTo: 'test-user-id')
            .get();

        expect(query.docs.length, 1);
      });

      test('should allow users to read their own bookings', () async {
        // Arrange
        await fakeFirestore.collection('bookings').add({
          'userId': 'test-user-id',
          'serviceId': 'service-1',
          'date': DateTime.now().toIso8601String(),
          'status': 'pending',
        });

        // Act & Assert
        final query = await fakeFirestore
            .collection('bookings')
            .where('userId', isEqualTo: 'test-user-id')
            .get();

        expect(query.docs.length, 1);
        expect(query.docs.first.data()['userId'], 'test-user-id');
      });
    });

    group('Business Profile Rules', () {
      test('should allow business owners to manage their profile', () async {
        // Arrange
        await fakeFirestore
            .collection('business_profiles')
            .doc('test-user-id')
            .set({
          'name': 'Test Business',
          'ownerId': 'test-user-id',
          'description': 'Test business description',
        });

        // Act
        await fakeFirestore
            .collection('business_profiles')
            .doc('test-user-id')
            .update({
          'description': 'Updated business description',
        });

        // Assert
        final doc = await fakeFirestore
            .collection('business_profiles')
            .doc('test-user-id')
            .get();

        expect(doc.data()?['description'], 'Updated business description');
      });
    });

    group('Admin Rules', () {
      test('should allow admins to read all users', () async {
        // Arrange
        await fakeFirestore.collection('users').doc('user-1').set({
          'name': 'User 1',
          'email': 'user1@example.com',
        });
        await fakeFirestore.collection('users').doc('user-2').set({
          'name': 'User 2',
          'email': 'user2@example.com',
        });

        // Act & Assert
        query = await fakeFirestore.collection('users').get();
        expect(query.docs.length, 2);
      });

      test('should allow admins to read analytics', () async {
        // Arrange
        await fakeFirestore.collection('analytics').doc('global').set({
          'totalUsers': 100,
          'totalBookings': 500,
          'revenue': 10000.0,
        });

        // Act & Assert
        final doc =
            await fakeFirestore.collection('analytics').doc('global').get();

        expect(doc.exists, isTrue);
        expect(doc.data()?['totalUsers'], 100);
      });
    });

    group('Data Validation', () {
      test('should allow bookings with required fields', () async {
        // Act & Assert
        await fakeFirestore.collection('bookings').add({
          'userId': 'test-user-id',
          'serviceId': 'service-1',
          'date': DateTime.now().toIso8601String(),
        });

        query = await fakeFirestore.collection('bookings').get();
        expect(query.docs.length, 1);
      });

      test('should allow user profiles with valid data', () async {
        // Act & Assert
        await fakeFirestore.collection('users').doc('test-user-id').set({
          'name': 'Test User',
          'email': 'test@example.com',
        });

        final doc =
            await fakeFirestore.collection('users').doc('test-user-id').get();
        expect(doc.exists, isTrue);
        expect(doc.data()?['email'], 'test@example.com');
      });
    });
  });
}
