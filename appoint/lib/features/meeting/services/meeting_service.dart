import 'package:cloud_firestore/cloud_firestore.dart';

class MeetingService {
  final _db = FirebaseFirestore.instance;

  Stream<Map<String, dynamic>?> watchMeeting(String id) =>
      _db.collection('meetings').doc(id).snapshots().map((d) => d.data());

  Stream<List<Map<String, dynamic>>> watchParticipants(String id) =>
      _db.collection('meetings').doc(id).collection('participants')
        .snapshots().map((s) => s.docs.map((d) => d.data()).toList());

  Stream<List<Map<String, dynamic>>> watchChat(String id) =>
      _db.collection('meetings').doc(id).collection('chat')
        .orderBy('createdAt', descending: false)
        .snapshots().map((s) => s.docs.map((d) => d.data()).toList());

  Future<void> rsvp(String id, String userId, String status) =>
      _db.collection('meetings').doc(id)
        .collection('participants').doc(userId)
        .set({'status': status, 'updatedAt': FieldValue.serverTimestamp()}, SetOptions(merge: true));

  Future<void> markArrived(String id, String userId, bool value) =>
      _db.collection('meetings').doc(id)
        .collection('participants').doc(userId)
        .set({'arrived': value, 'updatedAt': FieldValue.serverTimestamp()}, SetOptions(merge: true));

  Future<void> sendMessage(String id, String userId, String text) =>
      _db.collection('meetings').doc(id).collection('chat').add({
        'senderId': userId,
        'text': text,
        'createdAt': FieldValue.serverTimestamp(),
      });

  Stream<List<Map<String, dynamic>>> watchChecklist(String id) =>
      _db.collection('meetings').doc(id).collection('checklist')
        .orderBy('updatedAt', descending: false)
        .snapshots().map((s) => s.docs.map((d) => {'id': d.id, ...d.data()}).toList());

  Future<void> toggleChecklistItemSub(String id, String itemId, bool done) =>
      _db.collection('meetings').doc(id).collection('checklist').doc(itemId).set({
        'done': done,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

  Future<void> toggleChecklistItem(String id, String itemId, bool done) =>
      toggleChecklistItemSub(id, itemId, done);
}
