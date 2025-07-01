import 'package:flutter_test/flutter_test.dart';

import 'package:appoint/features/booking/services/booking_service.dart';
import 'package:appoint/models/booking.dart';
import './fake_firebase_setup.dart';
import 'mocks/firebase_mocks.dart';

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await initializeTestFirebase();

  group('BookingService', () {
    late BookingService bookingService;
    late MockFirebaseFirestore firestore;
    late MockCollectionReference collection;
    late MockDocumentReference docRef;

    setUp(() {
      firestore = MockFirebaseFirestore();
      collection = MockCollectionReference();
      docRef = MockDocumentReference();
      when(firestore.collection('appointments')).thenReturn(collection);
      when(collection.add(any)).thenAnswer((_) async => docRef);
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

      await bookingService.createBooking(booking);

      verify(collection.add(booking.toJson())).called(1);
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

      verify(collection.add(shortBooking.toJson())).called(1);
      verify(collection.add(longBooking.toJson())).called(1);
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

      verify(collection.add(confirmedBooking.toJson())).called(1);
      verify(collection.add(pendingBooking.toJson())).called(1);
    });
  });
}
