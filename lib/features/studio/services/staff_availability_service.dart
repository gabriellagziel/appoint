import 'package:cloud_firestore/cloud_firestore.dart';

class StaffAvailabilityService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String studioId;

  StaffAvailabilityService(this.studioId);

  CollectionReference get _collection =>
      _db.collection('studio').doc(studioId).collection('staff_availability');

  Future<void> addSlot(final DateTime startTime, final DateTime endTime) async {
    try {
      await _collection.add({
        'startTime': Timestamp.fromDate(startTime),
        'endTime': Timestamp.fromDate(endTime),
        'isBooked': false,
      });
    } catch (e) {
      // Removed debug print: print('❌ Error adding slot: $e');
      rethrow;
    }
  }

  Future<void> updateSlot(
      final String id, final DateTime startTime, final DateTime endTime) async {
    try {
      await _collection.doc(id).update({
        'startTime': Timestamp.fromDate(startTime),
        'endTime': Timestamp.fromDate(endTime),
      });
    } catch (e) {
      // Removed debug print: print('❌ Error updating slot: $e');
      rethrow;
    }
  }

  Future<void> deleteSlot(final String id) async {
    try {
      await _collection.doc(id).delete();
    } catch (e) {
      // Removed debug print: print('❌ Error deleting slot: $e');
      rethrow;
    }
  }
}
