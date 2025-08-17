import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/group_vote.dart';
import '../../../models/group_audit_event.dart';
import 'group_audit_service.dart';
import 'group_admin_service.dart';

class GroupVoteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GroupAuditService _auditService = GroupAuditService();
  final GroupAdminService _adminService = GroupAdminService();

  /// Open a new vote
  Future<bool> openVote({
    required String groupId,
    required String action,
    required String targetUserId,
    required String createdBy,
    DateTime? closesAt,
  }) async {
    try {
      final voteId = _firestore.collection('votes').doc().id;
      final vote = GroupVote(
        id: voteId,
        groupId: groupId,
        action: action,
        targetUserId: targetUserId,
        createdBy: createdBy,
        createdAt: DateTime.now(),
        closesAt: closesAt ?? DateTime.now().add(const Duration(hours: 48)),
        status: 'open',
      );

      await _firestore
          .collection('user_groups')
          .doc(groupId)
          .collection('votes')
          .doc(voteId)
          .set(vote.toMap());

      // Log audit event
      await _auditService.logEvent(
        groupId: groupId,
        actorUserId: createdBy,
        type: AuditEventType.voteOpened,
        metadata: {
          'voteId': voteId,
          'voteAction': action,
          'targetUserId': targetUserId,
        },
      );

      return true;
    } catch (e) {
      print('Error opening vote: $e');
      return false;
    }
  }

  /// Cast a ballot
  Future<bool> castBallot(String voteId, String userId, bool vote) async {
    try {
      // Get the vote
      final voteDoc = await _firestore.collection('votes').doc(voteId).get();

      if (!voteDoc.exists) return false;

      final groupVote = GroupVote.fromMap(voteId, voteDoc.data()!);

      // Check if vote is still open
      if (!groupVote.isOpen || groupVote.isExpired) return false;

      // Check if user has already voted
      if (groupVote.hasVoted(userId)) return false;

      // Update the vote with new ballot
      final updatedBallots = Map<String, bool>.from(groupVote.ballots);
      updatedBallots[userId] = vote;

      await _firestore
          .collection('votes')
          .doc(voteId)
          .update({'ballots': updatedBallots});

      return true;
    } catch (e) {
      print('Error casting ballot: $e');
      return false;
    }
  }

  /// Close a vote and execute result
  Future<bool> closeVote(String voteId) async {
    try {
      // Get the vote
      final voteDoc = await _firestore.collection('votes').doc(voteId).get();

      if (!voteDoc.exists) return false;

      final groupVote = GroupVote.fromMap(voteId, voteDoc.data()!);

      // Check if vote is already closed
      if (groupVote.isClosed) return false;

      // Close the vote
      await _firestore
          .collection('votes')
          .doc(voteId)
          .update({'status': 'closed'});

      // Execute result if passed
      bool executed = false;
      if (groupVote.hasPassed) {
        executed = await _adminService.executeVoteResult(groupVote);
      }

      // Log audit event
      await _auditService.logEvent(
        groupId: groupVote.groupId,
        actorUserId: groupVote.createdBy,
        type: AuditEventType.voteClosed,
        metadata: {
          'voteId': voteId,
          'voteAction': groupVote.action,
          'votePassed': groupVote.hasPassed,
          'executed': executed,
          'totalVotes': groupVote.totalVotes,
          'yesVotes': groupVote.yesVotes,
          'noVotes': groupVote.noVotes,
        },
      );

      return true;
    } catch (e) {
      print('Error closing vote: $e');
      return false;
    }
  }

  /// Cancel a vote
  Future<bool> cancelVote(String voteId, String actorUserId) async {
    try {
      // Get the vote
      final voteDoc = await _firestore.collection('votes').doc(voteId).get();

      if (!voteDoc.exists) return false;

      final groupVote = GroupVote.fromMap(voteId, voteDoc.data()!);

      // Check if vote is already closed
      if (groupVote.isClosed) return false;

      // Cancel the vote
      await _firestore
          .collection('votes')
          .doc(voteId)
          .update({'status': 'cancelled'});

      // Log audit event
      await _auditService.logEvent(
        groupId: groupVote.groupId,
        actorUserId: actorUserId,
        type: AuditEventType.voteCancelled,
        metadata: {
          'voteId': voteId,
          'voteAction': groupVote.action,
        },
      );

      return true;
    } catch (e) {
      print('Error cancelling vote: $e');
      return false;
    }
  }

  /// Get all votes for a group
  Future<List<GroupVote>> getGroupVotes(String groupId) async {
    try {
      final querySnapshot = await _firestore
          .collection('user_groups')
          .doc(groupId)
          .collection('votes')
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => GroupVote.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      print('Error getting group votes: $e');
      return [];
    }
  }

  /// Get open votes for a group
  Future<List<GroupVote>> getOpenVotes(String groupId) async {
    try {
      final allVotes = await getGroupVotes(groupId);
      return allVotes.where((vote) => vote.isOpen && !vote.isExpired).toList();
    } catch (e) {
      print('Error getting open votes: $e');
      return [];
    }
  }

  /// Get a specific vote
  Future<GroupVote?> getVote(String voteId) async {
    try {
      final voteDoc = await _firestore.collection('votes').doc(voteId).get();

      if (!voteDoc.exists) return null;

      return GroupVote.fromMap(voteId, voteDoc.data()!);
    } catch (e) {
      print('Error getting vote: $e');
      return null;
    }
  }

  /// Check if user can vote on a specific vote
  Future<bool> canUserVote(String voteId, String userId) async {
    try {
      final vote = await getVote(voteId);
      if (vote == null) return false;

      // Check if vote is open and not expired
      if (!vote.isOpen || vote.isExpired) return false;

      // Check if user has already voted
      if (vote.hasVoted(userId)) return false;

      // TODO: Check if user is a member of the group
      // This would require getting group members and checking membership

      return true;
    } catch (e) {
      print('Error checking if user can vote: $e');
      return false;
    }
  }
}
