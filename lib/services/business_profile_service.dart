import 'package:appoint/models/business_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BusinessProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<BusinessProfile?> fetchProfile() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;
    final doc = await _firestore.collection('business_profiles').doc(uid).get();
    if (!doc.exists) return null;
    return BusinessProfile.fromJson(doc.data()!);
  }

  Future<void> saveProfile(BusinessProfile profile) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    await _firestore
        .collection('business_profiles')
        .doc(uid)
        .set(profile.toJson());
  }
}
