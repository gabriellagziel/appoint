import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/booking.dart';
import '../providers/selection_provider.dart';
import '../services/booking_service.dart';
import '../../providers/auth_provider.dart';

class BookingHelper {
  final WidgetRef ref;
  BookingHelper(this.ref);

  String get _userId {
    final user = ref.read(authProvider).currentUser;
    final userId = user?.uid ?? '';
    if (userId.isEmpty) throw Exception('User not logged in');
    return userId;
  }

  Booking _buildBooking() {
    final staffId = ref.read(staffSelectionProvider);
    final serviceId = ref.read(serviceSelectionProvider);
    final serviceName = ref.read(serviceNameProvider);
    final dateTime = ref.read(selectedSlotProvider);
    final duration = ref.read(serviceDurationProvider);

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
      notes: null,
      createdAt: DateTime.now(),
    );
  }

  Future<void> submitBooking() async {
    final booking = _buildBooking();
    await ref.read(bookingServiceProvider).submitBooking(booking);
  }
}

