import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/notification_payload.dart';
import '../services/notification_service.dart';
import 'auth_provider.dart';

final userNotificationsProvider =
    FutureProvider<List<NotificationPayload>>((ref) {
  final uid = ref.watch(authProvider).currentUser?.uid;
  if (uid == null) return Future.value([]);
  return ref.read(notificationServiceProvider).fetchNotifications(uid);
});
