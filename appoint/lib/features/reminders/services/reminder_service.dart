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
}


