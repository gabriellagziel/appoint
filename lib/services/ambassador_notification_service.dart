import 'package:appoint/models/ambassador_profile.dart';
import 'package:appoint/services/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// Extended notification service specifically for Ambassador-related events
class AmbassadorNotificationService {
  AmbassadorNotificationService(this._notificationService);
  final NotificationService _notificationService;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Notification channels for different ambassador events
  static const String ambassadorPromotionChannel = 'ambassador_promotion';
  static const String ambassadorPerformanceChannel = 'ambassador_performance';
  static const String ambassadorTierUpgradeChannel = 'ambassador_tier_upgrade';
  static const String ambassadorMonthlyReminderChannel =
      'ambassador_monthly_reminder';

  /// Initialize ambassador notification channels
  Future<void> initialize() async {
    await _notificationService.initialize();
    // Additional ambassador-specific initialization if needed
  }

  /// Send instant notification when user is promoted to ambassador
  Future<void> sendAmbassadorPromotionNotification({
    required String userId,
    required String countryCode,
    required String languageCode,
    required AmbassadorTier tier,
  }) async {
    try {
      final templates = await _getLocalizedNotificationTemplates(languageCode);

      final title = templates['ambassadorPromotionTitle'] ??
          "Congratulations! You're now an Ambassador!";
      final body = templates['ambassadorPromotionBody']?.replaceAll(
            '{tier}',
            tier.displayName,
          ) ??
          'Welcome to the ${tier.displayName} tier! Start sharing your referral link.';

      await _notificationService.sendNotificationToUser(
        uid: userId,
        title: title,
        body: body,
        data: {
          'type': 'ambassador_promotion',
          'tier': tier.name,
          'channel': ambassadorPromotionChannel,
          'action': 'open_ambassador_dashboard',
        },
      );

      // Also send a local notification for immediate feedback
      await _notificationService.sendLocalNotification(
        title: title,
        body: body,
        payload: 'ambassador_promotion',
      );

      // Log the notification
      await _logNotification(
        userId: userId,
        type: 'ambassador_promotion',
        title: title,
        body: body,
      );
    } catch (e) {
      debugPrint('Error sending ambassador promotion notification: $e');
    }
  }

  /// Send tier upgrade celebration notification
  Future<void> sendTierUpgradeNotification({
    required String userId,
    required String languageCode,
    required AmbassadorTier previousTier,
    required AmbassadorTier newTier,
    required int totalReferrals,
  }) async {
    try {
      final templates = await _getLocalizedNotificationTemplates(languageCode);

      final title = templates['tierUpgradeTitle'] ?? 'Tier Upgrade! 🎉';
      final body = templates['tierUpgradeBody']
              ?.replaceAll('{previousTier}', previousTier.displayName)
              .replaceAll('{newTier}', newTier.displayName)
              .replaceAll('{totalReferrals}', totalReferrals.toString()) ??
          "Congratulations! You've been upgraded from ${previousTier.displayName} to ${newTier.displayName} with $totalReferrals referrals!";

      await _notificationService.sendNotificationToUser(
        uid: userId,
        title: title,
        body: body,
        data: {
          'type': 'tier_upgrade',
          'previousTier': previousTier.name,
          'newTier': newTier.name,
          'totalReferrals': totalReferrals.toString(),
          'channel': ambassadorTierUpgradeChannel,
          'action': 'open_ambassador_dashboard',
        },
      );

      // Also send a local notification for immediate feedback
      await _notificationService.sendLocalNotification(
        title: title,
        body: body,
        payload: 'tier_upgrade',
      );

      // Log the notification
      await _logNotification(
        userId: userId,
        type: 'tier_upgrade',
        title: title,
        body: body,
      );
    } catch (e) {
      debugPrint('Error sending tier upgrade notification: $e');
    }
  }

