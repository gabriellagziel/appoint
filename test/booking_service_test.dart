import 'package:appoint/features/booking/services/booking_service.dart';
import 'package:appoint/models/booking.dart';
import 'package:flutter_test/flutter_test.dart';
import './test_setup.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await registerFirebaseMock();
  });

  group('BookingService', () {
    late BookingService bookingService;
    late MockFirebaseFirestore mockFirestore;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      when(mockFirestore.collection('appointments'))
          .thenReturn(MockCollectionReference());
      when(mockFirestore.collection('users'))
          .thenReturn(MockCollectionReference());
      when(mockFirestore.collection('admin_broadcasts'))
          .thenReturn(MockCollectionReference());
      when(mockFirestore.collection('share_analytics'))
          .thenReturn(MockCollectionReference());
      when(mockFirestore.collection('group_recognition'))
          .thenReturn(MockCollectionReference());
      when(mockFirestore.collection('invites'))
          .thenReturn(MockCollectionReference());
      when(mockFirestore.collection('payments'))
          .thenReturn(MockCollectionReference());
      when(mockFirestore.collection('organizations'))
          .thenReturn(MockCollectionReference());
      when(mockFirestore.collection('analytics'))
          .thenReturn(MockCollectionReference());
      when(mockFirestore.collection('family_links'))
          .thenReturn(MockCollectionReference());
      when(mockFirestore.collection('family_analytics'))
          .thenReturn(MockCollectionReference());
      when(mockFirestore.collection('privacy_requests'))
          .thenReturn(MockCollectionReference());
      when(mockFirestore.collection('calendar_events'))
          .thenReturn(MockCollectionReference());
      when(mockFirestore.collection('callRequests'))
          .thenReturn(MockCollectionReference());
      bookingService = BookingService(firestore: mockFirestore);
    });

    test('should be instantiated correctly', () {
      expect(bookingService, isA<BookingService>());
    });

    test('should have required methods', () {
      expect(bookingService.createBooking, isA<Function>());
    });

    test('createBooking should complete without error', () async {
      final booking = Booking(
        id: 'test-id',
        userId: 'user-1',
        staffId: 'staff-1',
        serviceId: 'service-1',
        serviceName: 'Test Service',
        dateTime: DateTime(2025, 6, 18, 10, 0),
        duration: Duration(hours: 1),
        notes: 'Test booking',
        isConfirmed: false,
        createdAt: DateTime(2025, 6, 17),
      );

      // Should complete without throwing
      await bookingService.createBooking(booking);
      expect(true, isTrue); // If no error, test passes
    });

    test('createBooking should return a Future<void>', () async {
      final booking = Booking(
        id: 'test-id-2',
        userId: 'user-1',
        staffId: 'staff-1',
        serviceId: 'service-1',
        serviceName: 'Test Service',
        dateTime: DateTime(2025, 6, 18, 10, 0),
        duration: Duration(hours: 1),
        notes: 'Test booking',
        isConfirmed: false,
        createdAt: DateTime(2025, 6, 17),
      );

      final result = bookingService.createBooking(booking);
      expect(result, isA<Future>());
    });

    test('should handle booking with different durations', () async {
      final shortBooking = Booking(
        id: 'test-short',
        userId: 'user-1',
        staffId: 'staff-1',
        serviceId: 'service-1',
        serviceName: 'Short Service',
        dateTime: DateTime(2025, 6, 18, 10, 0),
        duration: Duration(minutes: 30),
        notes: 'Short booking',
        isConfirmed: false,
        createdAt: DateTime(2025, 6, 17),
      );

      final longBooking = Booking(
        id: 'test-long',
        userId: 'user-1',
        staffId: 'staff-1',
        serviceId: 'service-1',
        serviceName: 'Long Service',
        dateTime: DateTime(2025, 6, 18, 10, 0),
        duration: Duration(hours: 2),
        notes: 'Long booking',
        isConfirmed: false,
        createdAt: DateTime(2025, 6, 17),
      );

      await bookingService.createBooking(shortBooking);
      await bookingService.createBooking(longBooking);
      expect(true, isTrue); // If no error, test passes
    });

    test('should handle booking with different confirmation statuses',
        () async {
      final confirmedBooking = Booking(
        id: 'test-confirmed',
        userId: 'user-1',
        staffId: 'staff-1',
        serviceId: 'service-1',
        serviceName: 'Confirmed Service',
        dateTime: DateTime(2025, 6, 18, 10, 0),
        duration: Duration(hours: 1),
        notes: 'Confirmed booking',
        isConfirmed: true,
        createdAt: DateTime(2025, 6, 17),
      );

      final pendingBooking = Booking(
        id: 'test-pending',
        userId: 'user-1',
        staffId: 'staff-1',
        serviceId: 'service-1',
        serviceName: 'Pending Service',
        dateTime: DateTime(2025, 6, 18, 10, 0),
        duration: Duration(hours: 1),
        notes: 'Pending booking',
        isConfirmed: false,
        createdAt: DateTime(2025, 6, 17),
      );

      await bookingService.createBooking(confirmedBooking);
      await bookingService.createBooking(pendingBooking);
      expect(true, isTrue); // If no error, test passes
    });
  });
}
