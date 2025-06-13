import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/booking.dart';

class BookingService {
  final CollectionReference bookingsRef =
      FirebaseFirestore.instance.collection('bookings');

  Future<void> submitBooking(Booking booking) async {
    await bookingsRef.add(booking.toJson());
  }
}
