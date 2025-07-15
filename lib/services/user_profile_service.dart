import 'package:appoint/models/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserProfile?> getProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return UserProfile.fromJson({
      'id': doc.id,
      ...doc.data()!,
    });
  }

  Future<UserProfile?> currentUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return getProfile(user.uid);
  }

  Stream<UserProfile?> watchProfile(String uid) => _firestore.collection('users').doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserProfile.fromJson({
        'id': doc.id,
        ...doc.data()!,
      });
    });

  Future<void> updateProfile(UserProfile profile) async {
    await _firestore.collection('users').doc(profile.id).set(profile.toJson());
  }
}
