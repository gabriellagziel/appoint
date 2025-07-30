import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:appoint/services/email_service.dart';
import 'package:appoint/services/sms_service.dart';

class COPPAService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  late final EmailService _emailService;
  late final SMSService _smsService;

  COPPAService({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  }) : _firestore = firestore, _auth = auth {
    _emailService = EmailService();
    _smsService = SMSService();
  }

  /// Send parent email verification for COPPA compliance
  Future<Map<String, dynamic>> sendParentEmailVerification(String email, DateTime birthDate, int age) async {
    try {
      final verificationCode = _generateVerificationCode();
      final sentAt = DateTime.now();
      final expiresAt = sentAt.add(const Duration(hours: 48));

      // Create COPPA verification record
      final verificationDoc = await _firestore.collection('coppa_verifications').add({
        'childUserId': _auth.currentUser?.uid,
        'parentEmail': email,
        'contactMethod': 'email',
        'verificationCode': verificationCode,
        'childAge': age,
        'childBirthDate': Timestamp.fromDate(birthDate),
        'status': 'sent',
        'sentAt': Timestamp.fromDate(sentAt),
        'expiresAt': Timestamp.fromDate(expiresAt),
        'attempts': 1,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Send verification email to parent
      await _emailService.sendCOPPAVerificationEmail(
        email,
        verificationCode,
        verificationDoc.id,
        age,
      );

      // Log the action for audit
      await _logCOPPAAction('parent_verification_sent', {
        'childUserId': _auth.currentUser?.uid,
        'parentEmail': email,
        'verificationId': verificationDoc.id,
        'childAge': age,
      });

      return {
        'verificationId': verificationDoc.id,
        'verificationCode': verificationCode,
        'sentAt': sentAt,
        'expiresAt': expiresAt,
      };
    } catch (e) {
      await _logCOPPAAction('parent_verification_failed', {
        'childUserId': _auth.currentUser?.uid,
        'parentEmail': email,
        'error': e.toString(),
      });
      rethrow;
    }
  }

  /// Send parent phone verification for COPPA compliance
  Future<Map<String, dynamic>> sendParentPhoneVerification(String phone, DateTime birthDate, int age) async {
    try {
      final verificationCode = _generateVerificationCode();
      final sentAt = DateTime.now();
      final expiresAt = sentAt.add(const Duration(hours: 48));

      // Create COPPA verification record
      final verificationDoc = await _firestore.collection('coppa_verifications').add({
        'childUserId': _auth.currentUser?.uid,
        'parentPhone': phone,
        'contactMethod': 'phone',
        'verificationCode': verificationCode,
        'childAge': age,
        'childBirthDate': Timestamp.fromDate(birthDate),
        'status': 'sent',
        'sentAt': Timestamp.fromDate(sentAt),
        'expiresAt': Timestamp.fromDate(expiresAt),
        'attempts': 1,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Send verification SMS to parent
      await _smsService.sendCOPPAVerificationSMS(
        phone,
        verificationCode,
        verificationDoc.id,
        age,
      );

      // Log the action for audit
      await _logCOPPAAction('parent_verification_sent', {
        'childUserId': _auth.currentUser?.uid,
        'parentPhone': phone,
        'verificationId': verificationDoc.id,
        'childAge': age,
      });

      return {
        'verificationId': verificationDoc.id,
        'verificationCode': verificationCode,
        'sentAt': sentAt,
        'expiresAt': expiresAt,
      };
    } catch (e) {
      await _logCOPPAAction('parent_verification_failed', {
        'childUserId': _auth.currentUser?.uid,
        'parentPhone': phone,
        'error': e.toString(),
      });
      rethrow;
    }
  }

  /// Create pending child account with restricted access
  Future<void> createPendingChildAccount(String parentContact, DateTime birthDate, int age) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      // Create restricted child profile
      await _firestore.collection('users').doc(userId).set({
        'birthDate': Timestamp.fromDate(birthDate),
        'age': age,
        'isMinor': true,
        'coppaStatus': 'pending_parent_approval',
        'parentContact': parentContact,
        'accountType': 'child_restricted',
        'permissions': {
          'canUseApp': false,
          'canCreateContent': false,
          'canCommunicate': false,
          'canAccessPlaytime': false,
          'dataCollection': false,
        },
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Create family link pending approval
      await _firestore.collection('family_links').add({
        'childId': userId,
        'parentContact': parentContact,
        'status': 'pending_parent_approval',
        'invitedAt': FieldValue.serverTimestamp(),
        'consentedAt': [],
        'coppaCompliant': true,
        'requiredApprovals': 1, // Can be increased for dual-parent requirement
        'approvedBy': [],
      });

      await _logCOPPAAction('child_account_created', {
        'childUserId': userId,
        'parentContact': parentContact,
        'age': age,
        'accountType': 'restricted',
      });
    } catch (e) {
      await _logCOPPAAction('child_account_creation_failed', {
        'childUserId': _auth.currentUser?.uid,
        'parentContact': parentContact,
        'error': e.toString(),
      });
      rethrow;
    }
  }

  /// Approve child account after parent verification
  Future<void> approveChildAccount(String verificationCode) async {
    try {
      // Find verification record
      final verificationQuery = await _firestore
          .collection('coppa_verifications')
          .where('verificationCode', isEqualTo: verificationCode)
          .where('status', isEqualTo: 'sent')
          .limit(1)
          .get();

      if (verificationQuery.docs.isEmpty) {
        throw Exception('Invalid or expired verification code');
      }

      final verificationDoc = verificationQuery.docs.first;
      final data = verificationDoc.data();
      final childUserId = data['childUserId'];
      final expiresAt = (data['expiresAt'] as Timestamp).toDate();

      // Check if verification has expired
      if (DateTime.now().isAfter(expiresAt)) {
        await verificationDoc.reference.update({'status': 'expired'});
        throw Exception('Verification code has expired');
      }

      // Update verification status
      await verificationDoc.reference.update({
        'status': 'approved',
        'approvedAt': FieldValue.serverTimestamp(),
      });

      // Enable child account
      await _firestore.collection('users').doc(childUserId).update({
        'coppaStatus': 'approved',
        'permissions': {
          'canUseApp': true,
          'canCreateContent': false, // Still restricted until age appropriate
          'canCommunicate': true,
          'canAccessPlaytime': true,
          'dataCollection': true,
        },
        'parentApprovedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Update family link
      await _updateFamilyLinkStatus(childUserId, 'approved', data['parentEmail'] ?? data['parentPhone']);

      await _logCOPPAAction('child_account_approved', {
        'childUserId': childUserId,
        'verificationId': verificationDoc.id,
        'approvedBy': 'parent',
      });
    } catch (e) {
      await _logCOPPAAction('child_account_approval_failed', {
        'verificationCode': verificationCode,
        'error': e.toString(),
      });
      rethrow;
    }
  }

  /// Deny child account
  Future<void> denyChildAccount(String verificationCode) async {
    try {
      // Find verification record
      final verificationQuery = await _firestore
          .collection('coppa_verifications')
          .where('verificationCode', isEqualTo: verificationCode)
          .where('status', isEqualTo: 'sent')
          .limit(1)
          .get();

      if (verificationQuery.docs.isEmpty) {
        throw Exception('Invalid verification code');
      }

      final verificationDoc = verificationQuery.docs.first;
      final data = verificationDoc.data();
      final childUserId = data['childUserId'];

      // Update verification status
      await verificationDoc.reference.update({
        'status': 'denied',
        'deniedAt': FieldValue.serverTimestamp(),
      });

      // Disable and mark child account for deletion
      await _firestore.collection('users').doc(childUserId).update({
        'coppaStatus': 'denied',
        'accountType': 'child_disabled',
        'permissions': {
          'canUseApp': false,
          'canCreateContent': false,
          'canCommunicate': false,
          'canAccessPlaytime': false,
          'dataCollection': false,
        },
        'parentDeniedAt': FieldValue.serverTimestamp(),
        'scheduledForDeletion': true,
        'deletionDate': Timestamp.fromDate(DateTime.now().add(const Duration(days: 30))),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Update family link
      await _updateFamilyLinkStatus(childUserId, 'denied', data['parentEmail'] ?? data['parentPhone']);

      await _logCOPPAAction('child_account_denied', {
        'childUserId': childUserId,
        'verificationId': verificationDoc.id,
        'deniedBy': 'parent',
      });
    } catch (e) {
      await _logCOPPAAction('child_account_denial_failed', {
        'verificationCode': verificationCode,
        'error': e.toString(),
      });
      rethrow;
    }
  }

  /// Get current COPPA status for a user
  Future<Map<String, dynamic>> getCOPPAStatus(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      
      if (!userDoc.exists) {
        return {'requiresCOPPA': false, 'status': 'unknown'};
      }

      final userData = userDoc.data()!;
      final birthDate = (userData['birthDate'] as Timestamp?)?.toDate();
      
      if (birthDate == null) {
        return {'requiresCOPPA': true, 'status': 'age_verification_required'};
      }

      final age = DateTime.now().difference(birthDate).inDays ~/ 365;
      final requiresCOPPA = age < 13;

      if (!requiresCOPPA) {
        return {
          'requiresCOPPA': false,
          'status': 'not_required',
          'age': age,
        };
      }

      // Get latest verification
      final verificationQuery = await _firestore
          .collection('coppa_verifications')
          .where('childUserId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();

      Map<String, dynamic>? latestVerification;
      if (verificationQuery.docs.isNotEmpty) {
        latestVerification = verificationQuery.docs.first.data();
      }

      // Get family links
      final familyLinksQuery = await _firestore
          .collection('family_links')
          .where('childId', isEqualTo: userId)
          .get();

      final familyLinks = familyLinksQuery.docs.map((doc) => doc.data()).toList();

      return {
        'requiresCOPPA': true,
        'status': userData['coppaStatus'] ?? 'unknown',
        'age': age,
        'parentEmail': latestVerification?['parentEmail'],
        'parentPhone': latestVerification?['parentPhone'],
        'verificationSentAt': latestVerification?['sentAt'],
        'verificationExpiresAt': latestVerification?['expiresAt'],
        'requiredParents': familyLinks.map((link) => link['parentContact']).toList(),
        'approvedParents': familyLinks
            .where((link) => link['status'] == 'approved')
            .map((link) => link['parentContact'])
            .toList(),
        'childProfile': userData,
        'familyLinks': familyLinks,
      };
    } catch (e) {
      return {'requiresCOPPA': false, 'error': e.toString()};
    }
  }

  /// Add additional parent to family (dual-parent support)
  Future<void> addAdditionalParent(String parentContact, String contactMethod) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      // Check if parent already exists
      final existingLinkQuery = await _firestore
          .collection('family_links')
          .where('childId', isEqualTo: userId)
          .where('parentContact', isEqualTo: parentContact)
          .get();

      if (existingLinkQuery.docs.isNotEmpty) {
        throw Exception('Parent already linked to this account');
      }

      // Create new family link
      await _firestore.collection('family_links').add({
        'childId': userId,
        'parentContact': parentContact,
        'contactMethod': contactMethod,
        'status': 'pending_parent_approval',
        'invitedAt': FieldValue.serverTimestamp(),
        'consentedAt': [],
        'coppaCompliant': true,
        'role': 'additional_parent',
      });

      // Send verification to additional parent
      if (contactMethod == 'email') {
        await _emailService.sendAdditionalParentInvitation(parentContact, userId);
      } else {
        await _smsService.sendAdditionalParentInvitation(parentContact, userId);
      }

      await _logCOPPAAction('additional_parent_added', {
        'childUserId': userId,
        'parentContact': parentContact,
        'contactMethod': contactMethod,
      });
    } catch (e) {
      await _logCOPPAAction('additional_parent_add_failed', {
        'childUserId': _auth.currentUser?.uid,
        'parentContact': parentContact,
        'error': e.toString(),
      });
      rethrow;
    }
  }

  /// Remove parent from family
  Future<void> removeParent(String parentContact) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      // Find and remove family link
      final familyLinkQuery = await _firestore
          .collection('family_links')
          .where('childId', isEqualTo: userId)
          .where('parentContact', isEqualTo: parentContact)
          .get();

      if (familyLinkQuery.docs.isEmpty) {
        throw Exception('Parent link not found');
      }

      // Check if this is the only parent (cannot remove last parent for minors)
      final allLinksQuery = await _firestore
          .collection('family_links')
          .where('childId', isEqualTo: userId)
          .where('status', isEqualTo: 'approved')
          .get();

      if (allLinksQuery.docs.length <= 1) {
        throw Exception('Cannot remove the only parent. Add another parent first.');
      }

      // Remove the family link
      for (final doc in familyLinkQuery.docs) {
        await doc.reference.delete();
      }

      await _logCOPPAAction('parent_removed', {
        'childUserId': userId,
        'parentContact': parentContact,
      });
    } catch (e) {
      await _logCOPPAAction('parent_removal_failed', {
        'childUserId': _auth.currentUser?.uid,
        'parentContact': parentContact,
        'error': e.toString(),
      });
      rethrow;
    }
  }

  /// Request child account deletion (GDPR-K compliance)
  Future<void> requestChildAccountDeletion(String reason) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      // Create deletion request
      await _firestore.collection('child_deletion_requests').add({
        'childUserId': userId,
        'reason': reason,
        'requestedAt': FieldValue.serverTimestamp(),
        'status': 'pending_parent_approval',
        'gdprCompliant': true,
        'coppaCompliant': true,
      });

      // Notify all parents
      final familyLinksQuery = await _firestore
          .collection('family_links')
          .where('childId', isEqualTo: userId)
          .where('status', isEqualTo: 'approved')
          .get();

      for (final link in familyLinksQuery.docs) {
        final parentContact = link.data()['parentContact'];
        await _notifyParentOfDeletionRequest(parentContact, userId, reason);
      }

      await _logCOPPAAction('deletion_request_created', {
        'childUserId': userId,
        'reason': reason,
      });
    } catch (e) {
      await _logCOPPAAction('deletion_request_failed', {
        'childUserId': _auth.currentUser?.uid,
        'reason': reason,
        'error': e.toString(),
      });
      rethrow;
    }
  }

  /// Resend email verification
  Future<void> resendEmailVerification(String email) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      // Find latest verification record
      final verificationQuery = await _firestore
          .collection('coppa_verifications')
          .where('childUserId', isEqualTo: userId)
          .where('parentEmail', isEqualTo: email)
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();

      if (verificationQuery.docs.isEmpty) {
        throw Exception('No verification record found');
      }

      final verificationDoc = verificationQuery.docs.first;
      final data = verificationDoc.data();

      // Update attempts and resend
      await verificationDoc.reference.update({
        'attempts': FieldValue.increment(1),
        'lastResent': FieldValue.serverTimestamp(),
      });

      // Resend email
      await _emailService.sendCOPPAVerificationEmail(
        email,
        data['verificationCode'],
        verificationDoc.id,
        data['childAge'],
      );

      await _logCOPPAAction('verification_resent', {
        'childUserId': userId,
        'parentEmail': email,
        'verificationId': verificationDoc.id,
      });
    } catch (e) {
      await _logCOPPAAction('verification_resend_failed', {
        'childUserId': _auth.currentUser?.uid,
        'parentEmail': email,
        'error': e.toString(),
      });
      rethrow;
    }
  }

  /// Resend phone verification
  Future<void> resendPhoneVerification(String phone) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      // Find latest verification record
      final verificationQuery = await _firestore
          .collection('coppa_verifications')
          .where('childUserId', isEqualTo: userId)
          .where('parentPhone', isEqualTo: phone)
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();

      if (verificationQuery.docs.isEmpty) {
        throw Exception('No verification record found');
      }

      final verificationDoc = verificationQuery.docs.first;
      final data = verificationDoc.data();

      // Update attempts and resend
      await verificationDoc.reference.update({
        'attempts': FieldValue.increment(1),
        'lastResent': FieldValue.serverTimestamp(),
      });

      // Resend SMS
      await _smsService.sendCOPPAVerificationSMS(
        phone,
        data['verificationCode'],
        verificationDoc.id,
        data['childAge'],
      );

      await _logCOPPAAction('verification_resent', {
        'childUserId': userId,
        'parentPhone': phone,
        'verificationId': verificationDoc.id,
      });
    } catch (e) {
      await _logCOPPAAction('verification_resend_failed', {
        'childUserId': _auth.currentUser?.uid,
        'parentPhone': phone,
        'error': e.toString(),
      });
      rethrow;
    }
  }

  /// Generate a secure verification code
  String _generateVerificationCode() {
    final random = Random.secure();
    return (100000 + random.nextInt(900000)).toString(); // 6-digit code
  }

  /// Update family link status
  Future<void> _updateFamilyLinkStatus(String childId, String status, String parentContact) async {
    final familyLinkQuery = await _firestore
        .collection('family_links')
        .where('childId', isEqualTo: childId)
        .where('parentContact', isEqualTo: parentContact)
        .get();

    for (final doc in familyLinkQuery.docs) {
      await doc.reference.update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (status == 'approved') {
        await doc.reference.update({
          'consentedAt': FieldValue.arrayUnion([FieldValue.serverTimestamp()]),
        });
      }
    }
  }

  /// Notify parent of deletion request
  Future<void> _notifyParentOfDeletionRequest(String parentContact, String childId, String reason) async {
    try {
      if (parentContact.contains('@')) {
        await _emailService.sendChildDeletionNotification(parentContact, childId, reason);
      } else {
        await _smsService.sendChildDeletionNotification(parentContact, childId, reason);
      }
    } catch (e) {
      debugPrint('Failed to notify parent of deletion request: $e');
    }
  }

  /// Log COPPA action for audit trail
  Future<void> _logCOPPAAction(String action, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('coppa_audit_log').add({
        'action': action,
        'data': data,
        'timestamp': FieldValue.serverTimestamp(),
        'userId': _auth.currentUser?.uid,
        'ipAddress': 'TODO: Get IP if needed',
        'userAgent': 'TODO: Get user agent if needed',
      });
    } catch (e) {
      // Don't throw on audit logging failures
      debugPrint('Failed to log COPPA action: $e');
    }
  }
}