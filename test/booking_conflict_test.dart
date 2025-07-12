import 'package:appoint/features/booking/services/booking_service.dart';
import 'package:appoint/models/booking.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'booking_conflict_test.mocks.dart';

@GenerateMocks([BookingService])
void main() {
  group('BookingService booking conflict edge cases', () {
    test('should detect conflict for two overlapping bookings', () async {
      mockBookingService = MockBookingService();
      final booking1 = Booking(
        id: '1',
        userId: 'userA',
        staffId: 'staff1',
        serviceId: 'service1',
        serviceName: 'Service',
        dateTime: DateTime(2024, 1, 1, 10),
        duration: const Duration(hours: 1),
        isConfirmed: true,
      );
      final booking2 = Booking(
        id: '2',
        userId: 'userB',
        staffId: 'staff1',
        serviceId: 'service1',
        serviceName: 'Service',
        dateTime: DateTime(2024, 1, 1, 10, 30),
        duration: const Duration(hours: 1),
        isConfirmed: true,
      );
      when(mockBookingService.getBookings())
          .thenAnswer((_) => Stream.value([booking1, booking2]));

      // Simulate a conflict check function
      bool hasConflict(List<Booking> bookings) {
        for (var i = 0; i < bookings.length; i++) {
          for (var j = i + 1; j < bookings.length; j++) {
            final a = bookings[i];
            final b = bookings[j];
            if (a.staffId == b.staffId) {
              final aStart = a.dateTime;
              aEnd = a.dateTime.add(a.duration);
              final bStart = b.dateTime;
              bEnd = b.dateTime.add(b.duration);
              if (aStart.isBefore(bEnd) && bStart.isBefore(aEnd)) {
                return true;
              }
            }
          }
        }
        return false;
      }

      bookingsStream = mockBookingService.getBookings();
      final bookings = await bookingsStream.first;
      conflict = hasConflict(bookings);
      expect(conflict, isTrue);
    });
  });
}
