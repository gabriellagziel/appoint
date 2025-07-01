import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:appoint/models/staff_member.dart';
import 'package:appoint/models/staff_availability.dart';

class StudioService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<StaffMember>> fetchStaff(final String studioId) async {
    final snap = await _firestore.collection('studios/$studioId/staff').get();
    return snap.docs.map((final d) => StaffMember.fromJson(d.data())).toList();
  }

  Future<StaffAvailability> fetchAvailability(
      final String staffId, final DateTime date) async {
    final doc = await _firestore
        .collection('availability/$staffId/dates')
        .doc(date.toIso8601String())
        .get();
    return StaffAvailability.fromJson(doc.data() as Map<String, dynamic>);
  }
}
