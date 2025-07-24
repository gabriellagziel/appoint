import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class EmailService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Send COPPA verification email to parent
  Future<void> sendCOPPAVerificationEmail(
    String parentEmail,
    String verificationCode,
    String verificationId,
    int childAge,
  ) async {
    try {
      // In a real implementation, this would use a service like SendGrid, AWS SES, etc.
      // For now, we'll create a email job that can be processed by cloud functions
      
      await _firestore.collection('email_queue').add({
        'type': 'coppa_verification',
        'to': parentEmail,
        'subject': 'Parental Consent Required - AppOint',
        'template': 'coppa_verification',
        'templateData': {
          'verificationCode': verificationCode,
          'verificationId': verificationId,
          'childAge': childAge,
          'verificationUrl': 'https://appoint.com/parent/verify/$verificationId',
          'approveUrl': 'https://appoint.com/parent/approve/$verificationCode',
          'denyUrl': 'https://appoint.com/parent/deny/$verificationCode',
          'expiresIn': '48 hours',
        },
        'priority': 'high',
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'attempts': 0,
      });

      await _logEmailAction('coppa_verification_sent', {
        'parentEmail': parentEmail,
        'verificationId': verificationId,
        'childAge': childAge,
      });
    } catch (e) {
      await _logEmailAction('coppa_verification_failed', {
        'parentEmail': parentEmail,
        'error': e.toString(),
      });
      rethrow;
    }
  }

  /// Send additional parent invitation email
  Future<void> sendAdditionalParentInvitation(String parentEmail, String childUserId) async {
    try {
      await _firestore.collection('email_queue').add({
        'type': 'additional_parent_invitation',
        'to': parentEmail,
        'subject': 'Family Invitation - AppOint',
        'template': 'additional_parent_invitation',
        'templateData': {
          'childUserId': childUserId,
          'invitationUrl': 'https://appoint.com/family/join/$childUserId',
          'appDownloadUrl': 'https://appoint.com/download',
        },
        'priority': 'normal',
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'attempts': 0,
      });

      await _logEmailAction('additional_parent_invitation_sent', {
        'parentEmail': parentEmail,
        'childUserId': childUserId,
      });
    } catch (e) {
      await _logEmailAction('additional_parent_invitation_failed', {
        'parentEmail': parentEmail,
        'error': e.toString(),
      });
      rethrow;
    }
  }

  /// Send child account deletion notification to parent
  Future<void> sendChildDeletionNotification(String parentEmail, String childId, String reason) async {
    try {
      await _firestore.collection('email_queue').add({
        'type': 'child_deletion_notification',
        'to': parentEmail,
        'subject': 'Account Deletion Request - AppOint',
        'template': 'child_deletion_notification',
        'templateData': {
          'childId': childId,
          'reason': reason,
          'approveUrl': 'https://appoint.com/parent/approve-deletion/$childId',
          'denyUrl': 'https://appoint.com/parent/deny-deletion/$childId',
          'deadline': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
        },
        'priority': 'high',
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'attempts': 0,
      });

      await _logEmailAction('child_deletion_notification_sent', {
        'parentEmail': parentEmail,
        'childId': childId,
        'reason': reason,
      });
    } catch (e) {
      await _logEmailAction('child_deletion_notification_failed', {
        'parentEmail': parentEmail,
        'error': e.toString(),
      });
      rethrow;
    }
  }

  /// Send parent notification about child activity
  Future<void> sendParentActivityNotification(
    String parentEmail,
    String childName,
    String activityType,
    Map<String, dynamic> activityData,
  ) async {
    try {
      await _firestore.collection('email_queue').add({
        'type': 'parent_activity_notification',
        'to': parentEmail,
        'subject': 'Activity Alert - $childName',
        'template': 'parent_activity_notification',
        'templateData': {
          'childName': childName,
          'activityType': activityType,
          'activityData': activityData,
          'timestamp': DateTime.now().toIso8601String(),
          'dashboardUrl': 'https://appoint.com/parent/dashboard',
        },
        'priority': 'normal',
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'attempts': 0,
      });

      await _logEmailAction('parent_activity_notification_sent', {
        'parentEmail': parentEmail,
        'childName': childName,
        'activityType': activityType,
      });
    } catch (e) {
      await _logEmailAction('parent_activity_notification_failed', {
        'parentEmail': parentEmail,
        'error': e.toString(),
      });
      rethrow;
    }
  }

  /// Send weekly family report
  Future<void> sendWeeklyFamilyReport(
    String parentEmail,
    Map<String, dynamic> reportData,
  ) async {
    try {
      await _firestore.collection('email_queue').add({
        'type': 'weekly_family_report',
        'to': parentEmail,
        'subject': 'Weekly Family Report - AppOint',
        'template': 'weekly_family_report',
        'templateData': {
          'reportData': reportData,
          'weekStart': reportData['weekStart'],
          'weekEnd': reportData['weekEnd'],
          'dashboardUrl': 'https://appoint.com/parent/dashboard',
          'exportUrl': 'https://appoint.com/parent/export',
        },
        'priority': 'low',
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'attempts': 0,
      });

      await _logEmailAction('weekly_family_report_sent', {
        'parentEmail': parentEmail,
        'childrenCount': reportData['childrenCount'],
      });
    } catch (e) {
      await _logEmailAction('weekly_family_report_failed', {
        'parentEmail': parentEmail,
        'error': e.toString(),
      });
      rethrow;
    }
  }

  /// Send emergency alert to parent
  Future<void> sendEmergencyAlert(
    String parentEmail,
    String childName,
    String alertType,
    Map<String, dynamic> alertData,
  ) async {
    try {
      await _firestore.collection('email_queue').add({
        'type': 'emergency_alert',
        'to': parentEmail,
        'subject': '🚨 EMERGENCY ALERT - $childName',
        'template': 'emergency_alert',
        'templateData': {
          'childName': childName,
          'alertType': alertType,
          'alertData': alertData,
          'timestamp': DateTime.now().toIso8601String(),
          'contactUrl': 'https://appoint.com/emergency/contact',
          'helplineNumber': '+1-800-APPOINT',
        },
        'priority': 'urgent',
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'attempts': 0,
      });

      await _logEmailAction('emergency_alert_sent', {
        'parentEmail': parentEmail,
        'childName': childName,
        'alertType': alertType,
      });
    } catch (e) {
      await _logEmailAction('emergency_alert_failed', {
        'parentEmail': parentEmail,
        'error': e.toString(),
      });
      rethrow;
    }
  }

  /// Send playtime limit warning to parent
  Future<void> sendPlaytimeLimitWarning(
    String parentEmail,
    String childName,
    String limitType,
    int remainingMinutes,
  ) async {
    try {
      await _firestore.collection('email_queue').add({
        'type': 'playtime_limit_warning',
        'to': parentEmail,
        'subject': 'Playtime Limit Warning - $childName',
        'template': 'playtime_limit_warning',
        'templateData': {
          'childName': childName,
          'limitType': limitType,
          'remainingMinutes': remainingMinutes,
          'extendUrl': 'https://appoint.com/parent/extend-time',
          'dashboardUrl': 'https://appoint.com/parent/dashboard',
        },
        'priority': 'normal',
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'attempts': 0,
      });

      await _logEmailAction('playtime_limit_warning_sent', {
        'parentEmail': parentEmail,
        'childName': childName,
        'limitType': limitType,
      });
    } catch (e) {
      await _logEmailAction('playtime_limit_warning_failed', {
        'parentEmail': parentEmail,
        'error': e.toString(),
      });
      rethrow;
    }
  }

  /// Send password reset email (for parent accounts)
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      // Use Firebase Auth's built-in password reset
      await _auth.sendPasswordResetEmail(email: email);

      await _logEmailAction('password_reset_sent', {
        'email': email,
      });
    } catch (e) {
      await _logEmailAction('password_reset_failed', {
        'email': email,
        'error': e.toString(),
      });
      rethrow;
    }
  }

  /// Send email verification (for new parent accounts)
  Future<void> sendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();

        await _logEmailAction('email_verification_sent', {
          'userId': user.uid,
          'email': user.email,
        });
      }
    } catch (e) {
      await _logEmailAction('email_verification_failed', {
        'userId': _auth.currentUser?.uid,
        'error': e.toString(),
      });
      rethrow;
    }
  }

  /// Get email queue status for monitoring
  Future<Map<String, dynamic>> getEmailQueueStatus() async {
    try {
      final pendingQuery = await _firestore
          .collection('email_queue')
          .where('status', isEqualTo: 'pending')
          .count()
          .get();

      final failedQuery = await _firestore
          .collection('email_queue')
          .where('status', isEqualTo: 'failed')
          .count()
          .get();

      final sentQuery = await _firestore
          .collection('email_queue')
          .where('status', isEqualTo: 'sent')
          .where('createdAt', isGreaterThan: Timestamp.fromDate(
            DateTime.now().subtract(const Duration(days: 1)),
          ))
          .count()
          .get();

      return {
        'pending': pendingQuery.count,
        'failed': failedQuery.count,
        'sentToday': sentQuery.count,
        'lastChecked': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      debugPrint('Failed to get email queue status: $e');
      return {
        'pending': 0,
        'failed': 0,
        'sentToday': 0,
        'error': e.toString(),
      };
    }
  }

  /// Retry failed emails
  Future<void> retryFailedEmails({int maxRetries = 3}) async {
    try {
      final failedEmails = await _firestore
          .collection('email_queue')
          .where('status', isEqualTo: 'failed')
          .where('attempts', isLessThan: maxRetries)
          .limit(100)
          .get();

      for (final doc in failedEmails.docs) {
        await doc.reference.update({
          'status': 'pending',
          'retryAt': FieldValue.serverTimestamp(),
          'attempts': FieldValue.increment(1),
        });
      }

      await _logEmailAction('failed_emails_retried', {
        'count': failedEmails.docs.length,
        'maxRetries': maxRetries,
      });
    } catch (e) {
      await _logEmailAction('retry_failed_emails_error', {
        'error': e.toString(),
      });
      rethrow;
    }
  }

  /// Log email actions for audit trail
  Future<void> _logEmailAction(String action, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('email_audit_log').add({
        'action': action,
        'data': data,
        'timestamp': FieldValue.serverTimestamp(),
        'userId': _auth.currentUser?.uid,
        'service': 'EmailService',
      });
    } catch (e) {
      // Don't throw on audit logging failures
      debugPrint('Failed to log email action: $e');
    }
  }

  /// Get email templates for different types
  static Map<String, Map<String, String>> get emailTemplates => {
    'coppa_verification': {
      'subject': 'Parental Consent Required - AppOint',
      'preview': 'Your child has requested to use AppOint. Parental consent is required.',
    },
    'additional_parent_invitation': {
      'subject': 'Family Invitation - AppOint',
      'preview': 'You\'ve been invited to join a family on AppOint.',
    },
    'child_deletion_notification': {
      'subject': 'Account Deletion Request - AppOint',
      'preview': 'A request has been made to delete your child\'s account.',
    },
    'parent_activity_notification': {
      'subject': 'Activity Alert',
      'preview': 'Your child has performed an activity that requires your attention.',
    },
    'weekly_family_report': {
      'subject': 'Weekly Family Report - AppOint',
      'preview': 'Here\'s your family\'s activity summary for this week.',
    },
    'emergency_alert': {
      'subject': '🚨 EMERGENCY ALERT',
      'preview': 'An emergency situation requires immediate attention.',
    },
    'playtime_limit_warning': {
      'subject': 'Playtime Limit Warning',
      'preview': 'Your child is approaching their playtime limit.',
    },
  };

  /// Check if email is valid format
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Sanitize email address
  static String sanitizeEmail(String email) {
    return email.trim().toLowerCase();
  }
}