  /// Send monthly performance reminder (5 days before month end if <10 referrals)
  Future<void> sendMonthlyReminderNotification({
    required String userId,
    required String languageCode,
    required int currentMonthlyReferrals,
    required int targetReferrals,
    required int daysRemaining,
  }) async {
    try {
      final templates = await _getLocalizedNotificationTemplates(languageCode);

      final title =
          templates['monthlyReminderTitle'] ?? 'Monthly Goal Reminder';
      final body = templates['monthlyReminderBody']
              ?.replaceAll(
                  '{currentReferrals}', currentMonthlyReferrals.toString())
              .replaceAll('{targetReferrals}', targetReferrals.toString())
              .replaceAll('{daysRemaining}', daysRemaining.toString()) ??
          'You have $currentMonthlyReferrals/$targetReferrals referrals this month. $daysRemaining days left to reach your goal!';

      await _notificationService.sendNotificationToUser(
        uid: userId,
        title: title,
        body: body,
        data: {
          'type': 'monthly_reminder',
          'currentReferrals': currentMonthlyReferrals.toString(),
          'targetReferrals': targetReferrals.toString(),
          'daysRemaining': daysRemaining.toString(),
          'channel': ambassadorMonthlyReminderChannel,
          'action': 'open_ambassador_dashboard',
        },
      );

      // Schedule local notification
      await _notificationService.scheduleNotification(
        title: title,
        body: body,
        scheduledDate: DateTime.now().add(const Duration(minutes: 1)),
        payload: 'monthly_reminder',
      );

      // Log the notification
      await _logNotification(
        userId: userId,
        type: 'monthly_reminder',
        title: title,
        body: body,
      );
    } catch (e) {
      debugPrint('Error sending monthly reminder notification: $e');
    }
  }

  /// Send performance warning notification
  Future<void> sendPerformanceWarningNotification({
    required String userId,
    required String languageCode,
    required int currentMonthlyReferrals,
    required int minimumRequired,
  }) async {
    try {
      final templates = await _getLocalizedNotificationTemplates(languageCode);

      final title = templates['performanceWarningTitle'] ??
          'Ambassador Performance Alert';
      final body = templates['performanceWarningBody']
              ?.replaceAll(
                  '{currentReferrals}', currentMonthlyReferrals.toString())
              .replaceAll('{minimumRequired}', minimumRequired.toString()) ??
          'Your monthly referrals ($currentMonthlyReferrals) are below the minimum requirement ($minimumRequired). Your ambassador status may be affected.';

      await _notificationService.sendNotificationToUser(
        uid: userId,
        title: title,
        body: body,
        data: {
          'type': 'performance_warning',
          'currentReferrals': currentMonthlyReferrals.toString(),
          'minimumRequired': minimumRequired.toString(),
          'channel': ambassadorPerformanceChannel,
          'action': 'open_ambassador_dashboard',
          'priority': 'high',
        },
      );

      // Send local notification with high priority
      await _notificationService.sendLocalNotification(
        title: title,
        body: body,
        payload: 'performance_warning',
      );

      // Log the notification
      await _logNotification(
        userId: userId,
        type: 'performance_warning',
        title: title,
        body: body,
      );
    } catch (e) {
      debugPrint('Error sending performance warning notification: $e');
    }
  }

  /// Send ambassador demotion notification
  Future<void> sendAmbassadorDemotionNotification({
    required String userId,
    required String languageCode,
    required String reason,
  }) async {
    try {
      final templates = await _getLocalizedNotificationTemplates(languageCode);

      final title =
          templates['ambassadorDemotionTitle'] ?? 'Ambassador Status Update';
      final body = templates['ambassadorDemotionBody']
              ?.replaceAll('{reason}', reason) ??
          'Your ambassador status has been temporarily suspended due to: $reason. You can regain your status by meeting the requirements again.';

      await _notificationService.sendNotificationToUser(
        uid: userId,
        title: title,
        body: body,
        data: {
          'type': 'ambassador_demotion',
          'reason': reason,
          'channel': ambassadorPerformanceChannel,
          'action': 'open_ambassador_requirements',
          'priority': 'high',
        },
      );

      // Send local notification
      await _notificationService.sendLocalNotification(
        title: title,
        body: body,
        payload: 'ambassador_demotion',
      );

      // Log the notification
      await _logNotification(
        userId: userId,
        type: 'ambassador_demotion',
        title: title,
        body: body,
      );
    } catch (e) {
      debugPrint('Error sending ambassador demotion notification: $e');
    }
  }

