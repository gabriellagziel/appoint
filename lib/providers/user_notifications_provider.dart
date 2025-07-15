import 'package:appoint/models/notification_payload.dart';
import 'package:appoint/providers/auth_provider.dart';
import 'package:appoint/services/notification_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userNotificationsProvider =
    FutureProvider<List<NotificationPayload>>((ref) {
  final uid = ref.watch(authProvider).currentUser?.uid;
  if (uid == null) return Future.value([]);
  final notificationService = NotificationService();
  return notificationService.fetchNotifications(uid);
});
