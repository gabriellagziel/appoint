import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/staff_availability.dart';

class StaffAvailabilityService {
  final FirebaseFirestore _firestore;
  StaffAvailabilityService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _col(String staffId) =>
      _firestore.collection('staff/$staffId/availability');

  Future<List<StaffAvailability>> fetchAvailability(String staffId) async {
    final snap = await _col(staffId).get();
    return snap.docs
        .map((d) =>
            StaffAvailability.fromJson({...d.data(), 'staffId': staffId}))
        .toList();
  }

  Future<void> saveAvailability(StaffAvailability avail) async {
    final doc = _col(avail.staffId).doc(avail.date.toIso8601String());
    await doc.set(avail.toJson());
  }

  Future<void> deleteAvailability(String staffId, DateTime date) async {
    await _col(staffId).doc(date.toIso8601String()).delete();
  }
}
