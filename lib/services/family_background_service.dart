import 'dart:async';

import 'package:appoint/models/family_link.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FamilyBackgroundService {
  factory FamilyBackgroundService() => _instance;
  FamilyBackgroundService._internal();
  static final FamilyBackgroundService _instance =
      FamilyBackgroundService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Timer? _dailyTimer;
  bool _isRunning = false;

  void start() {
    if (_isRunning) return;

    _isRunning = true;
    _scheduleDailyCheck();

    if (kDebugMode) {
      // Removed debug print: debugPrint('FamilyBackgroundService started');
    }
  }

  void stop() {
    _isRunning = false;
    _dailyTimer?.cancel();
    _dailyTimer = null;

    if (kDebugMode) {
      // Removed debug print: debugPrint('FamilyBackgroundService stopped');
    }
  }

  void _scheduleDailyCheck() {
    // Calculate time until next midnight
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final timeUntilMidnight = tomorrow.difference(now);

    final _dailyTimer = Timer(timeUntilMidnight, () {
      _performDailyCheck();
      // Schedule next check for 24 hours later
      _dailyTimer = Timer.periodic(const Duration(days: 1), (_) {
        _performDailyCheck();
      });
    });
  }

  Future<void> _performDailyCheck() async {
    if (!_isRunning) return;

    try {
      if (kDebugMode) {
        // Removed debug print: debugPrint('Performing daily family relationship check...');
      }

      await _checkAgeTransitions();
      await _cleanupExpiredRequests();
      await _validateFamilyLinks();

      if (kDebugMode) {
        // Removed debug print: debugPrint('Daily family relationship check completed');
      }
    } catch (e) {
        // Removed debug print: debugPrint('Error during daily family relationship check: $e');
      }
    }
  }

  Future<void> _checkAgeTransitions() async {
    if (kDebugMode) {
      // Removed debug print: debugPrint('Checking age transitions...');
    }

    try {
      // Get all family links
      final familyLinksSnapshot =
          await _firestore.collection('family_links').get();

      for (doc in familyLinksSnapshot.docs) {
        final familyLink = FamilyLink.fromJson(doc.data());

        // Get child's profile to check age
        final childProfile =
            await _firestore.collection('users').doc(familyLink.childId).get();
        if (!childProfile.exists) continue;

        final childData = childProfile.data();
        if (childData == null) continue;

        final birthDate = childData['birthDate'] as Timestamp?;
        if (birthDate == null) continue;

        final age = DateTime.now().difference(birthDate.toDate()).inDays ~/ 365;

        // Check age milestones and update permissions accordingly
        if (age >= 18) {
          // Child is now an adult - update permissions
          await _updatePermissionsForAdult(familyLink.id);
        } else if (age >= 16) {
          // Child is 16+ - update driving-related permissions
          await _updatePermissionsForTeenager(familyLink.id);
        } else if (age >= 13) {
          // Child is 13+ - COPPA compliance updates
          await _updatePermissionsForCOPPA(familyLink.id);
        }
      }
    } catch (e) {
      // Removed debug print: debugPrint('Error checking age transitions: $e');
    }
  }

  Future<void> _updatePermissionsForAdult(String familyLinkId) async {
    try {
      // Get current permissions for this family link
      final permissionsSnapshot = await _firestore
          .collection('permissions')
          .where('familyLinkId', isEqualTo: familyLinkId)
          .get();

      final batch = _firestore.batch();

      for (doc in permissionsSnapshot.docs) {
        final permission = doc.data();

        // For adult children, reduce parental permissions to read-only for most categories
        // except for critical safety categories
        var newAccessLevel = 'read';

        // Keep write access for safety-related categories
        if (permission['category'] == 'emergency_contacts' ||
            permission['category'] == 'medical_info') {
          newAccessLevel = 'write';
        }

        batch.update(doc.reference, {
          'accessLevel': newAccessLevel,
          'updatedAt': FieldValue.serverTimestamp(),
          'reason': 'age_transition_adult',
        });
      }

      await batch.commit();

      // Log the age transition
      await _firestore.collection('family_analytics').add({
        'eventType': 'age_transition',
        'familyLinkId': familyLinkId,
        'transitionType': 'adult',
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (kDebugMode) {
        // Removed debug print: debugPrint('Updated permissions for adult child in link: $familyLinkId');
      }
    } catch (e) {
      // Removed debug print: debugPrint('Error updating permissions for adult: $e');
    }
  }

  Future<void> _updatePermissionsForTeenager(String familyLinkId) async {
    try {
      // Get current permissions for this family link
      final permissionsSnapshot = await _firestore
          .collection('permissions')
          .where('familyLinkId', isEqualTo: familyLinkId)
          .get();

      final batch = _firestore.batch();

      for (doc in permissionsSnapshot.docs) {
        final permission = doc.data();

        // For teenagers, add driving-related permissions and adjust existing ones
        if (permission['category'] == 'location') {
          // Keep location tracking for safety
          batch.update(doc.reference, {
            'accessLevel': 'write',
            'updatedAt': FieldValue.serverTimestamp(),
            'reason': 'age_transition_teenager',
          });
        } else if (permission['category'] == 'driving') {
          // Add driving permissions for teenagers
          batch.set(doc.reference, {
            'familyLinkId': familyLinkId,
            'category': 'driving',
            'accessLevel': 'write',
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
            'reason': 'age_transition_teenager',
          });
        }
      }

      await batch.commit();

      // Log the age transition
      await _firestore.collection('family_analytics').add({
        'eventType': 'age_transition',
        'familyLinkId': familyLinkId,
        'transitionType': 'teenager',
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (kDebugMode) {
        // Removed debug print: debugPrint('Updated permissions for teenager in link: $familyLinkId');
      }
    } catch (e) {
      // Removed debug print: debugPrint('Error updating permissions for teenager: $e');
    }
  }

  Future<void> _updatePermissionsForCOPPA(String familyLinkId) async {
    try {
      // For COPPA compliance, ensure proper consent tracking
      await _firestore.collection('family_links').doc(familyLinkId).update({
        'coppaCompliant': true,
        'consentRequired': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Log the COPPA compliance update
      await _firestore.collection('family_analytics').add({
        'eventType': 'coppa_compliance',
        'familyLinkId': familyLinkId,
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (kDebugMode) {
        // Removed debug print: debugPrint('Updated COPPA compliance for link: $familyLinkId');
      }
    } catch (e) {
      // Removed debug print: debugPrint('Error updating COPPA compliance: $e');
    }
  }

  Future<void> _cleanupExpiredRequests() async {
    if (kDebugMode) {
      // Removed debug print: debugPrint('Cleaning up expired privacy requests...');
    }

    try {
      final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));

      // Find all pending privacy requests older than 7 days
      final expiredRequestsSnapshot = await _firestore
          .collection('privacy_requests')
          .where('status', isEqualTo: 'pending')
          .where('requestedAt', isLessThan: Timestamp.fromDate(sevenDaysAgo))
          .get();

      for (final doc in expiredRequestsSnapshot.docs) {
        final requestData = doc.data();

        // Update status to expired
        await doc.reference.update({
          'status': 'expired',
          'expiredAt': FieldValue.serverTimestamp(),
        });

        // Send notification to child that their request has expired
        await _sendExpiredRequestNotification(requestData['childId']);

        if (kDebugMode) {
          // Removed debug print: debugPrint('Expired privacy request: ${doc.id}');
        }
      }
    } catch (e) {
      // Removed debug print: debugPrint('Error cleaning up expired requests: $e');
    }
  }

  Future<void> _sendExpiredRequestNotification(String childId) async {
    try {
      // Get child's notification token
      final childDoc = await _firestore.collection('users').doc(childId).get();
      if (!childDoc.exists) return;

      final childData = childDoc.data();
      final notificationToken = childData?['notificationToken'];

      if (notificationToken != null) {
        // Send push notification
        await _firestore.collection('notifications').add({
          'userId': childId,
          'title': 'Privacy Request Expired',
          'body':
              'Your privacy request has expired. You can submit a new request if needed.',
          'type': 'privacy_request_expired',
          'timestamp': FieldValue.serverTimestamp(),
          'read': false,
        });

        if (kDebugMode) {
          // Removed debug print: debugPrint('Sent expired request notification to child: $childId');
        }
      }
    } catch (e) {
      // Removed debug print: debugPrint('Error sending expired request notification: $e');
      }
    }

  Future<void> _validateFamilyLinks() async {
    if (kDebugMode) {
      // Removed debug print: debugPrint('Validating family links...');
    }

    try {
      final familyLinksSnapshot =
          await _firestore.collection('family_links').get();

      for (doc in familyLinksSnapshot.docs) {
        final familyLink = FamilyLink.fromJson(doc.data());

        // Check if parent and child users still exist
        final parentExists =
            await _firestore.collection('users').doc(familyLink.parentId).get();
        final childExists =
            await _firestore.collection('users').doc(familyLink.childId).get();

        if (!parentExists.exists || !childExists.exists) {
          // Mark link as invalid
          await doc.reference.update({
            'status': 'invalid',
            'invalidatedAt': FieldValue.serverTimestamp(),
          });

          if (kDebugMode) {
            // Removed debug print: debugPrint('Invalidated family link: ${doc.id}');
          }
        }

        // Check for consent expiration (if applicable)
        if (familyLink.consentedAt.isNotEmpty) {
          final lastConsent = familyLink.consentedAt.last;
          final consentAge = DateTime.now().difference(lastConsent).inDays;

          // If consent is older than 1 year, mark for renewal
          if (consentAge > 365) {
            await doc.reference.update({
              'needsConsentRenewal': true,
            });

            if (kDebugMode) {
              // Removed debug print: debugPrint('Family link needs consent renewal: ${doc.id}');
            }
          }
        }
      }
    } catch (e) {
        // Removed debug print: debugPrint('Error validating family links: $e');
      }
    }

  // Method to manually trigger a check (useful for testing)
  Future<void> triggerManualCheck() async {
    if (kDebugMode) {
      // Removed debug print: debugPrint('Manual family relationship check triggered');
    }
    await _performDailyCheck();
  }

  // Method to check if service is running
  bool get isRunning => _isRunning;

// Extension method to easily access the service
extension REDACTED_TOKEN on FamilyBackgroundService {
  static FamilyBackgroundService get instance => FamilyBackgroundService();
}
