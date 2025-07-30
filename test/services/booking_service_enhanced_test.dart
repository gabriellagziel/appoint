import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appoint/services/booking_service.dart';
import 'package:appoint/models/booking_model.dart';
import 'package:appoint/models/user_profile.dart';
import '../mocks/firebase_mocks.dart';

// Generate mocks
@GenerateMocks([
  BookingService,
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  DocumentSnapshot,
  Query,
  QuerySnapshot
])
void main() {
  group('BookingService Enhanced Tests', () {
    late BookingService bookingService;
    late MockFirebaseFirestoreGenerated mockFirestore;
    late REDACTED_TOKEN mockCollection;
    late MockDocumentReferenceGenerated mockDocRef;
    late MockDocumentSnapshotGenerated mockDocSnapshot;
    late MockQueryGenerated mockQuery;
    late MockQuerySnapshotGenerated mockQuerySnapshot;

    setUp(() {
      mockFirestore = MockFirebaseFirestoreGenerated();
      mockCollection = REDACTED_TOKEN();
      mockDocRef = MockDocumentReferenceGenerated();
      mockDocSnapshot = MockDocumentSnapshotGenerated();
      mockQuery = MockQueryGenerated();
      mockQuerySnapshot = MockQuerySnapshotGenerated();

      bookingService = BookingService();
    });

    group('createBooking', () {
      test('should create booking successfully', () async {
        // Arrange
        final booking = BookingModel(
          id: 'booking-123',
          userId: 'user-123',
          providerId: 'provider-123',
          service: 'Child Care',
          startTime: DateTime.now().add(Duration(hours: 1)),
          endTime: DateTime.now().add(Duration(hours: 2)),
          status: BookingStatus.pending,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        when(mockFirestore.collection('bookings')).thenReturn(mockCollection);
        when(mockCollection.add(booking.toJson()))
            .thenAnswer((_) async => mockDocRef);
        when(mockDocRef.id).thenReturn('booking-123');

        // Act
        final result = await bookingService.createBooking(booking);

        // Assert
        expect(result, equals('booking-123'));
        verify(mockCollection.add(booking.toJson())).called(1);
      });

      test('should handle booking creation error', () async {
        // Arrange
        final booking = BookingModel(
          id: 'booking-123',
          userId: 'user-123',
          providerId: 'provider-123',
          service: 'Child Care',
          startTime: DateTime.now().add(Duration(hours: 1)),
          endTime: DateTime.now().add(Duration(hours: 2)),
          status: BookingStatus.pending,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        when(mockFirestore.collection('bookings')).thenReturn(mockCollection);
        when(mockCollection.add(booking.toJson()))
            .thenThrow(FirebaseException(plugin: 'firestore'));

        // Act & Assert
        expect(
          () => bookingService.createBooking(booking),
          throwsA(isA<FirebaseException>()),
        );
      });

      test('should validate booking data before creation', () async {
        // Arrange
        final invalidBooking = BookingModel(
          id: '',
          userId: '',
          providerId: '',
          service: '',
          startTime: DateTime.now(),
          endTime:
              DateTime.now().subtract(Duration(hours: 1)), // End before start
          status: BookingStatus.pending,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Act & Assert
        expect(
          () => bookingService.createBooking(invalidBooking),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('getUserBookings', () {
      test('should return user bookings successfully', () async {
        // Arrange
        const userId = 'user-123';
        final bookingData1 = {
          'id': 'booking-1',
          'userId': userId,
          'providerId': 'provider-1',
          'service': 'Child Care',
          'startTime': DateTime.now().add(Duration(hours: 1)).toIso8601String(),
          'endTime': DateTime.now().add(Duration(hours: 2)).toIso8601String(),
          'status': 'pending',
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        };

        final bookingData2 = {
          'id': 'booking-2',
          'userId': userId,
          'providerId': 'provider-2',
          'service': 'Elder Care',
          'startTime': DateTime.now().add(Duration(days: 1)).toIso8601String(),
          'endTime':
              DateTime.now().add(Duration(days: 1, hours: 1)).toIso8601String(),
          'status': 'confirmed',
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        };

        final mockDoc1 = MockDocumentSnapshotGenerated();
        final mockDoc2 = MockDocumentSnapshotGenerated();

        when(mockDoc1.id).thenReturn('booking-1');
        when(mockDoc1.data()).thenReturn(bookingData1);
        when(mockDoc2.id).thenReturn('booking-2');
        when(mockDoc2.data()).thenReturn(bookingData2);

        when(mockFirestore.collection('bookings')).thenReturn(mockCollection);
        when(mockCollection.where('userId', isEqualTo: userId))
            .thenReturn(mockQuery);
        when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
        when(mockQuerySnapshot.docs).thenReturn([mockDoc1, mockDoc2]);

        // Act
        final result = await bookingService.getUserBookings(userId);

        // Assert
        expect(result, hasLength(2));
        expect(result[0].id, equals('booking-1'));
        expect(result[0].service, equals('Child Care'));
        expect(result[1].id, equals('booking-2'));
        expect(result[1].service, equals('Elder Care'));
      });

      test('should return empty list when no bookings found', () async {
        // Arrange
        const userId = 'user-123';

        when(mockFirestore.collection('bookings')).thenReturn(mockCollection);
        when(mockCollection.where('userId', isEqualTo: userId))
            .thenReturn(mockQuery);
        when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
        when(mockQuerySnapshot.docs).thenReturn([]);

        // Act
        final result = await bookingService.getUserBookings(userId);

        // Assert
        expect(result, isEmpty);
      });

      test('should handle query error', () async {
        // Arrange
        const userId = 'user-123';

        when(mockFirestore.collection('bookings')).thenReturn(mockCollection);
        when(mockCollection.where('userId', isEqualTo: userId))
            .thenReturn(mockQuery);
        when(mockQuery.get()).thenThrow(FirebaseException(plugin: 'firestore'));

        // Act & Assert
        expect(
          () => bookingService.getUserBookings(userId),
          throwsA(isA<FirebaseException>()),
        );
      });
    });

    group('updateBookingStatus', () {
      test('should update booking status successfully', () async {
        // Arrange
        const bookingId = 'booking-123';
        const newStatus = BookingStatus.confirmed;

        when(mockFirestore.collection('bookings')).thenReturn(mockCollection);
        when(mockCollection.doc(bookingId)).thenReturn(mockDocRef);
        when(mockDocRef.update(
                {'status': newStatus.name, 'updatedAt': anyNamed('updatedAt')}))
            .thenAnswer((_) async => null);

        // Act
        await bookingService.updateBookingStatus(bookingId, newStatus);

        // Assert
        verify(mockDocRef.update({
          'status': newStatus.name,
          'updatedAt': anyNamed('updatedAt'),
        })).called(1);
      });

      test('should handle status update error', () async {
        // Arrange
        const bookingId = 'booking-123';
        const newStatus = BookingStatus.confirmed;

        when(mockFirestore.collection('bookings')).thenReturn(mockCollection);
        when(mockCollection.doc(bookingId)).thenReturn(mockDocRef);
        when(mockDocRef.update(
                {'status': newStatus.name, 'updatedAt': anyNamed('updatedAt')}))
            .thenThrow(FirebaseException(plugin: 'firestore'));

        // Act & Assert
        expect(
          () => bookingService.updateBookingStatus(bookingId, newStatus),
          throwsA(isA<FirebaseException>()),
        );
      });
    });

    group('cancelBooking', () {
      test('should cancel booking successfully', () async {
        // Arrange
        const bookingId = 'booking-123';

        when(mockFirestore.collection('bookings')).thenReturn(mockCollection);
        when(mockCollection.doc(bookingId)).thenReturn(mockDocRef);
        when(mockDocRef.update({
          'status': BookingStatus.cancelled.name,
          'updatedAt': anyNamed('updatedAt'),
        })).thenAnswer((_) async => null);

        // Act
        await bookingService.cancelBooking(bookingId);

        // Assert
        verify(mockDocRef.update({
          'status': BookingStatus.cancelled.name,
          'updatedAt': anyNamed('updatedAt'),
        })).called(1);
      });

      test('should handle cancellation error', () async {
        // Arrange
        const bookingId = 'booking-123';

        when(mockFirestore.collection('bookings')).thenReturn(mockCollection);
        when(mockCollection.doc(bookingId)).thenReturn(mockDocRef);
        when(mockDocRef.update({
          'status': BookingStatus.cancelled.name,
          'updatedAt': anyNamed('updatedAt'),
        })).thenThrow(FirebaseException(plugin: 'firestore'));

        // Act & Assert
        expect(
          () => bookingService.cancelBooking(bookingId),
          throwsA(isA<FirebaseException>()),
        );
      });
    });

    group('getBookingById', () {
      test('should return booking by id successfully', () async {
        // Arrange
        const bookingId = 'booking-123';
        final bookingData = {
          'id': bookingId,
          'userId': 'user-123',
          'providerId': 'provider-123',
          'service': 'Child Care',
          'startTime': DateTime.now().add(Duration(hours: 1)).toIso8601String(),
          'endTime': DateTime.now().add(Duration(hours: 2)).toIso8601String(),
          'status': 'pending',
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        };

        when(mockDocSnapshot.id).thenReturn(bookingId);
        when(mockDocSnapshot.data()).thenReturn(bookingData);
        when(mockDocSnapshot.exists).thenReturn(true);

        when(mockFirestore.collection('bookings')).thenReturn(mockCollection);
        when(mockCollection.doc(bookingId)).thenReturn(mockDocRef);
        when(mockDocRef.get()).thenAnswer((_) async => mockDocSnapshot);

        // Act
        final result = await bookingService.getBookingById(bookingId);

        // Assert
        expect(result, isNotNull);
        expect(result!.id, equals(bookingId));
        expect(result.service, equals('Child Care'));
      });

      test('should return null when booking not found', () async {
        // Arrange
        const bookingId = 'nonexistent-booking';

        when(mockDocSnapshot.exists).thenReturn(false);

        when(mockFirestore.collection('bookings')).thenReturn(mockCollection);
        when(mockCollection.doc(bookingId)).thenReturn(mockDocRef);
        when(mockDocRef.get()).thenAnswer((_) async => mockDocSnapshot);

        // Act
        final result = await bookingService.getBookingById(bookingId);

        // Assert
        expect(result, isNull);
      });

      test('should handle get booking error', () async {
        // Arrange
        const bookingId = 'booking-123';

        when(mockFirestore.collection('bookings')).thenReturn(mockCollection);
        when(mockCollection.doc(bookingId)).thenReturn(mockDocRef);
        when(mockDocRef.get())
            .thenThrow(FirebaseException(plugin: 'firestore'));

        // Act & Assert
        expect(
          () => bookingService.getBookingById(bookingId),
          throwsA(isA<FirebaseException>()),
        );
      });
    });

    group('checkBookingConflict', () {
      test('should detect booking conflict', () async {
        // Arrange
        final startTime = DateTime.now().add(Duration(hours: 1));
        final endTime = DateTime.now().add(Duration(hours: 2));
        const providerId = 'provider-123';

        final existingBookingData = {
          'id': 'existing-booking',
          'userId': 'user-456',
          'providerId': providerId,
          'startTime': startTime.toIso8601String(),
          'endTime': endTime.toIso8601String(),
          'status': 'confirmed',
        };

        final mockDoc = MockDocumentSnapshotGenerated();
        when(mockDoc.data()).thenReturn(existingBookingData);

        when(mockFirestore.collection('bookings')).thenReturn(mockCollection);
        when(mockCollection.where('providerId', isEqualTo: providerId))
            .thenReturn(mockQuery);
        when(mockQuery.where('status', whereIn: ['pending', 'confirmed']))
            .thenReturn(mockQuery);
        when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
        when(mockQuerySnapshot.docs).thenReturn([mockDoc]);

        // Act
        final hasConflict = await bookingService.checkBookingConflict(
          providerId: providerId,
          startTime: startTime,
          endTime: endTime,
        );

        // Assert
        expect(hasConflict, isTrue);
      });

      test('should not detect conflict when no overlapping bookings', () async {
        // Arrange
        final startTime = DateTime.now().add(Duration(hours: 1));
        final endTime = DateTime.now().add(Duration(hours: 2));
        const providerId = 'provider-123';

        when(mockFirestore.collection('bookings')).thenReturn(mockCollection);
        when(mockCollection.where('providerId', isEqualTo: providerId))
            .thenReturn(mockQuery);
        when(mockQuery.where('status', whereIn: ['pending', 'confirmed']))
            .thenReturn(mockQuery);
        when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
        when(mockQuerySnapshot.docs).thenReturn([]);

        // Act
        final hasConflict = await bookingService.checkBookingConflict(
          providerId: providerId,
          startTime: startTime,
          endTime: endTime,
        );

        // Assert
        expect(hasConflict, isFalse);
      });
    });

    group('getProviderBookings', () {
      test('should return provider bookings successfully', () async {
        // Arrange
        const providerId = 'provider-123';
        final bookingData1 = {
          'id': 'booking-1',
          'userId': 'user-1',
          'providerId': providerId,
          'service': 'Child Care',
          'startTime': DateTime.now().add(Duration(hours: 1)).toIso8601String(),
          'endTime': DateTime.now().add(Duration(hours: 2)).toIso8601String(),
          'status': 'pending',
        };

        final bookingData2 = {
          'id': 'booking-2',
          'userId': 'user-2',
          'providerId': providerId,
          'service': 'Elder Care',
          'startTime': DateTime.now().add(Duration(days: 1)).toIso8601String(),
          'endTime':
              DateTime.now().add(Duration(days: 1, hours: 1)).toIso8601String(),
          'status': 'confirmed',
        };

        final mockDoc1 = MockDocumentSnapshotGenerated();
        final mockDoc2 = MockDocumentSnapshotGenerated();

        when(mockDoc1.id).thenReturn('booking-1');
        when(mockDoc1.data()).thenReturn(bookingData1);
        when(mockDoc2.id).thenReturn('booking-2');
        when(mockDoc2.data()).thenReturn(bookingData2);

        when(mockFirestore.collection('bookings')).thenReturn(mockCollection);
        when(mockCollection.where('providerId', isEqualTo: providerId))
            .thenReturn(mockQuery);
        when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
        when(mockQuerySnapshot.docs).thenReturn([mockDoc1, mockDoc2]);

        // Act
        final result = await bookingService.getProviderBookings(providerId);

        // Assert
        expect(result, hasLength(2));
        expect(result[0].providerId, equals(providerId));
        expect(result[1].providerId, equals(providerId));
      });
    });

    group('booking validation', () {
      test('should validate booking time range', () {
        // Arrange
        final startTime = DateTime.now();
        final endTime = startTime.add(Duration(hours: 1));

        // Act
        final isValid =
            bookingService.isValidBookingTimeRange(startTime, endTime);

        // Assert
        expect(isValid, isTrue);
      });

      test('should reject invalid booking time range', () {
        // Arrange
        final startTime = DateTime.now();
        final endTime =
            startTime.subtract(Duration(hours: 1)); // End before start

        // Act
        final isValid =
            bookingService.isValidBookingTimeRange(startTime, endTime);

        // Assert
        expect(isValid, isFalse);
      });

      test('should validate booking duration', () {
        // Arrange
        final startTime = DateTime.now();
        final endTime = startTime.add(Duration(hours: 2));

        // Act
        final duration =
            bookingService.calculateBookingDuration(startTime, endTime);

        // Assert
        expect(duration.inHours, equals(2));
      });
    });
  });
}
