import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appoint/features/studio_business/models/staff_availability.dart';

class StaffAvailabilityService {
  final FirebaseFirestore _firestore;

  StaffAvailabilityService({final FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<StaffAvailability>> getStaffAvailability(
      final String businessProfileId) async {
    final snapshot = await _firestore
        .collection('staff_availability')
        .where('businessProfileId', isEqualTo: businessProfileId)
        .get();

    return snapshot.docs
        .map((final doc) => StaffAvailability.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }

  Future<StaffAvailability?> getStaffAvailabilityById(
      final String staffProfileId) async {
    final doc = await _firestore
        .collection('staff_availability')
        .where('profileId', isEqualTo: staffProfileId)
        .limit(1)
        .get();

    if (doc.docs.isEmpty) return null;

    return StaffAvailability.fromJson(
        {...doc.docs.first.data(), 'id': doc.docs.first.id});
  }

  Future<void> updateStaffAvailability(final StaffAvailability availability) async {
    await _firestore
        .collection('staff_availability')
        .doc(availability.id)
        .set(availability.toJson());
  }

  Future<void> createStaffAvailability(final StaffAvailability availability) async {
    await _firestore
        .collection('staff_availability')
        .add(availability.toJson());
  }
}
