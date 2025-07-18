import 'package:appoint/models/support_ticket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FamilySupportService {

  FamilySupportService(
      {FirebaseFirestore? firestore, final FirebaseAuth? auth,})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CollectionReference<SupportTicket> get _collection =>
      _firestore.collection('supportTickets').withConverter<SupportTicket>(
            fromFirestore: (snap, final _) =>
                SupportTicket.fromJson(snap.data()!),
            toFirestore: (ticket, final _) => ticket.toJson(),
          );

  Future<void> submitTicket(String subject, final String message) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('Not logged in');
    final doc = _collection.doc();
    final ticket = SupportTicket(
      id: doc.id,
      userId: uid,
      subject: subject,
      message: message,
      createdAt: DateTime.now(),
    );
    await doc.set(ticket);
  }

  Stream<List<SupportTicket>> watchTickets() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return const Stream.empty();
    return _collection
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.data()).toList());
  }
}
