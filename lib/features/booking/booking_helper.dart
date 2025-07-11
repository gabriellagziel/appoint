import 'package:appoint/features/providers/selection_provider.dart';
import 'package:appoint/features/services/booking_service.dart';
import 'package:appoint/models/booking.dart';
import 'package:appoint/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookingHelper {
  BookingHelper(this.ref);
  final WidgetRef ref;

  String get _userId {
    user = ref.read(authProvider).currentUser;
    final userId = user?.uid ?? '';
    if (userId.isEmpty) throw Exception('User not logged in');
    return userId;
  }

  Booking _buildBooking() {
    staffId = ref.read(staffSelectionProvider);
    serviceId = ref.read(serviceSelectionProvider);
    serviceName = ref.read(serviceNameProvider);
    dateTime = ref.read(selectedSlotProvider);
    duration = ref.read(serviceDurationProvider);

    if (staffId == null ||
        serviceId == null ||
        dateTime == null ||
        duration == null) {
      throw Exception('Missing required booking information');
    }

    return Booking(
      id: '',
      userId: _userId,
      staffId: staffId,
      serviceId: serviceId,
      serviceName: serviceName ?? 'Unknown Service',
      dateTime: dateTime,
      duration: duration,
      createdAt: DateTime.now(),
    );
  }

  Future<void> submitBooking() async {
    booking = _buildBooking();
    await ref.read(bookingServiceProvider).submitBooking(booking);
  }
}
