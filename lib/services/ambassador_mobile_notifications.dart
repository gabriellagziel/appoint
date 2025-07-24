import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:appoint/services/ambassador_notification_service.dart';
import 'package:appoint/models/ambassador_profile.dart';

/// Enhanced mobile push notification service for Ambassador program
class AmbassadorMobileNotifications {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = 
      FlutterLocalNotificationsPlugin();
  final AmbassadorNotificationService _ambassadorNotificationService;

  AmbassadorMobileNotifications(this._ambassadorNotificationService);

  /// Initialize mobile notifications for Ambassador events
  Future<void> initialize() async {
    // Request permissions
    await _requestPermissions();
    
    // Initialize local notifications with ambassador channels
    await _initializeLocalNotifications();
    
    // Set up FCM handlers
    await _setupFCMHandlers();
    
    // Initialize the base ambassador notification service
    await _ambassadorNotificationService.initialize();
  }

  /// Request notification permissions
  Future<bool> _requestPermissions() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint('Notification permission status: ${settings.authorizationStatus}');
    return settings.authorizationStatus == AuthorizationStatus.authorized ||
           settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  /// Initialize local notifications with Ambassador-specific channels
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      requestCriticalPermission: false,
    );
    
    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _localNotifications.initialize(
      initializationSettings,
      REDACTED_TOKEN: _onNotificationTapped,
    );

    // Create notification channels for Android
    if (Platform.isAndroid) {
      await REDACTED_TOKEN();
    }
  }

  /// Create notification channels for different Ambassador events
  Future<void> REDACTED_TOKEN() async {
    final androidPlugin = _localNotifications
        .REDACTED_TOKEN<REDACTED_TOKEN>();

    if (androidPlugin == null) return;

    // Ambassador Promotion Channel
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        AmbassadorNotificationService.ambassadorPromotionChannel,
        'Ambassador Promotions',
        description: 'Notifications for ambassador promotions and celebrations',
        importance: Importance.high,
        enableVibration: true,
        enableLights: true,
        ledColor: Color(0xFF4CAF50),
        showBadge: true,
        sound: REDACTED_TOKEN('promotion_sound'),
      ),
    );

    // Ambassador Performance Channel
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        AmbassadorNotificationService.ambassadorPerformanceChannel,
        'Ambassador Performance',
        description: 'Performance warnings and status updates',
        importance: Importance.high,
        enableVibration: true,
        enableLights: true,
        ledColor: Color(0xFFFF9800),
        showBadge: true,
        sound: REDACTED_TOKEN('warning_sound'),
      ),
    );

    // Ambassador Tier Upgrade Channel
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        AmbassadorNotificationService.ambassadorTierUpgradeChannel,
        'Tier Upgrades',
        description: 'Tier upgrade celebrations and rewards',
        importance: Importance.high,
        enableVibration: true,
        enableLights: true,
        ledColor: Color(0xFF2196F3),
        showBadge: true,
        sound: REDACTED_TOKEN('celebration_sound'),
      ),
    );

    // Ambassador Monthly Reminder Channel
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        AmbassadorNotificationService.REDACTED_TOKEN,
        'Monthly Reminders',
        description: 'Monthly goal reminders and progress updates',
        importance: Importance.defaultImportance,
        enableVibration: false,
        enableLights: true,
        ledColor: Color(0xFF9C27B0),
        showBadge: true,
      ),
    );
  }

  /// Set up FCM message handlers
  Future<void> _setupFCMHandlers() async {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle background message taps
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageTap);

    // Handle messages when app is launched from terminated state
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      await _handleMessageTap(initialMessage);
    }

    // Set up background message handler
    FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
  }

  /// Handle foreground messages
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    debugPrint('Received foreground message: ${message.messageId}');

    // Check if it's an ambassador notification
    final data = message.data;
    if (data.containsKey('type') && _isAmbassadorNotification(data['type'])) {
      await REDACTED_TOKEN(message);
    }
  }

  /// Handle message tap (when user taps notification)
  Future<void> _handleMessageTap(RemoteMessage message) async {
    debugPrint('Message tapped: ${message.messageId}');

    final data = message.data;
    final action = data['action'] ?? '';

    switch (action) {
      case 'open_ambassador_dashboard':
        await _navigateToAmbassadorDashboard();
        break;
      case 'open_ambassador_requirements':
        await REDACTED_TOKEN();
        break;
      case 'open_referral_sharing':
        await _navigateToReferralSharing();
        break;
      default:
        // Default navigation
        await _navigateToAmbassadorDashboard();
    }
  }

  /// Handle local notification tap
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('Local notification tapped: ${response.payload}');

    switch (response.payload) {
      case 'ambassador_promotion':
      case 'tier_upgrade':
      case 'monthly_reminder':
        _navigateToAmbassadorDashboard();
        break;
      case 'performance_warning':
      case 'ambassador_demotion':
        REDACTED_TOKEN();
        break;
      case 'referral_success':
        _navigateToReferralSharing();
        break;
    }
  }

  /// Show local notification for ambassador events
  Future<void> REDACTED_TOKEN(RemoteMessage message) async {
    final data = message.data;
    final type = data['type'] ?? '';
    final title = message.notification?.title ?? '';
    final body = message.notification?.body ?? '';

    final androidDetails = AndroidNotificationDetails(
      _getChannelForType(type),
      _getChannelNameForType(type),
      channelDescription: _getChannelDescriptionForType(type),
      importance: _getImportanceForType(type),
      priority: _getPriorityForType(type),
      icon: '@mipmap/ic_launcher',
      color: _getColorForType(type),
      enableVibration: _shouldVibrateForType(type),
      enableLights: true,
      ledColor: _getColorForType(type),
      showWhen: true,
      when: DateTime.now().millisecondsSinceEpoch,
      styleInformation: _getStyleInformationForType(type, title, body),
      actions: _getActionsForType(type),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'default',
      badgeNumber: 1,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      _getNotificationIdForType(type),
      title,
      body,
      details,
      payload: type,
    );
  }

  /// Send enhanced ambassador notification with mobile optimizations
  Future<void> REDACTED_TOKEN({
    required String userId,
    required AmbassadorNotificationType type,
    required String title,
    required String body,
    Map<String, String>? data,
    bool silent = false,
  }) async {
    try {
      // Get user's FCM token
      final userDoc = await _ambassadorNotificationService._firestore
          .collection('users')
          .doc(userId)
          .get();

      if (!userDoc.exists) return;

      final userData = userDoc.data()!;
      final fcmToken = userData['fcmToken'] as String?;

      if (fcmToken == null) {
        debugPrint('No FCM token found for user: $userId');
        return;
      }

      // Create message with mobile-optimized payload
      final message = {
        'token': fcmToken,
        'notification': {
          'title': title,
          'body': body,
        },
        'data': {
          'type': type.name,
          'action': _getActionForType(type),
          'channel': _getChannelForType(type.name),
          'priority': 'high',
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          ...?data,
        },
        'android': {
          'priority': 'high',
          'notification': {
            'channel_id': _getChannelForType(type.name),
            'priority': 'high',
            'default_sound': !silent,
            'default_vibrate_timings': !silent,
            'default_light_settings': true,
            'icon': '@mipmap/ic_launcher',
            'color': _getColorHexForType(type.name),
            'tag': type.name,
          },
        },
        'apns': {
          'payload': {
            'aps': {
              'alert': {
                'title': title,
                'body': body,
              },
              'sound': silent ? null : 'default',
              'badge': 1,
              'category': type.name,
              'thread-id': 'ambassador-notifications',
            },
          },
        },
      };

      // Send via FCM (this would typically call a cloud function)
      debugPrint('Sending enhanced ambassador notification: $message');

    } catch (e) {
      debugPrint('Error sending enhanced ambassador notification: $e');
    }
  }

  /// Helper methods for notification customization

  String _getChannelForType(String type) {
    switch (type) {
      case 'ambassador_promotion':
      case 'tier_upgrade':
      case 'referral_success':
        return AmbassadorNotificationService.ambassadorPromotionChannel;
      case 'performance_warning':
      case 'ambassador_demotion':
        return AmbassadorNotificationService.ambassadorPerformanceChannel;
      case 'monthly_reminder':
        return AmbassadorNotificationService.REDACTED_TOKEN;
      default:
        return 'default';
    }
  }

  String _getChannelNameForType(String type) {
    switch (type) {
      case 'ambassador_promotion':
      case 'tier_upgrade':
      case 'referral_success':
        return 'Ambassador Promotions';
      case 'performance_warning':
      case 'ambassador_demotion':
        return 'Ambassador Performance';
      case 'monthly_reminder':
        return 'Monthly Reminders';
      default:
        return 'Ambassador Notifications';
    }
  }

  String _getChannelDescriptionForType(String type) {
    switch (type) {
      case 'ambassador_promotion':
        return 'New ambassador promotion notifications';
      case 'tier_upgrade':
        return 'Tier upgrade celebration notifications';
      case 'referral_success':
        return 'Successful referral notifications';
      case 'performance_warning':
        return 'Performance warning notifications';
      case 'ambassador_demotion':
        return 'Ambassador status update notifications';
      case 'monthly_reminder':
        return 'Monthly goal reminder notifications';
      default:
        return 'General ambassador notifications';
    }
  }

  Importance _getImportanceForType(String type) {
    switch (type) {
      case 'ambassador_promotion':
      case 'tier_upgrade':
      case 'performance_warning':
      case 'ambassador_demotion':
        return Importance.high;
      case 'referral_success':
        return Importance.defaultImportance;
      case 'monthly_reminder':
        return Importance.low;
      default:
        return Importance.defaultImportance;
    }
  }

  Priority _getPriorityForType(String type) {
    switch (type) {
      case 'ambassador_promotion':
      case 'tier_upgrade':
      case 'performance_warning':
      case 'ambassador_demotion':
        return Priority.high;
      case 'referral_success':
        return Priority.defaultPriority;
      case 'monthly_reminder':
        return Priority.low;
      default:
        return Priority.defaultPriority;
    }
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'ambassador_promotion':
        return const Color(0xFF4CAF50);
      case 'tier_upgrade':
        return const Color(0xFF2196F3);
      case 'referral_success':
        return const Color(0xFF8BC34A);
      case 'performance_warning':
        return const Color(0xFFFF9800);
      case 'ambassador_demotion':
        return const Color(0xFFF44336);
      case 'monthly_reminder':
        return const Color(0xFF9C27B0);
      default:
        return const Color(0xFF6200EA);
    }
  }

  String _getColorHexForType(String type) {
    return '#${_getColorForType(type).value.toRadixString(16).substring(2)}';
  }

  bool _shouldVibrateForType(String type) {
    switch (type) {
      case 'ambassador_promotion':
      case 'tier_upgrade':
      case 'performance_warning':
      case 'ambassador_demotion':
        return true;
      case 'referral_success':
      case 'monthly_reminder':
        return false;
      default:
        return false;
    }
  }

  StyleInformation _getStyleInformationForType(String type, String title, String body) {
    switch (type) {
      case 'ambassador_promotion':
      case 'tier_upgrade':
        return BigTextStyleInformation(
          body,
          htmlFormatBigText: true,
          contentTitle: title,
          htmlFormatContentTitle: true,
        );
      default:
        return const DefaultStyleInformation(true, true);
    }
  }

  List<AndroidNotificationAction> _getActionsForType(String type) {
    switch (type) {
      case 'ambassador_promotion':
      case 'tier_upgrade':
        return [
          const AndroidNotificationAction(
            'view_dashboard',
            'View Dashboard',
            icon: DrawableResourceAndroidBitmap('@drawable/ic_dashboard'),
          ),
          const AndroidNotificationAction(
            'share_news',
            'Share',
            icon: DrawableResourceAndroidBitmap('@drawable/ic_share'),
          ),
        ];
      case 'performance_warning':
      case 'ambassador_demotion':
        return [
          const AndroidNotificationAction(
            'view_requirements',
            'View Requirements',
            icon: DrawableResourceAndroidBitmap('@drawable/ic_info'),
          ),
        ];
      case 'referral_success':
        return [
          const AndroidNotificationAction(
            'view_dashboard',
            'View Dashboard',
            icon: DrawableResourceAndroidBitmap('@drawable/ic_dashboard'),
          ),
          const AndroidNotificationAction(
            'share_more',
            'Share More',
            icon: DrawableResourceAndroidBitmap('@drawable/ic_share'),
          ),
        ];
      default:
        return [];
    }
  }

  int _getNotificationIdForType(String type) {
    switch (type) {
      case 'ambassador_promotion':
        return 1001;
      case 'tier_upgrade':
        return 1002;
      case 'referral_success':
        return 1003;
      case 'performance_warning':
        return 1004;
      case 'ambassador_demotion':
        return 1005;
      case 'monthly_reminder':
        return 1006;
      default:
        return 1000;
    }
  }

  String _getActionForType(AmbassadorNotificationType type) {
    switch (type) {
      case AmbassadorNotificationType.PROMOTION:
      case AmbassadorNotificationType.TIER_UPGRADE:
      case AmbassadorNotificationType.REFERRAL_SUCCESS:
      case AmbassadorNotificationType.MONTHLY_REMINDER:
        return 'open_ambassador_dashboard';
      case AmbassadorNotificationType.PERFORMANCE_WARNING:
      case AmbassadorNotificationType.DEMOTION:
        return 'open_ambassador_requirements';
    }
  }

  bool _isAmbassadorNotification(String? type) {
    const ambassadorTypes = [
      'ambassador_promotion',
      'tier_upgrade',
      'referral_success',
      'performance_warning',
      'ambassador_demotion',
      'monthly_reminder',
    ];
    return type != null && ambassadorTypes.contains(type);
  }

  /// Navigation helpers (these would typically use Navigator or routing)
  Future<void> _navigateToAmbassadorDashboard() async {
    debugPrint('Navigating to Ambassador Dashboard');
    // Implement navigation logic
  }

  Future<void> REDACTED_TOKEN() async {
    debugPrint('Navigating to Ambassador Requirements');
    // Implement navigation logic
  }

  Future<void> _navigateToReferralSharing() async {
    debugPrint('Navigating to Referral Sharing');
    // Implement navigation logic
  }
}

/// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  debugPrint('Background message received: ${message.messageId}');
  
  // Handle background ambassador notifications
  final data = message.data;
  if (data.containsKey('type') && data['type'].toString().contains('ambassador')) {
    // Log analytics or perform other background tasks
    debugPrint('Ambassador background notification: ${data['type']}');
  }
}

/// Ambassador notification types for mobile
enum AmbassadorNotificationType {
  PROMOTION,
  TIER_UPGRADE,
  REFERRAL_SUCCESS,
  PERFORMANCE_WARNING,
  DEMOTION,
  MONTHLY_REMINDER,
}