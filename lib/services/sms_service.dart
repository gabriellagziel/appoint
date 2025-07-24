import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class SMSService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Send COPPA verification SMS to parent
  Future<void> sendCOPPAVerificationSMS(
    String parentPhone,
    String verificationCode,
    String verificationId,
    int childAge,
  ) async {
    try {
      // Format the message
      final message = '''
AppOint: Your child (age $childAge) needs parental consent to use our app.

Verification Code: $verificationCode

To approve: https://appoint.com/approve/$verificationCode
To deny: https://appoint.com/deny/$verificationCode

This link expires in 48 hours. Reply STOP to opt out.
''';

      await _firestore.collection('sms_queue').add({
        'type': 'coppa_verification',
        'to': parentPhone,
        'message': message,
        'templateData': {
          'verificationCode': verificationCode,
          'verificationId': verificationId,
          'childAge': childAge,
          'approveUrl': 'https://appoint.com/approve/$verificationCode',
          'denyUrl': 'https://appoint.com/deny/$verificationCode',
        },
        'priority': 'high',
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'attempts': 0,
      });

      await _logSMSAction('coppa_verification_sms_sent', {
        'parentPhone': _maskPhoneNumber(parentPhone),
        'verificationId': verificationId,
        'childAge': childAge,
      });
    } catch (e) {
      await _logSMSAction('coppa_verification_sms_failed', {
        'parentPhone': _maskPhoneNumber(parentPhone),
        'error': e.toString(),
      });
      rethrow;
    }
  }

  /// Send additional parent invitation SMS
  Future<void> sendAdditionalParentInvitation(String parentPhone, String childUserId) async {
    try {
      final message = '''
AppOint: You've been invited to join a family account to help supervise a child.

Download the app: https://appoint.com/download
Join family: https://appoint.com/family/join/$childUserId

Reply STOP to opt out.
''';

      await _firestore.collection('sms_queue').add({
        'type': 'additional_parent_invitation',
        'to': parentPhone,
        'message': message,
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

      await _logSMSAction('REDACTED_TOKEN', {
        'parentPhone': _maskPhoneNumber(parentPhone),
        'childUserId': childUserId,
      });
    } catch (e) {
      await _logSMSAction('REDACTED_TOKEN', {
        'parentPhone': _maskPhoneNumber(parentPhone),
        'error': e.toString(),
      });
      rethrow;
    }
  }

  /// Send child account deletion notification SMS
  Future<void> sendChildDeletionNotification(String parentPhone, String childId, String reason) async {
    try {
      final message = '''
AppOint: URGENT - Account deletion request for your child.

Reason: $reason

Approve deletion: https://appoint.com/approve-deletion/$childId
Deny deletion: https://appoint.com/deny-deletion/$childId

You have 7 days to respond. Reply STOP to opt out.
''';

      await _firestore.collection('sms_queue').add({
        'type': 'child_deletion_notification',
        'to': parentPhone,
        'message': message,
        'templateData': {
          'childId': childId,
          'reason': reason,
          'approveUrl': 'https://appoint.com/approve-deletion/$childId',
          'denyUrl': 'https://appoint.com/deny-deletion/$childId',
        },
        'priority': 'high',
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'attempts': 0,
      });

      await _logSMSAction('REDACTED_TOKEN', {
        'parentPhone': _maskPhoneNumber(parentPhone),
        'childId': childId,
      });
    } catch (e) {
      await _logSMSAction('REDACTED_TOKEN', {
        'parentPhone': _maskPhoneNumber(parentPhone),
        'error': e.toString(),
      });
      rethrow;
    }
  }

  /// Send emergency alert SMS to parent
  Future<void> sendEmergencyAlertSMS(
    String parentPhone,
    String childName,
    String alertType,
    Map<String, dynamic> alertData,
  ) async {
    try {
      final message = '''
🚨 EMERGENCY ALERT - AppOint

Child: $childName
Alert: $alertType
Time: ${DateTime.now().toString()}

Contact support: +1-800-APPOINT
Dashboard: https://appoint.com/parent/dashboard

Reply STOP to opt out of non-emergency messages.
''';

      await _firestore.collection('sms_queue').add({
        'type': 'emergency_alert',
        'to': parentPhone,
        'message': message,
        'templateData': {
          'childName': childName,
          'alertType': alertType,
          'alertData': alertData,
          'timestamp': DateTime.now().toIso8601String(),
        },
        'priority': 'urgent',
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'attempts': 0,
      });

      await _logSMSAction('emergency_alert_sms_sent', {
        'parentPhone': _maskPhoneNumber(parentPhone),
        'childName': childName,
        'alertType': alertType,
      });
    } catch (e) {
      await _logSMSAction('emergency_alert_sms_failed', {
        'parentPhone': _maskPhoneNumber(parentPhone),
        'error': e.toString(),
      });
      rethrow;
    }
  }

  /// Send playtime limit warning SMS
  Future<void> sendPlaytimeLimitWarningSMS(
    String parentPhone,
    String childName,
    String limitType,
    int remainingMinutes,
  ) async {
    try {
      final message = '''
AppOint: $childName has $remainingMinutes minutes of playtime remaining ($limitType limit).

Extend time: https://appoint.com/extend-time
Dashboard: https://appoint.com/parent

Reply STOP to opt out.
''';

      await _firestore.collection('sms_queue').add({
        'type': 'playtime_limit_warning',
        'to': parentPhone,
        'message': message,
        'templateData': {
          'childName': childName,
          'limitType': limitType,
          'remainingMinutes': remainingMinutes,
        },
        'priority': 'normal',
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'attempts': 0,
      });

      await _logSMSAction('playtime_limit_warning_sms_sent', {
        'parentPhone': _maskPhoneNumber(parentPhone),
        'childName': childName,
        'limitType': limitType,
      });
    } catch (e) {
      await _logSMSAction('REDACTED_TOKEN', {
        'parentPhone': _maskPhoneNumber(parentPhone),
        'error': e.toString(),
      });
      rethrow;
    }
  }

  /// Send playtime request notification SMS
  Future<void> sendPlaytimeRequestSMS(
    String parentPhone,
    String childName,
    int additionalMinutes,
    String reason,
    String requestId,
  ) async {
    try {
      final message = '''
AppOint: $childName is requesting $additionalMinutes more minutes of playtime.

Reason: $reason

Approve: https://appoint.com/approve-time/$requestId
Deny: https://appoint.com/deny-time/$requestId

Reply STOP to opt out.
''';

      await _firestore.collection('sms_queue').add({
        'type': 'playtime_request',
        'to': parentPhone,
        'message': message,
        'templateData': {
          'childName': childName,
          'additionalMinutes': additionalMinutes,
          'reason': reason,
          'requestId': requestId,
        },
        'priority': 'normal',
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'attempts': 0,
      });

      await _logSMSAction('playtime_request_sms_sent', {
        'parentPhone': _maskPhoneNumber(parentPhone),
        'childName': childName,
        'requestId': requestId,
      });
    } catch (e) {
      await _logSMSAction('playtime_request_sms_failed', {
        'parentPhone': _maskPhoneNumber(parentPhone),
        'error': e.toString(),
      });
      rethrow;
    }
  }

  /// Send two-factor authentication code
  Future<void> send2FACode(String phoneNumber, String code) async {
    try {
      final message = '''
AppOint verification code: $code

This code expires in 5 minutes. Do not share this code with anyone.

Reply STOP to opt out.
''';

      await _firestore.collection('sms_queue').add({
        'type': '2fa_code',
        'to': phoneNumber,
        'message': message,
        'templateData': {
          'code': code,
          'expiresIn': 5,
        },
        'priority': 'high',
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'attempts': 0,
      });

      await _logSMSAction('2fa_code_sent', {
        'phoneNumber': _maskPhoneNumber(phoneNumber),
      });
    } catch (e) {
      await _logSMSAction('2fa_code_failed', {
        'phoneNumber': _maskPhoneNumber(phoneNumber),
        'error': e.toString(),
      });
      rethrow;
    }
  }

  /// Send daily activity summary SMS
  Future<void> sendDailyActivitySummarySMS(
    String parentPhone,
    String childName,
    Map<String, dynamic> activitySummary,
  ) async {
    try {
      final totalMinutes = activitySummary['totalMinutes'] as int? ?? 0;
      final sessions = activitySummary['sessions'] as int? ?? 0;
      
      final message = '''
AppOint Daily Summary - $childName:

Total playtime: ${totalMinutes}m
Sessions: $sessions
Most used: ${activitySummary['mostUsedActivity'] ?? 'N/A'}

View details: https://appoint.com/parent

Reply STOP to opt out.
''';

      await _firestore.collection('sms_queue').add({
        'type': 'daily_activity_summary',
        'to': parentPhone,
        'message': message,
        'templateData': {
          'childName': childName,
          'activitySummary': activitySummary,
        },
        'priority': 'low',
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'attempts': 0,
      });

      await _logSMSAction('daily_activity_summary_sms_sent', {
        'parentPhone': _maskPhoneNumber(parentPhone),
        'childName': childName,
      });
    } catch (e) {
      await _logSMSAction('REDACTED_TOKEN', {
        'parentPhone': _maskPhoneNumber(parentPhone),
        'error': e.toString(),
      });
      rethrow;
    }
  }

  /// Handle incoming SMS responses (for processing opt-outs, responses, etc.)
  Future<void> handleIncomingSMS(String from, String message) async {
    try {
      final normalizedMessage = message.trim().toUpperCase();
      final phoneNumber = _normalizePhoneNumber(from);

      if (normalizedMessage == 'STOP' || normalizedMessage == 'UNSUBSCRIBE') {
        await _handleOptOut(phoneNumber);
      } else if (normalizedMessage.startsWith('YES') || normalizedMessage.startsWith('APPROVE')) {
        await _handleApprovalResponse(phoneNumber, message);
      } else if (normalizedMessage.startsWith('NO') || normalizedMessage.startsWith('DENY')) {
        await _handleDenialResponse(phoneNumber, message);
      }

      // Log all incoming messages for audit
      await _logSMSAction('incoming_sms_received', {
        'from': _maskPhoneNumber(phoneNumber),
        'messageLength': message.length,
        'type': _categorizeIncomingMessage(normalizedMessage),
      });
    } catch (e) {
      await _logSMSAction('incoming_sms_processing_failed', {
        'from': _maskPhoneNumber(from),
        'error': e.toString(),
      });
    }
  }

  /// Handle opt-out requests
  Future<void> _handleOptOut(String phoneNumber) async {
    await _firestore.collection('sms_opt_outs').doc(phoneNumber).set({
      'phoneNumber': phoneNumber,
      'optedOutAt': FieldValue.serverTimestamp(),
      'status': 'opted_out',
    });

    // Send confirmation
    await _firestore.collection('sms_queue').add({
      'type': 'opt_out_confirmation',
      'to': phoneNumber,
      'message': 'You have been unsubscribed from AppOint SMS notifications. To re-subscribe, contact support.',
      'priority': 'normal',
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
      'attempts': 0,
    });

    await _logSMSAction('opt_out_processed', {
      'phoneNumber': _maskPhoneNumber(phoneNumber),
    });
  }

  /// Handle approval responses
  Future<void> _handleApprovalResponse(String phoneNumber, String message) async {
    // This would integrate with the COPPA service to handle approvals
    await _logSMSAction('approval_response_received', {
      'phoneNumber': _maskPhoneNumber(phoneNumber),
      'message': message.substring(0, 50), // Log first 50 chars only
    });
  }

  /// Handle denial responses
  Future<void> _handleDenialResponse(String phoneNumber, String message) async {
    // This would integrate with the COPPA service to handle denials
    await _logSMSAction('denial_response_received', {
      'phoneNumber': _maskPhoneNumber(phoneNumber),
      'message': message.substring(0, 50), // Log first 50 chars only
    });
  }

  /// Check if phone number is opted out
  Future<bool> isOptedOut(String phoneNumber) async {
    try {
      final doc = await _firestore
          .collection('sms_opt_outs')
          .doc(_normalizePhoneNumber(phoneNumber))
          .get();
      
      return doc.exists && doc.data()?['status'] == 'opted_out';
    } catch (e) {
      debugPrint('Failed to check opt-out status: $e');
      return false; // Default to not opted out
    }
  }

  /// Get SMS queue status for monitoring
  Future<Map<String, dynamic>> getSMSQueueStatus() async {
    try {
      final pendingQuery = await _firestore
          .collection('sms_queue')
          .where('status', isEqualTo: 'pending')
          .count()
          .get();

      final failedQuery = await _firestore
          .collection('sms_queue')
          .where('status', isEqualTo: 'failed')
          .count()
          .get();

      final sentQuery = await _firestore
          .collection('sms_queue')
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
      debugPrint('Failed to get SMS queue status: $e');
      return {
        'pending': 0,
        'failed': 0,
        'sentToday': 0,
        'error': e.toString(),
      };
    }
  }

  /// Retry failed SMS messages
  Future<void> retryFailedSMS({int maxRetries = 3}) async {
    try {
      final failedSMS = await _firestore
          .collection('sms_queue')
          .where('status', isEqualTo: 'failed')
          .where('attempts', isLessThan: maxRetries)
          .limit(100)
          .get();

      for (final doc in failedSMS.docs) {
        await doc.reference.update({
          'status': 'pending',
          'retryAt': FieldValue.serverTimestamp(),
          'attempts': FieldValue.increment(1),
        });
      }

      await _logSMSAction('failed_sms_retried', {
        'count': failedSMS.docs.length,
        'maxRetries': maxRetries,
      });
    } catch (e) {
      await _logSMSAction('retry_failed_sms_error', {
        'error': e.toString(),
      });
      rethrow;
    }
  }

  /// Normalize phone number format
  String _normalizePhoneNumber(String phoneNumber) {
    // Remove all non-numeric characters
    final digitsOnly = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    
    // Add country code if missing (assuming US/CA)
    if (digitsOnly.length == 10) {
      return '+1$digitsOnly';
    } else if (digitsOnly.length == 11 && digitsOnly.startsWith('1')) {
      return '+$digitsOnly';
    } else {
      return '+$digitsOnly';
    }
  }

  /// Mask phone number for logging (show only last 4 digits)
  String _maskPhoneNumber(String phoneNumber) {
    if (phoneNumber.length <= 4) return phoneNumber;
    return '***-***-${phoneNumber.substring(phoneNumber.length - 4)}';
  }

  /// Categorize incoming message type
  String _categorizeIncomingMessage(String message) {
    if (message.contains('STOP') || message.contains('UNSUBSCRIBE')) {
      return 'opt_out';
    } else if (message.contains('YES') || message.contains('APPROVE')) {
      return 'approval';
    } else if (message.contains('NO') || message.contains('DENY')) {
      return 'denial';
    } else {
      return 'general';
    }
  }

  /// Log SMS actions for audit trail
  Future<void> _logSMSAction(String action, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('sms_audit_log').add({
        'action': action,
        'data': data,
        'timestamp': FieldValue.serverTimestamp(),
        'userId': _auth.currentUser?.uid,
        'service': 'SMSService',
      });
    } catch (e) {
      // Don't throw on audit logging failures
      debugPrint('Failed to log SMS action: $e');
    }
  }

  /// Validate phone number format
  static bool isValidPhoneNumber(String phoneNumber) {
    // Basic validation for international phone numbers
    final digitsOnly = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    return digitsOnly.length >= 10 && digitsOnly.length <= 15;
  }

  /// Format phone number for display
  static String formatPhoneNumber(String phoneNumber) {
    final digitsOnly = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    
    if (digitsOnly.length == 10) {
      return '(${digitsOnly.substring(0, 3)}) ${digitsOnly.substring(3, 6)}-${digitsOnly.substring(6)}';
    } else if (digitsOnly.length == 11 && digitsOnly.startsWith('1')) {
      return '+1 (${digitsOnly.substring(1, 4)}) ${digitsOnly.substring(4, 7)}-${digitsOnly.substring(7)}';
    } else {
      return phoneNumber; // Return as-is if can't format
    }
  }
}