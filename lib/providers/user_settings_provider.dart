import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appoint/models/notification_settings.dart';
import 'package:appoint/services/user_settings_service.dart';

final userSettingsServiceProvider =
    Provider<UserSettingsService>((final ref) => UserSettingsService());

final notificationSettingsProvider =
    FutureProvider<NotificationSettings>((final ref) async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) {
    return NotificationSettings(push: false);
  }
  return ref.read(userSettingsServiceProvider).fetchSettings(uid);
});
