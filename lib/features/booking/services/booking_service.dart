import 'package:appoint/models/booking.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bookingServiceProvider = Provider<BookingService>((ref) => BookingService());

class BookingService {

  BookingService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;
  final FirebaseFirestore _firestore;
  final _bookingsCollection = 'appointments';

  /// Creates a new booking in Firestore
  Future<void> createBooking(Booking booking) async {
    try {
      await _firestore.collection('appointments').add(booking.toJson());
    } catch (e) {
      rethrow;
    }
  }

  /// Gets a stream of all bookings
  Stream<List<Booking>> getBookings() => _firestore.collection(_bookingsCollection).snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => Booking.fromJson({...doc.data(), 'id': doc.id}))
            .toList(),);

  /// Submits a booking to Firestore
  Future<void> submitBooking(Booking booking) async {
    try {
      final docRef = _firestore.collection(_bookingsCollection).doc();
      final bookingWithId = booking.copyWith(id: docRef.id);
      await docRef.set(bookingWithId.toJson());
    } catch (e) {
      rethrow;
    }
  }

  /// Gets all bookings for a specific user with batched queries
  Future<List<Booking>> getBookingsForUser(String userId) async {
    try {
      // Use batched query to get all user bookings in one call
      final snapshot = await _firestore
          .collection('appointments')
          .where('userId', isEqualTo: userId)
          .orderBy('dateTime')
          .get();

      return snapshot.docs
          .map((doc) => Booking.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Gets multiple bookings by IDs using batched queries
  Future<List<Booking>> getBookingsByIds(List<String> bookingIds) async {
    try {
      if (bookingIds.isEmpty) return [];

      // Split into batches of 10 (Firestore limit for 'in' queries)
      final batches = <List<String>>[];
      for (var i = 0; i < bookingIds.length; i += 10) {
        batches.add(bookingIds.sublist(
            i, i + 10 > bookingIds.length ? bookingIds.length : i + 10,),);
      }

      final allBookings = <Booking>[];

      // Execute batched queries
      for (final batch in batches) {
        final snapshot = await _firestore
            .collection(_bookingsCollection)
            .where(FieldPath.documentId, whereIn: batch)
            .get();

        final bookings = snapshot.docs
            .map((doc) => Booking.fromJson({...doc.data(), 'id': doc.id}))
            .toList();

        allBookings.addAll(bookings);
      }

      return allBookings;
    } catch (e) {
      return [];
    }
  }

  /// Cancels a booking by its ID
  Future<void> cancelBooking(String bookingId) async {
    try {
      await _firestore.collection(_bookingsCollection).doc(bookingId).delete();
    } catch (e) {
      rethrow;
    }
  }

  /// Gets a stream of bookings for a specific user
  Stream<List<Booking>> getUserBookings(String userId) => _firestore
        .collection(_bookingsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('dateTime')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Booking.fromJson({...doc.data(), 'id': doc.id}))
            .toList(),);

  /// Gets a stream of bookings for a specific business
  Stream<List<Booking>> getBusinessBookings(String businessId) => _firestore
        .collection(_bookingsCollection)
        .where('businessProfileId', isEqualTo: businessId)
        .orderBy('dateTime')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Booking.fromJson({...doc.data(), 'id': doc.id}))
            .toList(),);

  /// Get a booking by its ID
  Future<Booking?> getBookingById(String bookingId) async {
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
  Future<void> updateBooking(Booking booking) async {
    try {
      await _firestore
          .collection(_bookingsCollection)
          .doc(booking.id)
          .update(booking.toJson());
    } catch (e) {
      rethrow;
    }
  }

  /// Get weekly booking count (stub implementation)
  Future<int> getWeeklyBookingCount() async {
    // TODO: Implement weekly booking count calculation
    return 0;
  }
}
