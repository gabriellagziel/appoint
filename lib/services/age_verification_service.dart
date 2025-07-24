import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:appoint/providers/age_verification_provider.dart';

class AgeVerificationService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  AgeVerificationService({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  }) : _firestore = firestore, _auth = auth;

  /// Log age verification attempt for audit trail
  Future<void> logAgeVerification(AgeVerificationResult result) async {
    try {
      await _firestore.collection('age_verification_logs').add({
        'userId': _auth.currentUser?.uid,
        'age': result.age,
        'birthDate': Timestamp.fromDate(result.birthDate),
        'isMinor': result.isMinor,
        'requiresParentalConsent': result.requiresParentalConsent,
        'timestamp': FieldValue.serverTimestamp(),
        'platform': Platform.operatingSystem,
        'appVersion': 'TODO: Get from package info',
        'ipAddress': 'TODO: Get IP address if needed for compliance',
      });
    } catch (e) {
      // Log error but don't throw - age verification should continue
      debugPrint('Failed to log age verification: $e');
    }
  }

  /// Validate age against platform family controls (Google Family Link, Apple Screen Time)
  Future<void> validateAgainstPlatformControls(DateTime birthDate, int age) async {
    try {
      if (Platform.isAndroid) {
        await _validateAndroidFamilyLink(birthDate, age);
      } else if (Platform.isIOS) {
        await _validateAppleScreenTime(birthDate, age);
      }
    } catch (e) {
      // Platform validation errors should be logged but not block the flow
      debugPrint('Platform validation failed: $e');
      await _logPlatformValidationError(e.toString());
    }
  }

  /// Android-specific validation using Google Family Link APIs
  Future<void> _validateAndroidFamilyLink(DateTime birthDate, int age) async {
    if (!Platform.isAndroid) return;

    try {
      // TODO: Implement Google Family Link API integration
      // This would check if the device is managed by a parent
      // and validate the age against the family account
      
      const platform = MethodChannel('com.appoint.family/age_verification');
      final result = await platform.invokeMethod('validateFamilyLink', {
        'birthDate': birthDate.millisecondsSinceEpoch,
        'age': age,
      });

      if (result['isFakeAge'] == true) {
        throw Exception('Age verification failed: Platform indicates fake age');
      }

      if (result['requiresParentApproval'] == true && age < 13) {
        // Additional validation for COPPA compliance
        await _enforceCOPPARequirements(birthDate, age);
      }
    } on PlatformException catch (e) {
      if (e.code == 'FAMILY_LINK_NOT_AVAILABLE') {
        // Family Link not available - continue with standard flow
        return;
      }
      rethrow;
    }
  }

  /// iOS-specific validation using Apple Screen Time APIs
  Future<void> _validateAppleScreenTime(DateTime birthDate, int age) async {
    if (!Platform.isIOS) return;

    try {
      // TODO: Implement Apple Family Sharing API integration
      // This would check if the device is part of a family group
      // and validate the age against the Apple ID
      
      const platform = MethodChannel('com.appoint.family/age_verification');
      final result = await platform.invokeMethod('validateAppleFamily', {
        'birthDate': birthDate.millisecondsSinceEpoch,
        'age': age,
      });

      if (result['isFakeAge'] == true) {
        throw Exception('Age verification failed: Platform indicates fake age');
      }

      if (result['requiresParentApproval'] == true && age < 13) {
        await _enforceCOPPARequirements(birthDate, age);
      }
    } on PlatformException catch (e) {
      if (e.code == 'FAMILY_SHARING_NOT_AVAILABLE') {
        // Family Sharing not available - continue with standard flow
        return;
      }
      rethrow;
    }
  }

  /// Enforce COPPA requirements for users under 13
  Future<void> _enforceCOPPARequirements(DateTime birthDate, int age) async {
    await _firestore.collection('coppa_enforcement_logs').add({
      'userId': _auth.currentUser?.uid,
      'age': age,
      'birthDate': Timestamp.fromDate(birthDate),
      'timestamp': FieldValue.serverTimestamp(),
      'action': 'coppa_requirements_triggered',
      'platform': Platform.operatingSystem,
    });
  }

  /// Report suspected fake age to authorities and admin
  Future<void> reportFakeAge(String userId, DateTime reportedAge, DateTime actualAge) async {
    await _firestore.collection('fake_age_reports').add({
      'reportedUserId': userId,
      'reportedAge': Timestamp.fromDate(reportedAge),
      'actualAge': Timestamp.fromDate(actualAge),
      'reportedBy': _auth.currentUser?.uid,
      'timestamp': FieldValue.serverTimestamp(),
      'platform': Platform.operatingSystem,
      'status': 'pending_investigation',
    });

    // Send notification to admins
    await _firestore.collection('admin_notifications').add({
      'type': 'fake_age_report',
      'userId': userId,
      'priority': 'high',
      'message': 'Suspected fake age reported for user $userId',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  /// Log platform validation errors for debugging
  Future<void> _logPlatformValidationError(String error) async {
    await _firestore.collection('platform_validation_errors').add({
      'error': error,
      'platform': Platform.operatingSystem,
      'timestamp': FieldValue.serverTimestamp(),
      'userId': _auth.currentUser?.uid,
    });
  }

  /// Check if user's age verification is still valid
  Future<bool> isAgeVerificationValid(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) return false;

      final data = userDoc.data()!;
      final birthDate = (data['birthDate'] as Timestamp?)?.toDate();
      final verifiedAt = (data['ageVerifiedAt'] as Timestamp?)?.toDate();

      if (birthDate == null || verifiedAt == null) return false;

      // Age verification is valid for 1 year
      final oneYearAgo = DateTime.now().subtract(const Duration(days: 365));
      return verifiedAt.isAfter(oneYearAgo);
    } catch (e) {
      debugPrint('Error checking age verification validity: $e');
      return false;
    }
  }

  /// Get COPPA compliance status for user
  Future<Map<String, dynamic>> getCOPPAStatus(String userId) async {
    final userDoc = await _firestore.collection('users').doc(userId).get();
    if (!userDoc.exists) {
      throw Exception('User not found');
    }

    final data = userDoc.data()!;
    final birthDate = (data['birthDate'] as Timestamp?)?.toDate();
    
    if (birthDate == null) {
      return {
        'isMinor': false,
        'requiresCOPPA': false,
        'parentalConsentRequired': false,
      };
    }

    final age = DateTime.now().difference(birthDate).inDays ~/ 365;
    final isMinor = age < 13;

    return {
      'isMinor': isMinor,
      'requiresCOPPA': isMinor,
      'parentalConsentRequired': isMinor,
      'age': age,
      'birthDate': birthDate.toIso8601String(),
    };
  }
}