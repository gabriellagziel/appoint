import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/notification_settings.dart';

class UserSettingsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<NotificationSettings> fetchSettings(String uid) async {
    final doc = await _firestore
        .collection('users')
        .doc(uid)
        .collection('settings')
        .doc('notifications')
        .get();
    if (!doc.exists) {
      return NotificationSettings(push: false);
    }
    return NotificationSettings.fromJson(doc.data()!);
  }

  Future<void> updateSettings(String uid, NotificationSettings settings) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('settings')
        .doc('notifications')
        .set(settings.toJson());
  }
}
