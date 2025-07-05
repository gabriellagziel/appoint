import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:appoint/models/contact.dart';
import 'package:appoint/models/invite.dart';
import 'package:appoint/services/notification_service.dart';

class InviteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> sendInvite(final String appointmentId, final Contact invitee,
      {final bool requiresInstallFallback = false}) async {
    final doc = _firestore.collection('invites').doc();
    final invite = Invite(
      id: doc.id,
      appointmentId: appointmentId,
      inviteeId: invitee.id,
      inviteeContact: invitee,
      status: InviteStatus.pending,
      requiresInstallFallback: requiresInstallFallback,
    );
    await doc.set(invite.toJson());
    await NotificationService().sendNotificationToUser(
        invitee.id, 'New Invite', 'You have a new invite');
  }

  Future<void> respondToInvite(final String appointmentId,
      final String inviteeId, final InviteStatus status) async {
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
        .map((final snapshot) => snapshot.docs
            .map((final doc) => Invite.fromJson(doc.data()))
            .toList());
  }
}
