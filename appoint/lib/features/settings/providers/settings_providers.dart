import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_settings.dart';

String? _safeUid(Ref ref) {
  // TODO: replace with your auth provider when available
  // return ref.read(currentUserIdProvider);
  return '';
}

final userSettingsStreamProvider = StreamProvider<UserSettings>((ref) async* {
  final uid = _safeUid(ref);
  if (uid == null || uid.isEmpty) {
    yield const UserSettings();
    return;
  }
  final doc = FirebaseFirestore.instance.collection('users').doc(uid);
  await for (final snap in doc.snapshots()) {
    final data = snap.data();
    final settings = (data?['settings'] as Map<String, dynamic>?) ?? {};
    yield UserSettings.fromMap(settings);
  }
});

final userSettingsControllerProvider = Provider<_UserSettingsController>((ref) {
  return _UserSettingsController(ref);
});

class _UserSettingsController {
  _UserSettingsController(this.ref);
  final Ref ref;

  Future<void> setDefaultSnooze(int minutes) async {
    final uid = _safeUid(ref);
    if (uid == null || uid.isEmpty) return;
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'settings': {'defaultSnoozeMinutes': minutes}
    }, SetOptions(merge: true));
  }
}
