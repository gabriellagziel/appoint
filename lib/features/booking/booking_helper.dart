import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/booking.dart';
import '../providers/selection_provider.dart';
import '../services/booking_service.dart';
import '../../providers/auth_provider.dart';
import '../../utils/snackbar_extensions.dart';

class BookingHelper {
  const BookingHelper._();

  static Future<void> submitBooking(BuildContext context, WidgetRef ref) async {
    try {
      final user = ref.read(authProvider).currentUser;
      final userId = user?.uid ?? '';
      if (userId.isEmpty) throw Exception('User not logged in');

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

      final booking = Booking(
        id: '',
        userId: userId,
        staffId: staffId,
        serviceId: serviceId,
        serviceName: serviceName ?? 'Unknown Service',
        dateTime: dateTime,
        duration: duration,
        notes: null,
        createdAt: DateTime.now(),
      );

      await ref.read(bookingServiceProvider).submitBooking(booking);

      if (!context.mounted) return;
      context.showSnackBar('Booking confirmed');
      Navigator.pop(context);
    } catch (e, st) {
      debugPrint('Error during booking: $e\n$st');
      if (!context.mounted) return;
      context.showSnackBar('Failed to confirm booking');
    }
  }
}
