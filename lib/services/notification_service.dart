import 'dart:io';

import 'package:appoint/models/notification_payload.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Comprehensive notification service that handles both local and FCM notifications
class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Local notifications plugin
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  Function(NotificationPayload)? _onMessage;
  bool _isInitialized = false;

  /// Initialize the notification service
  Future<void> initialize({
    Function(NotificationPayload)? onMessage,
  }) async {
    if (_isInitialized) return;

    _onMessage = onMessage;

    // Initialize timezone
    tz.initializeTimeZones();

    // Initialize local notifications
    await _initializeLocalNotifications();

    // Initialize FCM
    await _initializeFCM();

    _isInitialized = true;
  }

  /// Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onLocalNotificationTapped,
    );
  }

  /// Initialize FCM
  Future<void> _initializeFCM() async {
    await _messaging.requestPermission();
    FirebaseMessaging.onMessage.listen(_handleMessage);
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  /// Handle local notification tap
  void _onLocalNotificationTapped(NotificationResponse response) {
    // Handle local notification tap
    // This can be customized based on the notification payload
    debugPrint('Local notification tapped: ${response.payload}');
  }

  /// Request notification permissions (Android only for now)
  Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      final status = await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
      return status ?? false;
    }
    return true; // iOS permissions are handled during initialization
  }

  /// Send a local notification immediately
  Future<void> sendLocalNotification({
    required String title,
    required String body,
    String? payload,
    int? id,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default Channel',
      channelDescription: 'Default notification channel',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      id ?? DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: payload,
    );
  }

  /// Schedule a local notification for a specific date/time
  Future<void> scheduleNotification({
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
    int? id,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'scheduled_channel',
      'Scheduled Notifications',
      channelDescription: 'Channel for scheduled notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.zonedSchedule(
      id ?? DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
    );
  }

  /// Send a push notification via FCM (stub implementation)
  Future<void> sendPushNotification({
    required String fcmToken,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      // This is a stub implementation - in a real app, this would call FCM
      debugPrint('FCM Stub: Sending notification to token: $fcmToken');
      debugPrint('Title: $title, Body: $body, Data: $data');

      // In a real implementation, you would call:
      // await _functions
      //     .httpsCallable('sendNotification')
      //     .call({
      //       'token': fcmToken,
      //       'title': title,
      //       'body': body,
      //       'data': data,
      //     });
    } catch (e) {
      debugPrint('Error sending push notification: $e');
      rethrow;
    }
  }

  /// Send notification to user by UID
  Future<void> sendNotificationToUser({
    required String uid,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      final token = doc.data()?['fcmToken'] as String?;

      if (token != null) {
        await sendPushNotification(
          fcmToken: token,
          title: title,
          body: body,
          data: data,
        );
      } else {
        debugPrint('No FCM token found for user: $uid');
      }
    } catch (e) {
      debugPrint('Error sending notification to user: $e');
      rethrow;
    }
  }

  /// Handle FCM message
  void _handleMessage(RemoteMessage message) {
    final payload = NotificationPayload(
      id: message.messageId ?? '',
      title: message.notification?.title ?? '',
      body: message.notification?.body ?? '',
      data: message.data.isNotEmpty ? message.data : null,
    );
    _onMessage?.call(payload);
  }

  /// Background message handler
  static Future<void> _backgroundHandler(RemoteMessage message) async {
    // In a real app, display a system notification here
    debugPrint('Background message received: ${message.messageId}');
  }

  /// Get FCM token
  Future<String?> getToken() async => _messaging.getToken();

  /// Save token for user using Firestore
  Future<void> saveTokenForUser(String uid) async {
    final token = await _messaging.getToken();
    if (token != null) {
      await _firestore
          .collection('users')
          .doc(uid)
          .set({'fcmToken': token}, SetOptions(merge: true));
    }
  }

  /// Send notification to specific token (legacy method)
  Future<void> sendNotification(
    final String token,
    final String title,
    final String body, {
    Map<String, dynamic>? data,
  }) async {
    await sendPushNotification(
      fcmToken: token,
      title: title,
      body: body,
      data: data,
    );
  }

  /// Send test notification
  Future<void> sendTestNotification(
    String token,
    final String title,
    final String body,
  ) async {
    await sendPushNotification(
      fcmToken: token,
      title: title,
      body: body,
    );
  }

  /// Fetch notifications for the given user.
  ///
  // TODO(username): Implement real notification fetching from Firestore
  Future<List<NotificationPayload>> fetchNotifications(String uid) async {
    // Stub implementation - returns empty list for now
    // In a real implementation, this would query Firestore for user notifications
    return [];
  }

  /// Show an informational message to the user
  void showInfo(String message) {
    // Stub implementation for UI notifications
    // In a real implementation, this would show a snackbar or toast
    print('INFO: $message');
  }

  /// Show a warning message to the user
  void showWarning(String message) {
    // Stub implementation for UI notifications
    // In a real implementation, this would show a snackbar or toast
    print('WARNING: $message');
  }

  /// Show an error message to the user
  void showError(String message) {
    // Stub implementation for UI notifications
    // In a real implementation, this would show a snackbar or toast
    print('ERROR: $message');
  }

  /// Show a success message to the user
  void showSuccess(String message) {
    // Stub implementation for UI notifications
    // In a real implementation, this would show a snackbar or toast
    print('SUCCESS: $message');
  }

  /// Cancel all pending notifications
  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  /// Cancel a specific notification by ID
  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }

  /// Get pending notification requests
  Future<List<PendingNotificationRequest>> getPendingNotifications() async =>
      _localNotifications.pendingNotificationRequests();
}
