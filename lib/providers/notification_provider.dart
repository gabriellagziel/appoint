import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/models/notification_payload.dart';

final notificationServiceProvider = Provider(
  (final ref) => throw UnimplementedError('NotificationService not implemented'),
);

// TODO: Implement proper notifications provider
final notificationsProvider =
    StateProvider<List<NotificationPayload>>((final ref) => []);

// TODO: Implement FCM token provider
final fcmTokenProvider = FutureProvider<String?>((final ref) async {
  // TODO: Replace with actual FCM token retrieval
  return null;
});
