import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/notification_payload.dart';
import '../models/notification_item.dart';
import '../services/notification_service.dart';
import '../services/local_notification_service.dart';

final notificationServiceProvider =
    Provider<NotificationService>((ref) => NotificationService());

final notificationsProvider =
    StateProvider<List<NotificationPayload>>((ref) => []);

final fcmTokenProvider = FutureProvider<String?>((ref) {
  return ref.read(notificationServiceProvider).getToken();
});

/// Local in-memory notifications used for development and testing.
final localNotificationsProvider =
    StateProvider<List<NotificationItem>>((ref) => [
          NotificationItem(
            title: 'Welcome',
            body: 'Thanks for trying the app!',
            timestamp: DateTime.now(),
          ),
          NotificationItem(
            title: 'Reminder',
            body: 'This is a local notification sample.',
            timestamp: DateTime.now(),
          ),
        ]);

final REDACTED_TOKEN =
    Provider<LocalNotificationService>((ref) {
  return LocalNotificationService(
      ref.read(localNotificationsProvider.notifier));
});
