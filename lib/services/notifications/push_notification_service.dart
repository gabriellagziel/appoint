import 'package:appoint/services/analytics/analytics_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationService {
  PushNotificationService._();
  static final PushNotificationService _instance = PushNotificationService._();
  static PushNotificationService get instance => _instance;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // Initialize notifications
  Future<void> initialize() async {
    // Request permission
    await _requestPermission();

    // Initialize local notifications
    await _initializeLocalNotifications();

    // Set up message handlers
    await _setupMessageHandlers();

    // Get FCM token
    await _getFCMToken();

    // Set up notification channels
    await _setupNotificationChannels();
  }

  // Request notification permission
  Future<void> _requestPermission() async {
    final settings = await _firebaseMessaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted notification permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional notification permission');
    } else {
      print('User declined notification permission');
    }
  }

  // Initialize local notifications
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
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  // Set up message handlers
  Future<void> _setupMessageHandlers() async {
    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle notification taps when app is opened
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // Handle initial notification when app is launched
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }
  }

  // Get FCM token
  Future<void> _getFCMToken() async {
    final token = await _firebaseMessaging.getToken();
    if (token != null) {
      print('FCM Token: $token');
      // TODO: Send token to backend
      await _sendTokenToServer(token);
    }

    // Listen for token refresh
    _firebaseMessaging.onTokenRefresh.listen((token) {
      print('FCM Token refreshed: $token');
      _sendTokenToServer(token);
    });
  }

  // Set up notification channels (Android)
  Future<void> _setupNotificationChannels() async {
    const androidChannel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  // Send token to server
  Future<void> _sendTokenToServer(String token) async {
    try {
      // TODO: Implement API call to send token to backend
      print('Sending FCM token to server: $token');
    } catch (e) {
      print('Failed to send FCM token to server: $e');
    }
  }

  // Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    print('Received foreground message: ${message.messageId}');

    // Show local notification
    _showLocalNotification(message);

    // Track notification received
    AnalyticsService.instance.trackUserAction(
      action: 'notification_received',
      parameters: {
        'message_id': message.messageId,
        'title': message.notification?.title,
        'body': message.notification?.body,
        'data': message.data,
      },
    );
  }

  // Handle notification tap
  void _handleNotificationTap(RemoteMessage message) {
    print('Notification tapped: ${message.messageId}');

    // Handle different notification types
    final data = message.data;
    final type = data['type'];

    switch (type) {
      case 'booking':
        _handleBookingNotification(data);
      case 'message':
        _handleMessageNotification(data);
      case 'reward':
        _handleRewardNotification(data);
      case 'subscription':
        _handleSubscriptionNotification(data);
      case 'family':
        _handleFamilyNotification(data);
      default:
        _handleGenericNotification(data);
    }

    // Track notification tap
    AnalyticsService.instance.trackUserAction(
      action: 'notification_tapped',
      parameters: {
        'message_id': message.messageId,
        'type': type,
        'data': data,
      },
    );
  }

  // Handle local notification tap
  void _onNotificationTapped(NotificationResponse response) {
    print('Local notification tapped: ${response.payload}');

    if (response.payload != null) {
      final data = Map<String, dynamic>.from(
        response.payload! as Map<String, dynamic>,
      );
      _handleNotificationTap(RemoteMessage(data: data));
    }
  }

  // Show local notification
  Future<void> _showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
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
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      details,
      payload: message.data.toString(),
    );
  }

  // Handle booking notifications
  void _handleBookingNotification(Map<String, dynamic> data) {
    final bookingId = data['bookingId'];
    if (bookingId != null) {
      // Navigate to booking details
      // TODO: Implement navigation
      print('Navigate to booking: $bookingId');
    }
  }

  // Handle message notifications
  void _handleMessageNotification(Map<String, dynamic> data) {
    final chatId = data['chatId'];
    if (chatId != null) {
      // Navigate to chat
      // TODO: Implement navigation
      print('Navigate to chat: $chatId');
    }
  }

  // Handle reward notifications
  void _handleRewardNotification(Map<String, dynamic> data) {
    final points = data['points'];
    if (points != null) {
      // Navigate to rewards
      // TODO: Implement navigation
      print('Navigate to rewards: $points points earned');
    }
  }

  // Handle subscription notifications
  void _handleSubscriptionNotification(Map<String, dynamic> data) {
    final subscriptionId = data['subscriptionId'];
    if (subscriptionId != null) {
      // Navigate to subscription
      // TODO: Implement navigation
      print('Navigate to subscription: $subscriptionId');
    }
  }

  // Handle family notifications
  void _handleFamilyNotification(Map<String, dynamic> data) {
    final memberId = data['memberId'];
    if (memberId != null) {
      // Navigate to family
      // TODO: Implement navigation
      print('Navigate to family member: $memberId');
    }
  }

  // Handle generic notifications
  void _handleGenericNotification(Map<String, dynamic> data) {
    // Handle generic notifications
    print('Handle generic notification: $data');
  }

  // Subscribe to topics
  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
    print('Subscribed to topic: $topic');
  }

  // Unsubscribe from topics
  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
    print('Unsubscribed from topic: $topic');
  }

  // Subscribe to user-specific topics
  Future<void> subscribeToUserTopics(String userId) async {
    await subscribeToTopic('user_$userId');
    await subscribeToTopic('bookings');
    await subscribeToTopic('messages');
    await subscribeToTopic('rewards');
  }

  // Subscribe to business topics
  Future<void> subscribeToBusinessTopics(String businessId) async {
    await subscribeToTopic('business_$businessId');
    await subscribeToTopic('bookings');
    await subscribeToTopic('analytics');
  }

  // Subscribe to family topics
  Future<void> subscribeToFamilyTopics(String familyId) async {
    await subscribeToTopic('family_$familyId');
    await subscribeToTopic('family_coordination');
  }

  // Send local notification
  Future<void> sendLocalNotification({
    required String title,
    required String body,
    String? payload,
    Map<String, dynamic>? data,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'local_channel',
      'Local Notifications',
      channelDescription: 'This channel is used for local notifications.',
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      details,
      payload: payload ?? data.toString(),
    );
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  // Cancel specific notification
  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }

  // Get notification settings
  Future<NotificationSettings> getNotificationSettings() async =>
      _firebaseMessaging.getNotificationSettings();

  // Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    final settings = await getNotificationSettings();
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }
}

// Background message handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling background message: ${message.messageId}');

  // Track background notification
  AnalyticsService.instance.trackUserAction(
    action: 'background_notification_received',
    parameters: {
      'message_id': message.messageId,
      'title': message.notification?.title,
      'body': message.notification?.body,
      'data': message.data,
    },
  );
}
