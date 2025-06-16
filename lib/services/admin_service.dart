import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/admin_user.dart';
import '../models/organization.dart';
import '../models/analytics.dart';

class AdminService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<AdminUser>> fetchAllUsers() async {
    final snap = await _firestore.collection('users').get();
    return snap.docs.map((doc) => AdminUser.fromJson(doc.data())).toList();
  }

  Future<List<Organization>> fetchOrganizations() async {
    final snap = await _firestore.collection('organizations').get();
    return snap.docs.map((doc) => Organization.fromJson(doc.data())).toList();
  }

  Future<Analytics> fetchAnalytics() async {
    final doc = await _firestore.collection('analytics').doc('summary').get();
    return Analytics.fromJson(doc.data() ?? {});
  }

  Future<void> updateUserRole(String uid, String role) async {
    await _firestore.collection('users').doc(uid).update({'role': role});
  }
}
