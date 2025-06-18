import 'package:appoint/features/booking/services/booking_service.dart';
import 'package:appoint/models/booking.dart';
import 'package:flutter_test/flutter_test.dart';
import './test_setup.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}
class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}
class FakeCollectionReference extends Fake
    implements CollectionReference<Map<String, dynamic>> {
  @override
  Future<DocumentReference<Map<String, dynamic>>> add(
          Map<String, dynamic> data) async => FakeDocumentReference();
}

class FakeDocumentReference extends Fake
    implements DocumentReference<Map<String, dynamic>> {}

class FakeFirebaseFirestore extends Fake implements FirebaseFirestore {
  @override
  CollectionReference<Map<String, dynamic>> collection(String path) {
    return FakeCollectionReference();
  }
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await registerFirebaseMock();
  });

  group('BookingService', () {
    late BookingService bookingService;
    late FirebaseFirestore firestore;

    setUp(() {
      firestore = FakeFirebaseFirestore();
      bookingService = BookingService(firestore: firestore);
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
