import 'package:appoint/features/studio_business/models/studio_booking.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudioBookingService {

  StudioBookingService({
    final FirebaseFirestore? firestore,
    final FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  Future<StudioBooking> createBooking({
    required final String staffProfileId,
    required final String businessProfileId,
    required final DateTime date,
    required final String startTime,
    required final String endTime,
    required final double cost,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    final booking = StudioBooking(
      id: '', // Will be set by Firestore
      customerId: user.uid,
      staffProfileId: staffProfileId,
      businessProfileId: businessProfileId,
      date: date,
      startTime: startTime,
      endTime: endTime,
      cost: cost,
      status: 'pending',
      createdAt: DateTime.now(),
    );

    final docRef =
        await _firestore.collection('studio_bookings').add(booking.toJson());

    return StudioBooking.fromJson({...booking.toJson(), 'id': docRef.id});
  }

  Future<List<StudioBooking>> getUserBookings() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    final snapshot = await _firestore
        .collection('studio_bookings')
        .where('customerId', isEqualTo: user.uid)
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs
        .map((doc) =>
            StudioBooking.fromJson({...doc.data(), 'id': doc.id}),)
        .toList();
  }

  Future<List<StudioBooking>> getBusinessBookings(
      String businessProfileId) async {
    final snapshot = await _firestore
        .collection('studio_bookings')
        .where('businessProfileId', isEqualTo: businessProfileId)
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs
        .map((doc) =>
            StudioBooking.fromJson({...doc.data(), 'id': doc.id}),)
        .toList();
  }

  Future<void> updateBookingStatus(
      String bookingId, final String status,) async {
    await _firestore.collection('studio_bookings').doc(bookingId).update({
      'status': status,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }
}
