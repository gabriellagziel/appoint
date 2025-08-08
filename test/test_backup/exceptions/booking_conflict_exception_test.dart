import 'package:appoint/exceptions/booking_conflict_exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BookingConflictException', () {
    test('should create exception with required parameters', () {
      localTime = DateTime(2023, 1, 1, 10);
      remoteTime = DateTime(2023, 1, 1, 11);

      final exception = BookingConflictException(
        bookingId: 'test-booking-123',
        localUpdatedAt: localTime,
        remoteUpdatedAt: remoteTime,
        message: 'Test conflict message',
      );

      expect(exception.bookingId, equals('test-booking-123'));
      expect(exception.localUpdatedAt, equals(localTime));
      expect(exception.remoteUpdatedAt, equals(remoteTime));
      expect(exception.message, equals('Test conflict message'));
    });

    test('should use default message when not provided', () {
      final exception = BookingConflictException(
        bookingId: 'test-booking-123',
        localUpdatedAt: DateTime.now(),
        remoteUpdatedAt: DateTime.now(),
      );

      expect(exception.message, equals('Booking conflict detected.'));
    });

    test('should provide meaningful string representation', () {
      localTime = DateTime(2023, 1, 1, 10);
      remoteTime = DateTime(2023, 1, 1, 11);

      final exception = BookingConflictException(
        bookingId: 'test-booking-123',
        localUpdatedAt: localTime,
        remoteUpdatedAt: remoteTime,
        message: 'Server cancelled booking',
      );

      stringRep = exception.toString();
      expect(stringRep, contains('BookingConflictException'));
      expect(stringRep, contains('test-booking-123'));
      expect(stringRep, contains('Server cancelled booking'));
      expect(stringRep, contains('2023-01-01 10:00:00'));
      expect(stringRep, contains('2023-01-01 11:00:00'));
    });
  });
}
