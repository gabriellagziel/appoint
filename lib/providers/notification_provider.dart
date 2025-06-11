import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/notification_payload.dart';
import '../services/notification_service.dart';

final notificationServiceProvider =
    Provider<NotificationService>((ref) => NotificationService());

final notificationsProvider =
    StateProvider<List<NotificationPayload>>((ref) => []);

final fcmTokenProvider = FutureProvider<String?>((ref) {
  return ref.read(notificationServiceProvider).getToken();
});
