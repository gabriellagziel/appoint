import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appoint/models/studio_profile.dart';

class StudioProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<StudioProfile?> fetchProfile(final String studioId) async {
    final doc = await _firestore.collection('studios').doc(studioId).get();
    if (!doc.exists) return null;
    return StudioProfile.fromJson(doc.data()!..['id'] = doc.id);
  }

  Future<void> saveProfile(final StudioProfile profile) async {
    await _firestore
        .collection('studios')
        .doc(profile.id)
        .set(profile.toJson());
  }

  Future<void> updateProfile(final String studioId, final Map<String, dynamic> data) async {
    await _firestore.collection('studios').doc(studioId).update(data);
  }
}
