import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/booking.dart';
import 'package:flutter/foundation.dart';

final bookingServiceProvider = Provider<BookingService>((ref) {
  return BookingService();
});

class BookingService {
  final _firestore = FirebaseFirestore.instance;
  final _bookingsCollection = 'appointments';

  /// Creates a new booking in Firestore
  Future<void> createBooking(Booking booking) async {
    try {
      await _firestore.collection('appointments').add(booking.toJson());
      print('✅ Booking created successfully: ${booking.toJson()}');
    } catch (e, st) {
      print('❌ Error creating booking: $e');
      print(st);
      rethrow;
    }
  }

  /// Gets a stream of all bookings
  Stream<List<Booking>> getBookings() {
    return _firestore.collection(_bookingsCollection).snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => Booking.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  /// Submits a booking to Firestore
  Future<void> submitBooking(Booking booking) async {
    try {
      final docRef = _firestore.collection(_bookingsCollection).doc();
      final bookingWithId = booking.copyWith(id: docRef.id);
      await docRef.set(bookingWithId.toJson());
    } catch (e, st) {
      debugPrint('Error submitting booking: $e\n$st');
      rethrow;
    }
  }

  /// Gets all bookings for a specific user
  Future<List<Booking>> getBookingsForUser(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('appointments')
          .where('userId', isEqualTo: userId)
          .orderBy('startTime')
          .get();

      return snapshot.docs.map((doc) => Booking.fromJson(doc.data())).toList();
    } catch (e, st) {
      print('❌ Error getting user bookings: $e');
      print(st);
      return [];
    }
  }

  /// Cancels a booking by its ID
  Future<void> cancelBooking(String bookingId) async {
    try {
      await _firestore.collection(_bookingsCollection).doc(bookingId).delete();
    } catch (e, st) {
      debugPrint('Error canceling booking: $e\n$st');
      rethrow;
    }
  }
}
