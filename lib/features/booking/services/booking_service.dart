import 'package:flutter/foundation.dart';
import '../models/booking.dart';

class BookingService {
  Future<void> submitBooking(Booking booking) async {
    await Future.delayed(const Duration(milliseconds: 500));
    debugPrint('📅 Booking saved: ${booking.toJson()}');
    // TODO: Replace with Firestore integration
  }
}
