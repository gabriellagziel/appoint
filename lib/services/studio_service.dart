import 'package:appoint/models/staff_availability.dart';
import 'package:appoint/models/staff_member.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudioService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<StaffMember>> fetchStaff(String studioId) async {
    final snap = await _firestore.collection('studios/$studioId/staff').get();
    return snap.docs.map((d) => StaffMember.fromJson(d.data())).toList();
  }

  Future<StaffAvailability> fetchAvailability(
      String staffId, final DateTime date,) async {
    final doc = await _firestore
        .collection('availability/$staffId/dates')
        .doc(date.toIso8601String())
        .get();
    return StaffAvailability.fromJson(doc.data()!);
  }
}
