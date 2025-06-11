import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/admin_user.dart';
import '../models/organization.dart';
import '../models/analytics.dart';

class AdminService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<AdminUser>> fetchAllUsers() async {
    final snap = await _firestore.collection('users').get();
    return snap.docs
        .map((doc) => AdminUser.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<List<Organization>> fetchOrganizations() async {
    final snap = await _firestore.collection('organizations').get();
    return snap.docs
        .map((doc) => Organization.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<Analytics> fetchAnalytics() async {
    final doc = await _firestore.collection('analytics').doc('summary').get();
    return Analytics.fromMap(doc.data() ?? {});
  }

  Future<void> updateUserRole(String uid, String role) async {
    await _firestore.collection('users').doc(uid).update({'role': role});
  }
}
