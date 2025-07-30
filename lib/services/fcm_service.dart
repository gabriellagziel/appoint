import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FCMService {
  factory FCMService() => _instance;
  FCMService._internal();
  static final FCMService _instance = FCMService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Global navigator key for accessing context
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// Initialize FCM service
  Future<void> initialize() async {
    try {
      // Request permission
      final settings = await _messaging.requestPermission();

      // Removed debug print: debugPrint('FCM Permission status: ${settings.authorizationStatus}');

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        // Get FCM token
        final token = await _messaging.getToken();
        if (token != null) {
          // Removed debug print: debugPrint('FCM Token: $token');
          await _saveTokenToFirestore(token);
        }

        // Listen for token refresh
        _messaging.onTokenRefresh.listen(_saveTokenToFirestore);

        // Handle foreground messages
        FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

        // Handle notification tap when app is in background
        FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

        // Handle notification tap when app is terminated
        final initialMessage = await _messaging.getInitialMessage();
        if (initialMessage != null) {
          _handleNotificationTap(initialMessage);
        }
      }
    } catch (e) {
      // Removed debug print: debugPrint('Error initializing FCM: $e');
    }
  }

  /// Save FCM token to Firestore
  Future<void> _saveTokenToFirestore(String token) async {
    try {
      // Get current user ID (you may need to adjust this based on your auth setup)
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Save to studio collection if user is a studio owner
        await _firestore
            .collection('studio')
            .doc(user.uid)
            .set({'fcmToken': token}, SetOptions(merge: true));

        // Also save to business collection for business users
        await _firestore
            .collection('business')
            .doc(user.uid)
            .set({'fcmToken': token}, SetOptions(merge: true));

        // Removed debug print: debugPrint('FCM token saved to Firestore');
      }
    } catch (e) {
      // Removed debug print: debugPrint('Error saving FCM token: $e');
    }
  }

  /// Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    // Removed debug print: debugPrint('Received foreground message: ${message.notification?.title}');

    // Show SnackBar notification
    if (navigatorKey.currentContext != null) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text(message.notification?.body ?? 'New booking received'),
          action: SnackBarAction(
            label: 'View',
            onPressed: _navigateToBookings,
          ),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  /// Handle notification tap
  void _handleNotificationTap(RemoteMessage message) {
    // Removed debug print: debugPrint('Notification tapped: ${message.notification?.title}');
    _navigateToBookings();
  }

  /// Navigate to bookings page
  void _navigateToBookings() {
    if (navigatorKey.currentContext != null) {
      final router = GoRouter.of(navigatorKey.currentContext!);
      router.push('/studio/bookings');
    }
  }

  /// Get FCM token
  Future<String?> getToken() async => _messaging.getToken();

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
  }
}
