import 'package:appoint/features/studio_business/models/staff_availability.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StaffAvailabilityService {
  StaffAvailabilityService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;
  final FirebaseFirestore _firestore;

  Future<List<StaffAvailability>> getStaffAvailability(
    String businessProfileId,
  ) async {
    final snapshot = await _firestore
        .collection('staff_availability')
        .where('businessProfileId', isEqualTo: businessProfileId)
        .get();

    return snapshot.docs
        .map(
          (doc) => StaffAvailability.fromJson({...doc.data(), 'id': doc.id}),
        )
        .toList();
  }

  Future<StaffAvailability?> getStaffAvailabilityById(
    String staffProfileId,
  ) async {
    final doc = await _firestore
        .collection('staff_availability')
        .where('profileId', isEqualTo: staffProfileId)
        .limit(1)
        .get();

    if (doc.docs.isEmpty) return null;

    return StaffAvailability.fromJson(
      {...doc.docs.first.data(), 'id': doc.docs.first.id},
    );
  }

  Future<void> updateStaffAvailability(
    StaffAvailability availability,
  ) async {
    await _firestore
        .collection('staff_availability')
        .doc(availability.id)
        .set(availability.toJson());
  }

  Future<void> createStaffAvailability(
    StaffAvailability availability,
  ) async {
    await _firestore
        .collection('staff_availability')
        .add(availability.toJson());
  }
}
