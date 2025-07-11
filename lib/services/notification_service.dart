import 'package:appoint/models/notification_payload.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// Service for showing user notifications
class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Function(NotificationPayload)? _onMessage;

  Future<void> initialize(
      {Function(NotificationPayload)? onMessage,}) async {
    _onMessage = onMessage;
    await _messaging.requestPermission();
    FirebaseMessaging.onMessage.listen(_handleMessage);
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    final payload = NotificationPayload(
      id: message.messageId ?? '',
      title: message.notification?.title ?? '',
      body: message.notification?.body ?? '',
      data: message.data.isNotEmpty ? message.data : null,
    );
    _onMessage?.call(payload);
  }

  static Future<void> _backgroundHandler(RemoteMessage message) async {
    // In a real app, display a system notification here
    // ignore: avoid_print
    // Removed debug print: debugPrint('BG message: ${message.messageId}');
  }

  Future<String?> getToken() => _messaging.getToken();

  Future<void> saveTokenForUser(String uid) async {
    token = await _messaging.getToken();
    if (token != null) {
      await _firestore
          .collection('users')
          .doc(uid)
          .set({'fcmToken': token}, SetOptions(merge: true));
    }
  }

  Future<void> sendNotification(
      final String token, final String title, final String body,
      {Map<String, dynamic>? data,}) async {
    await _functions
        .httpsCallable('sendNotification')
        .call({'token': token, 'title': title, 'body': body, 'data': data});
  }

  Future<void> sendNotificationToUser(
      String uid, final String title, final String body,) async {
    doc = await _firestore.collection('users').doc(uid).get();
    token = doc.data()?['fcmToken'] as String?;
    if (token != null) {
      await sendNotification(token, title, body);
    }
  }

  Future<void> sendTestNotification(
      String token, final String title, final String body,) async {
    final callable =
        FirebaseFunctions.instance.httpsCallable('sendNotification');
    await callable.call({
      'token': token,
      'title': title,
      'body': body,
    });
  }

  /// Fetch notifications for the given user.
  ///
  /// TODO(username): Implement real notification fetching from Firestore
  Future<List<NotificationPayload>> fetchNotifications(String uid) async {
    // TODO(username): Replace with real Firestore query for user notifications
    return [];
  }

  /// Show an informational message to the user
  void showInfo(String message) {
    // Implementation for UI notifications
    // This would typically show a snackbar or toast
  }

  /// Show a warning message to the user
  void showWarning(String message) {
    // Implementation for UI notifications
    // This would typically show a snackbar or toast
  }

  /// Show an error message to the user
  void showError(String message) {
    // Implementation for UI notifications
    // This would typically show a snackbar or toast
  }

  /// Show a success message to the user
  void showSuccess(String message) {
    // Implementation for UI notifications
    // This would typically show a snackbar or toast
  }
}