  /// Send referral success notification
  Future<void> sendReferralSuccessNotification({
    required String userId,
    required String languageCode,
    required String referredUserName,
    required int totalReferrals,
  }) async {
    try {
      final templates = await _getLocalizedNotificationTemplates(languageCode);

      final title = templates['referralSuccessTitle'] ?? 'New Referral! 🎉';
      final body = templates['referralSuccessBody']
              ?.replaceAll('{referredUserName}', referredUserName)
              .replaceAll('{totalReferrals}', totalReferrals.toString()) ??
          '$referredUserName joined through your referral! You now have $totalReferrals total referrals.';

      await _notificationService.sendNotificationToUser(
        uid: userId,
        title: title,
        body: body,
        data: {
          'type': 'referral_success',
          'referredUserName': referredUserName,
          'totalReferrals': totalReferrals.toString(),
          'channel': ambassadorPromotionChannel,
          'action': 'open_ambassador_dashboard',
        },
      );

      // Send local notification
      await _notificationService.sendLocalNotification(
        title: title,
        body: body,
        payload: 'referral_success',
      );

      // Log the notification
      await _logNotification(
        userId: userId,
        type: 'referral_success',
        title: title,
        body: body,
      );
    } catch (e) {
      debugPrint('Error sending referral success notification: $e');
    }
  }

  /// Get localized notification templates from Firestore or fallback to default
  Future<Map<String, String>> _getLocalizedNotificationTemplates(
      String languageCode) async {
    try {
      final doc = await _firestore
          .collection('notification_templates')
          .doc('ambassador_notifications_$languageCode')
          .get();

      if (doc.exists) {
        return Map<String, String>.from(doc.data() ?? {});
      }
    } catch (e) {
      debugPrint('Error loading localized templates: $e');
    }

    // Fallback to English templates
    return _getDefaultEnglishTemplates();
  }

  /// Default English notification templates
  Map<String, String> _getDefaultEnglishTemplates() => {
        'ambassadorPromotionTitle':
            "Congratulations! You're now an Ambassador!",
        'ambassadorPromotionBody':
            'Welcome to the {tier} tier! Start sharing your referral link to earn rewards.',
        'tierUpgradeTitle': 'Tier Upgrade! 🎉',
        'tierUpgradeBody':
            "Amazing! You've been upgraded from {previousTier} to {newTier} with {totalReferrals} referrals!",
        'monthlyReminderTitle': 'Monthly Goal Reminder',
        'monthlyReminderBody':
            'You have {currentReferrals}/{targetReferrals} referrals this month. {daysRemaining} days left to reach your goal!',
        'performanceWarningTitle': 'Ambassador Performance Alert',
        'performanceWarningBody':
            'Your monthly referrals ({currentReferrals}) are below the minimum requirement ({minimumRequired}). Your ambassador status may be affected.',
        'ambassadorDemotionTitle': 'Ambassador Status Update',
        'ambassadorDemotionBody':
            'Your ambassador status has been temporarily suspended due to: {reason}. You can regain your status by meeting the requirements again.',
        'referralSuccessTitle': 'New Referral! 🎉',
        'referralSuccessBody':
            '{referredUserName} joined through your referral! You now have {totalReferrals} total referrals.',
      };

  /// Log notification for analytics and debugging
  Future<void> _logNotification({
    required String userId,
    required String type,
    required String title,
    required String body,
  }) async {
    try {
      await _firestore.collection('ambassador_notification_logs').add({
        'userId': userId,
        'type': type,
        'title': title,
        'body': body,
        'sentAt': FieldValue.serverTimestamp(),
        'platform': 'flutter',
      });
    } catch (e) {
      debugPrint('Error logging notification: $e');
    }
  }

  /// Schedule monthly reminder notifications for all active ambassadors
  Future<void> scheduleMonthlyReminders() async {
    try {
      final now = DateTime.now();
      final endOfMonth = DateTime(now.year, now.month + 1, 0);
      final daysUntilEndOfMonth = endOfMonth.difference(now).inDays;

      // Only schedule if we're 5 days before month end
      if (daysUntilEndOfMonth != 5) return;

      final ambassadors = await _firestore
          .collection('ambassador_profiles')
          .where('status', isEqualTo: 'approved')
          .get();

      for (final doc in ambassadors.docs) {
        final profile = AmbassadorProfile.fromJson(doc.data());

        // Only send reminder if they have less than 10 referrals this month
        if (profile.monthlyReferrals < 10) {
          await sendMonthlyReminderNotification(
            userId: profile.userId,
            languageCode: profile.languageCode,
            currentMonthlyReferrals: profile.monthlyReferrals,
            targetReferrals: 10,
            daysRemaining: daysUntilEndOfMonth,
          );
        }
      }
    } catch (e) {
      debugPrint('Error scheduling monthly reminders: $e');
    }
  }
}
