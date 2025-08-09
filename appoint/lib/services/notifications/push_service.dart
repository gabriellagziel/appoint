import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../analytics/analytics_service.dart';

class PushService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static String? _fcmToken;
  static bool _isEnabled = false;

  /// Initialize push notifications
  static Future<void> initialize() async {
    try {
      // Request permission
      final settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      _isEnabled =
          settings.authorizationStatus == AuthorizationStatus.authorized;

      if (_isEnabled) {
        // Get FCM token
        _fcmToken = await _messaging.getToken();

        // Set up message handlers
        FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
        FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

        // Track permission granted
        AnalyticsService.track("push_permission_granted", {
          "platform": kIsWeb ? "web" : "mobile",
        });
      } else {
        AnalyticsService.track("push_permission_denied", {
          "platform": kIsWeb ? "web" : "mobile",
        });
      }
    } catch (e) {
      // Handle initialization errors gracefully
      _isEnabled = false;
      AnalyticsService.track("push_initialization_error", {
        "error": e.toString(),
        "platform": kIsWeb ? "web" : "mobile",
      });
    }
  }

  /// Check if push notifications are enabled
  static bool get isEnabled => _isEnabled;

  /// Get FCM token
  static String? get fcmToken => _fcmToken;

  /// Request permission (non-blocking)
  static Future<void> requestPermission() async {
    try {
      final settings = await _messaging.requestPermission();
      _isEnabled =
          settings.authorizationStatus == AuthorizationStatus.authorized;

      if (_isEnabled && _fcmToken == null) {
        _fcmToken = await _messaging.getToken();
      }

      AnalyticsService.track("push_permission_requested", {
        "granted": _isEnabled,
        "platform": kIsWeb ? "web" : "mobile",
      });
    } catch (e) {
      _isEnabled = false;
    }
  }

  /// Schedule a local notification (fallback)
  static Future<void> scheduleLocalNotification({
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    // TODO: Implement local notification scheduling
    // For now, just track the attempt
    AnalyticsService.track("local_notification_scheduled", {
      "title": title,
      "scheduledTime": scheduledTime.toIso8601String(),
    });
  }

  /// Send test push notification (stub for now)
  static Future<void> sendTestPush({
    required String title,
    required String body,
    String? fcmToken,
  }) async {
    // TODO: Implement server-side push sending
    // For now, just track the attempt
    AnalyticsService.track("test_push_sent", {
      "title": title,
      "body": body,
      "hasToken": fcmToken != null,
    });
  }

  /// Handle foreground messages
  static void _handleForegroundMessage(RemoteMessage message) {
    AnalyticsService.track("push_foreground_received", {
      "title": message.notification?.title,
      "body": message.notification?.body,
      "data": message.data.toString(),
    });

    // TODO: Show in-app notification
    print('Foreground message: ${message.notification?.title}');
  }

  /// Handle background messages
  @pragma('vm:entry-point')
  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    AnalyticsService.track("push_background_received", {
      "title": message.notification?.title,
      "body": message.notification?.body,
      "data": message.data.toString(),
    });

    // TODO: Handle background notification
    print('Background message: ${message.notification?.title}');
  }

  /// Subscribe to topic
  static Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      AnalyticsService.track("push_topic_subscribed", {
        "topic": topic,
      });
    } catch (e) {
      AnalyticsService.track("push_topic_subscribe_error", {
        "topic": topic,
        "error": e.toString(),
      });
    }
  }

  /// Unsubscribe from topic
  static Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      AnalyticsService.track("push_topic_unsubscribed", {
        "topic": topic,
      });
    } catch (e) {
      AnalyticsService.track("push_topic_unsubscribe_error", {
        "topic": topic,
        "error": e.toString(),
      });
    }
  }
}
