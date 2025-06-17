import 'package:appoint/features/booking/services/booking_service.dart';
import 'package:appoint/models/booking.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('createBooking completes without error', () async {
    final service = BookingService();
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
    await service.createBooking(booking);
    expect(true, isTrue); // If no error, test passes
  });
}
