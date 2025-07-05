import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:appoint/models/notification_settings.dart';

class UserSettingsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<NotificationSettings> fetchSettings(final String uid) async {
    final doc = await _firestore
        .collection('users')
        .doc(uid)
        .collection('settings')
        .doc('notifications')
        .get();
    if (!doc.exists) {
      return NotificationSettings(push: false);
    }
    return NotificationSettings.fromJson(doc.data() as Map<String, dynamic>);
  }

  Future<void> updateSettings(
      final String uid, final NotificationSettings settings) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('settings')
        .doc('notifications')
        .set(settings.toJson());
  }
}
