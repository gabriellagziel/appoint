import 'dart:async';

import 'package:appoint/models/meeting_invitation.dart';
import 'package:appoint/services/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InvitationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final NotificationService _notificationService = NotificationService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const String _invitationsCollection = 'meeting_invitations';
  static const String _responsesCollection = 'invitation_responses';

  /// Send invitations to multiple users from a business
  Future<List<String>> sendInvitations(BusinessInvitationRequest request) async {
    final List<String> invitationIds = [];
    
    try {
      for (final userId in request.userIds) {
        final invitation = MeetingInvitation(
          id: '',
          businessId: request.businessId,
          businessName: request.businessName,
          businessLogo: request.businessProfile?['logo'] ?? '',
          userId: userId,
          userName: '', // Will be fetched from user profile
          meetingTitle: request.meetingTitle,
          meetingDescription: request.meetingDescription,
          proposedDateTime: request.proposedDateTime,
          duration: request.duration,
          status: InvitationStatus.pending,
          type: InvitationType.businessToUser,
          notes: request.notes,
          businessProfile: request.businessProfile,
          createdAt: DateTime.now(),
        );

        final docRef = await _firestore
            .collection(_invitationsCollection)
            .add(invitation.toJson());
        
        final invitationWithId = invitation.copyWith(id: docRef.id);
        await docRef.update({'id': docRef.id});
        
        invitationIds.add(docRef.id);
        
        // Send notification to user
        await _notificationService.sendNotificationToUser(
          uid: userId,
          title: 'Meeting Invitation',
          body: '${request.businessName} invited you to: ${request.meetingTitle}',
          data: {
            'type': 'meeting_invitation',
            'invitationId': docRef.id,
            'action': 'view_invitation',
            'businessId': request.businessId,
          },
        );
      }
      
      return invitationIds;
    } catch (e) {
      throw Exception('Failed to send invitations: $e');
    }
  }

  /// Get all invitations for a user
  Stream<List<MeetingInvitation>> getUserInvitations(String userId) {
    return _firestore
        .collection(_invitationsCollection)
        .where('userId', isEqualTo: userId)
        .where('status', whereIn: [
          InvitationStatus.pending.name,
          InvitationStatus.suggestedNewTime.name,
        ])
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MeetingInvitation.fromFirestore(doc))
            .toList());
  }

  /// Get all invitations sent by a business
  Stream<List<MeetingInvitation>> getBusinessInvitations(String businessId) {
    return _firestore
        .collection(_invitationsCollection)
        .where('businessId', isEqualTo: businessId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MeetingInvitation.fromFirestore(doc))
            .toList());
  }

  /// Respond to an invitation
  Future<void> respondToInvitation(InvitationResponse response) async {
    try {
      // Update invitation status
      await _firestore
          .collection(_invitationsCollection)
          .doc(response.invitationId)
          .update({
        'status': response.status.name,
        'respondedAt': response.respondedAt.toIso8601String(),
        'responseNotes': response.notes,
        if (response.suggestedDateTime != null)
          'suggestedDateTime': response.suggestedDateTime!.toIso8601String(),
      });

      // Get invitation details for notifications
      final invitationDoc = await _firestore
          .collection(_invitationsCollection)
          .doc(response.invitationId)
          .get();
      
      if (invitationDoc.exists) {
        final invitation = MeetingInvitation.fromFirestore(invitationDoc);
        
        // Notify business of response
        await _notifyBusinessOfResponse(invitation, response);
        
        // If accepted, create meeting/appointment
        if (response.status == InvitationStatus.accepted) {
          await _createMeetingFromInvitation(invitation);
        }
      }

      // Log response
      await _firestore
          .collection(_responsesCollection)
          .add(response.toJson());
          
    } catch (e) {
      throw Exception('Failed to respond to invitation: $e');
    }
  }

  /// Notify business of user's response
  Future<void> _notifyBusinessOfResponse(
    MeetingInvitation invitation,
    InvitationResponse response,
  ) async {
    String message;
    switch (response.status) {
      case InvitationStatus.accepted:
        message = '${invitation.userName} accepted your meeting invitation';
        break;
      case InvitationStatus.declined:
        message = '${invitation.userName} declined your meeting invitation';
        break;
      case InvitationStatus.suggestedNewTime:
        message = '${invitation.userName} suggested a different time for your meeting';
        break;
      default:
        return;
    }

    await _notificationService.sendNotificationToUser(
      uid: invitation.businessId,
      title: 'Meeting Response',
      body: message,
      data: {
        'type': 'invitation_response',
        'invitationId': invitation.id,
        'status': response.status.name,
        'userId': invitation.userId,
      },
    );
  }

  /// Create meeting from accepted invitation
  Future<void> _createMeetingFromInvitation(MeetingInvitation invitation) async {
    // This would integrate with the existing meeting service
    // For now, we'll create a basic meeting record
    await _firestore.collection('meetings').add({
      'businessId': invitation.businessId,
      'userId': invitation.userId,
      'title': invitation.meetingTitle,
      'description': invitation.meetingDescription,
      'scheduledAt': invitation.proposedDateTime.toIso8601String(),
      'duration': invitation.duration.inMinutes,
      'createdFromInvitation': true,
      'invitationId': invitation.id,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  /// Get invitation by ID
  Future<MeetingInvitation?> getInvitation(String invitationId) async {
    try {
      final doc = await _firestore
          .collection(_invitationsCollection)
          .doc(invitationId)
          .get();
      
      if (doc.exists) {
        return MeetingInvitation.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get invitation: $e');
    }
  }

  /// Delete expired invitations
  Future<void> cleanupExpiredInvitations() async {
    final cutoffDate = DateTime.now().subtract(const Duration(days: 30));
    
    final expiredInvitations = await _firestore
        .collection(_invitationsCollection)
        .where('status', isEqualTo: InvitationStatus.pending.name)
        .where('createdAt', isLessThan: cutoffDate.toIso8601String())
        .get();

    for (final doc in expiredInvitations.docs) {
      await doc.reference.update({
        'status': InvitationStatus.expired.name,
      });
    }
  }

  /// Get invitation statistics for business
  Future<Map<String, int>> getInvitationStats(String businessId) async {
    final invitations = await _firestore
        .collection(_invitationsCollection)
        .where('businessId', isEqualTo: businessId)
        .get();

    final stats = <String, int>{
      'total': 0,
      'pending': 0,
      'accepted': 0,
      'declined': 0,
      'expired': 0,
    };

    for (final doc in invitations.docs) {
      final invitation = MeetingInvitation.fromFirestore(doc);
      stats['total'] = (stats['total'] ?? 0) + 1;
      stats[invitation.status.name] = (stats[invitation.status.name] ?? 0) + 1;
    }

    return stats;
  }
} 