import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ConsentLoggingService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  
  static const String _termsVersion = '1.0.0';
  static const String _privacyVersion = '1.0.0';

  /// Log terms of service acceptance
  static Future<void> logTermsAcceptance({
    String? userId,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final user = _auth.currentUser;
      final uid = userId ?? user?.uid;
      
      if (uid == null) {
        throw Exception('No user ID available for consent logging');
      }

      await _firestore.collection('consent_logs').add({
        'user_id': uid,
        'consent_type': 'terms_of_service',
        'timestamp': FieldValue.serverTimestamp(),
        'terms_version': _termsVersion,
        'ip_address': additionalData?['ip_address'],
        'user_agent': additionalData?['user_agent'],
        'platform': additionalData?['platform'] ?? 'mobile',
        'accepted': true,
        'created_at': FieldValue.serverTimestamp(),
      });

      // Also update user document with latest consent info
      await _firestore.collection('users').doc(uid).update({
        'terms_accepted_at': FieldValue.serverTimestamp(),
        'terms_version': _termsVersion,
      });
    } catch (e) {
      // Log error but don't throw to avoid blocking user flow
      print('Error logging terms acceptance: $e');
      rethrow;
    }
  }

  /// Log privacy policy acceptance
  static Future<void> logPrivacyAcceptance({
    String? userId,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final user = _auth.currentUser;
      final uid = userId ?? user?.uid;
      
      if (uid == null) {
        throw Exception('No user ID available for consent logging');
      }

      await _firestore.collection('consent_logs').add({
        'user_id': uid,
        'consent_type': 'privacy_policy',
        'timestamp': FieldValue.serverTimestamp(),
        'privacy_version': _privacyVersion,
        'ip_address': additionalData?['ip_address'],
        'user_agent': additionalData?['user_agent'],
        'platform': additionalData?['platform'] ?? 'mobile',
        'accepted': true,
        'created_at': FieldValue.serverTimestamp(),
      });

      // Also update user document with latest consent info
      await _firestore.collection('users').doc(uid).update({
        'privacy_accepted_at': FieldValue.serverTimestamp(),
        'privacy_version': _privacyVersion,
      });
    } catch (e) {
      // Log error but don't throw to avoid blocking user flow
      print('Error logging privacy acceptance: $e');
      rethrow;
    }
  }

  /// Log combined terms and privacy acceptance (typical for signup flow)
  static Future<void> logCombinedAcceptance({
    String? userId,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final user = _auth.currentUser;
      final uid = userId ?? user?.uid;
      
      if (uid == null) {
        throw Exception('No user ID available for consent logging');
      }

      // Log both in a batch
      final batch = _firestore.batch();
      
      // Terms acceptance log
      final termsDocRef = _firestore.collection('consent_logs').doc();
      batch.set(termsDocRef, {
        'user_id': uid,
        'consent_type': 'terms_of_service',
        'timestamp': FieldValue.serverTimestamp(),
        'terms_version': _termsVersion,
        'ip_address': additionalData?['ip_address'],
        'user_agent': additionalData?['user_agent'],
        'platform': additionalData?['platform'] ?? 'mobile',
        'accepted': true,
        'created_at': FieldValue.serverTimestamp(),
      });

      // Privacy acceptance log
      final privacyDocRef = _firestore.collection('consent_logs').doc();
      batch.set(privacyDocRef, {
        'user_id': uid,
        'consent_type': 'privacy_policy',
        'timestamp': FieldValue.serverTimestamp(),
        'privacy_version': _privacyVersion,
        'ip_address': additionalData?['ip_address'],
        'user_agent': additionalData?['user_agent'],
        'platform': additionalData?['platform'] ?? 'mobile',
        'accepted': true,
        'created_at': FieldValue.serverTimestamp(),
      });

      // Update user document
      final userDocRef = _firestore.collection('users').doc(uid);
      batch.update(userDocRef, {
        'terms_accepted_at': FieldValue.serverTimestamp(),
        'terms_version': _termsVersion,
        'privacy_accepted_at': FieldValue.serverTimestamp(),
        'privacy_version': _privacyVersion,
        'legal_compliance_complete': true,
      });

      await batch.commit();
    } catch (e) {
      print('Error logging combined acceptance: $e');
      rethrow;
    }
  }

  /// Check if user has accepted current versions of terms and privacy
  static Future<bool> hasValidConsent({String? userId}) async {
    try {
      final user = _auth.currentUser;
      final uid = userId ?? user?.uid;
      
      if (uid == null) {
        return false;
      }

      final userDoc = await _firestore.collection('users').doc(uid).get();
      
      if (!userDoc.exists) {
        return false;
      }

      final data = userDoc.data() as Map<String, dynamic>;
      
      // Check if both terms and privacy are accepted with current versions
      final termsAccepted = data['terms_version'] == _termsVersion &&
                           data['terms_accepted_at'] != null;
      final privacyAccepted = data['privacy_version'] == _privacyVersion &&
                             data['privacy_accepted_at'] != null;

      return termsAccepted && privacyAccepted;
    } catch (e) {
      print('Error checking consent status: $e');
      return false;
    }
  }

  /// Get consent history for a user (for GDPR data export)
  static Future<List<Map<String, dynamic>>> getConsentHistory({
    String? userId,
  }) async {
    try {
      final user = _auth.currentUser;
      final uid = userId ?? user?.uid;
      
      if (uid == null) {
        return [];
      }

      final querySnapshot = await _firestore
          .collection('consent_logs')
          .where('user_id', isEqualTo: uid)
          .orderBy('timestamp', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Error fetching consent history: $e');
      return [];
    }
  }

  /// Revoke consent (for GDPR compliance)
  static Future<void> revokeConsent({
    String? userId,
    String consentType = 'all', // 'terms', 'privacy', or 'all'
  }) async {
    try {
      final user = _auth.currentUser;
      final uid = userId ?? user?.uid;
      
      if (uid == null) {
        throw Exception('No user ID available for consent revocation');
      }

      await _firestore.collection('consent_logs').add({
        'user_id': uid,
        'consent_type': consentType,
        'timestamp': FieldValue.serverTimestamp(),
        'accepted': false,
        'action': 'revocation',
        'created_at': FieldValue.serverTimestamp(),
      });

      // Update user document
      final updateData = <String, dynamic>{
        'consent_revoked_at': FieldValue.serverTimestamp(),
        'legal_compliance_complete': false,
      };

      if (consentType == 'all' || consentType == 'terms') {
        updateData['terms_accepted_at'] = null;
        updateData['terms_version'] = null;
      }

      if (consentType == 'all' || consentType == 'privacy') {
        updateData['privacy_accepted_at'] = null;
        updateData['privacy_version'] = null;
      }

      await _firestore.collection('users').doc(uid).update(updateData);
    } catch (e) {
      print('Error revoking consent: $e');
      rethrow;
    }
  }
}