import 'package:appoint/features/studio_business/models/business_profile.dart';
import 'package:appoint/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BusinessProfileService {
  BusinessProfileService({
    final FirebaseAuth? auth,
  }) : _auth = auth ?? FirebaseAuth.instance;
  final FirebaseAuth _auth;

  Future<BusinessProfile> fetchProfile() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('Not authenticated');

      final doc =
          await FirestoreService.getDocument('business_profiles', user.uid);
      if (!doc.exists) {
        throw Exception('Business profile not found');
      }

      return BusinessProfile.fromJson(doc.data()! as Map<String, dynamic>);
    } catch (e) {
      // Removed debug print: debugPrint('🚨 Business profile fetch error: $e');
      rethrow;
    }
  }

  Future<void> updateProfile(BusinessProfile profile) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('Not authenticated');

      await FirestoreService.updateDocument(
        'business_profiles',
        user.uid,
        profile.toJson(),
      );
    } catch (e) {
      // Removed debug print: debugPrint('🚨 Business profile update error: $e');
      rethrow;
    }
  }
}
