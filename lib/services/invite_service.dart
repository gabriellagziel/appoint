import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/contact.dart';
import '../models/invite.dart';

class InviteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> sendInvite(String appointmentId, Contact invitee,
      {bool requiresInstallFallback = false}) async {
    final doc = _firestore.collection('invites').doc();
    final invite = Invite(
      id: doc.id,
      appointmentId: appointmentId,
      inviteeId: invitee.id,
      inviteeContact: invitee,
      status: InviteStatus.pending,
      requiresInstallFallback: requiresInstallFallback,
    );
    await doc.set(invite.toMap());
  }

  Future<void> respondToInvite(
      String appointmentId, String inviteeId, InviteStatus status) async {
    final query = await _firestore
        .collection('invites')
        .where('appointmentId', isEqualTo: appointmentId)
        .where('inviteeId', isEqualTo: inviteeId)
        .get();
    for (final doc in query.docs) {
      await doc.reference.update({'status': status.name});
    }
  }

  Stream<List<Invite>> watchMyInvites() {
    final user = _auth.currentUser;
    if (user == null) {
      return const Stream.empty();
    }
    return _firestore
        .collection('invites')
        .where('inviteeId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Invite.fromMap(doc.data(), doc.id))
            .toList());
  }
}
