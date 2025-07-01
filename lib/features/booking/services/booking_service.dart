import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/models/booking.dart';

final bookingServiceProvider = Provider<BookingService>((final ref) {
  return BookingService();
});

class BookingService {
  final FirebaseFirestore _firestore;
  final _bookingsCollection = 'appointments';

  BookingService({final FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Creates a new booking in Firestore
  Future<void> createBooking(final Booking booking) async {
    try {
      await _firestore.collection('appointments').add(booking.toJson());
    } catch (e) {
      // Removed debug print: print('❌ Error creating booking: $e');
      // Removed debug print: print(st);
      rethrow;
    }
  }

  /// Gets a stream of all bookings
  Stream<List<Booking>> getBookings() {
    return _firestore.collection(_bookingsCollection).snapshots().map(
        (final snapshot) => snapshot.docs
            .map((final doc) => Booking.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  /// Submits a booking to Firestore
  Future<void> submitBooking(final Booking booking) async {
    try {
      final docRef = _firestore.collection(_bookingsCollection).doc();
      final bookingWithId = booking.copyWith(id: docRef.id);
      await docRef.set(bookingWithId.toJson());
    } catch (e) {
      // Removed debug print: debugPrint('Error submitting booking: $e\n$st');
      rethrow;
    }
  }

  /// Gets all bookings for a specific user
  Future<List<Booking>> getBookingsForUser(final String userId) async {
    try {
      final snapshot = await _firestore
          .collection('appointments')
          .where('userId', isEqualTo: userId)
          .orderBy('startTime')
          .get();

      return snapshot.docs
          .map((final doc) => Booking.fromJson(doc.data()))
          .toList();
    } catch (e) {
      // Removed debug print: print('❌ Error getting user bookings: $e');
      // Removed debug print: print(st);
      return [];
    }
  }

  /// Cancels a booking by its ID
  Future<void> cancelBooking(final String bookingId) async {
    try {
      await _firestore.collection(_bookingsCollection).doc(bookingId).delete();
    } catch (e) {
      // Removed debug print: debugPrint('Error canceling booking: $e\n$st');
      rethrow;
    }
  }

  /// Gets a stream of bookings for a specific user
  Stream<List<Booking>> getUserBookings(final String userId) {
    return _firestore
        .collection(_bookingsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('startTime')
        .snapshots()
        .map((final snapshot) => snapshot.docs
            .map((final doc) => Booking.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  /// Gets a stream of bookings for a specific business
  Stream<List<Booking>> getBusinessBookings(final String businessId) {
    return _firestore
        .collection(_bookingsCollection)
        .where('businessProfileId', isEqualTo: businessId)
        .orderBy('startTime')
        .snapshots()
        .map((final snapshot) => snapshot.docs
            .map((final doc) => Booking.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  /// Get a booking by its ID
  Future<Booking?> getBookingById(final String bookingId) async {
    try {
      final doc =
          await _firestore.collection(_bookingsCollection).doc(bookingId).get();
      if (!doc.exists) return null;
      return Booking.fromJson({...doc.data()!, 'id': doc.id});
    } catch (e) {
      return null;
    }
  }

  /// Update an existing booking
  Future<void> updateBooking(final Booking booking) async {
    try {
      await _firestore
          .collection(_bookingsCollection)
          .doc(booking.id)
          .update(booking.toJson());
    } catch (e) {
      rethrow;
    }
  }
}
