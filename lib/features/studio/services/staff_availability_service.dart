import 'package:cloud_firestore/cloud_firestore.dart';

class StaffAvailabilityService {

  StaffAvailabilityService(this.studioId);
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String studioId;

  CollectionReference get _collection =>
      _db.collection('studio').doc(studioId).collection('staff_availability');

  Future<void> addSlot(DateTime startTime, final DateTime endTime) async {
    try {
      await _collection.add({
        'startTime': Timestamp.fromDate(startTime),
        'endTime': Timestamp.fromDate(endTime),
        'isBooked': false,
      });
    } catch (e) {
      // Removed debug print: debugPrint('❌ Error adding slot: $e');
      rethrow;
    }
  }

  Future<void> updateSlot(
      String id, final DateTime startTime, final DateTime endTime,) async {
    try {
      await _collection.doc(id).update({
        'startTime': Timestamp.fromDate(startTime),
        'endTime': Timestamp.fromDate(endTime),
      });
    } catch (e) {
      // Removed debug print: debugPrint('❌ Error updating slot: $e');
      rethrow;
    }
  }

  Future<void> deleteSlot(String id) async {
    try {
      await _collection.doc(id).delete();
    } catch (e) {
      // Removed debug print: debugPrint('❌ Error deleting slot: $e');
      rethrow;
    }
  }
}
