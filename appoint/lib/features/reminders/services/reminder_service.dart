import 'package:cloud_firestore/cloud_firestore.dart';

class ReminderService {
  final _col = FirebaseFirestore.instance.collection('reminders');

  Future<bool> createReminder(Map<String, dynamic> data) async {
    try {
      await _col.add(data);
      return true;
    } catch (_) {
      return false;
    }
  }

  Stream<List<Map<String, dynamic>>> streamRemindersForUser(String uid) {
    return _col
        .where('targets', arrayContains: uid)
        .orderBy('when', descending: false)
        .limit(100)
        .snapshots()
        .map((q) => q.docs.map((d) => {'id': d.id, ...d.data()}).toList());
  }

  Future<void> toggleDone(String id, bool done) async {
    await _col.doc(id).update({'done': done});
  }

  Future<void> updateReminder(String id, Map<String, dynamic> data) {
    return _col.doc(id).update(data);
  }

  Future<void> snoozeReminder(String id,
      {Duration by = const Duration(minutes: 15)}) async {
    final doc = _col.doc(id);
    final snap = await doc.get();
    final data = snap.data();
    if (data == null) return;
    final dynamic whenRaw = data['when'];
    DateTime? when;
    if (whenRaw is Timestamp) {
      when = whenRaw.toDate();
    } else if (whenRaw is DateTime) {
      when = whenRaw;
    }
    if (when == null) return;
    await doc.update({'when': when.add(by)});
  }

  static DateTime? nextOccurrence(DateTime? when, String? recurrence) {
    if (when == null) return null;
    final mode = (recurrence ?? 'none').toLowerCase();
    if (mode == 'none') return null;
    final now = DateTime.now();
    var next = when;
    while (!next.isAfter(now)) {
      if (mode == 'daily') {
        next = next.add(const Duration(days: 1));
      } else if (mode == 'weekly') {
        next = next.add(const Duration(days: 7));
      } else {
        break;
      }
    }
    return next;
  }
}
