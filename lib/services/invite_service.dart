import 'package:appoint/models/contact.dart';
import 'package:appoint/models/invite.dart';
import 'package:appoint/services/notification_service.dart';
import 'package:appoint/services/whatsapp_group_share_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InviteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final WhatsAppGroupShareService _whatsappShareService = WhatsAppGroupShareService();

  Future<void> sendInvite(
    final String appointmentId, 
    final Contact invitee,
    {
      bool requiresInstallFallback = false,
      InviteSource source = InviteSource.direct_invite,
      String? shareId,
    }
  ) async {
    final doc = _firestore.collection('invites').doc();
    final invite = Invite(
      id: doc.id,
      appointmentId: appointmentId,
      inviteeId: invitee.id,
      inviteeContact: invitee,
      status: InviteStatus.pending,
      requiresInstallFallback: requiresInstallFallback,
      source: source,
      shareId: shareId,
    );
    await doc.set(invite.toJson());
    
    // Track participant join if this is from a shared link
    if (source == InviteSource.whatsapp_group && shareId != null) {
      await _whatsappShareService.trackParticipantJoined(
        shareId: shareId,
        appointmentId: appointmentId,
        participantId: invitee.id,
      );
    }
    
    await NotificationService().sendNotificationToUser(
        invitee.id, 'New Invite', 'You have a new invite',);
  }

  Future<void> respondToInvite(final String appointmentId,
      String inviteeId, final InviteStatus status,) async {
    final query = await _firestore
        .collection('invites')
        .where('appointmentId', isEqualTo: appointmentId)
        .where('inviteeId', isEqualTo: inviteeId)
        .get();
    for (final doc in query.docs) {
      await doc.reference.update({'status': status.name});
    }
  }

  /// Handle deep link invitation with source tracking
  Future<void> handleDeepLinkInvite({
    required String appointmentId,
    required String creatorId,
    required String inviteeId,
    InviteSource source = InviteSource.direct_invite,
    String? shareId,
  }) async {
    // Track link click if this is from a shared link
    if (source == InviteSource.whatsapp_group && shareId != null) {
      await _whatsappShareService.trackLinkClick(
        shareId: shareId,
        appointmentId: appointmentId,
      );
    }

    // Create the invite with source tracking
    final doc = _firestore.collection('invites').doc();
    final invite = Invite(
      id: doc.id,
      appointmentId: appointmentId,
      inviteeId: inviteeId,
      status: InviteStatus.pending,
      requiresInstallFallback: false,
      source: source,
      shareId: shareId,
    );

    await doc.set(invite.toJson());

    // Track participant join
    if (source == InviteSource.whatsapp_group && shareId != null) {
      await _whatsappShareService.trackParticipantJoined(
        shareId: shareId,
        appointmentId: appointmentId,
        participantId: inviteeId,
      );
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
            .map((doc) => Invite.fromJson(doc.data()))
            .toList(),);
  }

  /// Get invites by source for analytics
  Future<List<Invite>> getInvitesBySource({
    required String appointmentId,
    required InviteSource source,
  }) async {
    final query = await _firestore
        .collection('invites')
        .where('appointmentId', isEqualTo: appointmentId)
        .where('source', isEqualTo: source.name)
        .get();

    return query.docs
        .map((doc) => Invite.fromJson(doc.data()))
        .toList();
  }

  /// Get analytics for an appointment's invites
  Future<Map<String, dynamic>> getAppointmentInviteAnalytics(String appointmentId) async {
    final allInvites = await _firestore
        .collection('invites')
        .where('appointmentId', isEqualTo: appointmentId)
        .get();

    final invites = allInvites.docs
        .map((doc) => Invite.fromJson(doc.data()))
        .toList();

    final totalInvites = invites.length;
    final whatsappGroupInvites = invites
        .where((invite) => invite.source == InviteSource.whatsapp_group)
        .length;
    final acceptedInvites = invites
        .where((invite) => invite.status == InviteStatus.accepted)
        .length;
    final whatsappGroupAccepted = invites
        .where((invite) => 
            invite.source == InviteSource.whatsapp_group && 
            invite.status == InviteStatus.accepted)
        .length;

    return {
      'totalInvites': totalInvites,
      'whatsappGroupInvites': whatsappGroupInvites,
      'acceptedInvites': acceptedInvites,
      'whatsappGroupAccepted': whatsappGroupAccepted,
      'acceptanceRate': totalInvites > 0 ? (acceptedInvites / totalInvites) : 0.0,
      'whatsappGroupAcceptanceRate': whatsappGroupInvites > 0 
          ? (whatsappGroupAccepted / whatsappGroupInvites) : 0.0,
      'sourceBreakdown': {
        for (final source in InviteSource.values)
          source.name: invites.where((invite) => invite.source == source).length,
      },
    };
  }
}
