import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appoint/models/group_vote.dart';

class GroupVoteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get all votes for a group
  Future<List<GroupVote>> getGroupVotes(String groupId) async {
    try {
      final votesDoc = await _firestore
          .collection('groups')
          .doc(groupId)
          .collection('votes')
          .orderBy('createdAt', descending: true)
          .get();

      return votesDoc.docs.map((doc) {
        return GroupVote.fromMap(doc.id, doc.data());
      }).toList();
    } catch (e) {
      throw Exception('Failed to get group votes: $e');
    }
  }

  /// Get open votes for a group
  Future<List<GroupVote>> getOpenVotes(String groupId) async {
    try {
      final votesDoc = await _firestore
          .collection('groups')
          .doc(groupId)
          .collection('votes')
          .where('status', isEqualTo: 'open')
          .orderBy('createdAt', descending: true)
          .get();

      return votesDoc.docs.map((doc) {
        return GroupVote.fromMap(doc.id, doc.data());
      }).toList();
    } catch (e) {
      throw Exception('Failed to get open votes: $e');
    }
  }

  /// Get a specific vote
  Future<GroupVote?> getVote(String voteId) async {
    try {
      final voteDoc = await _firestore.collection('votes').doc(voteId).get();

      if (!voteDoc.exists) return null;

      return GroupVote.fromMap(voteId, voteDoc.data()!);
    } catch (e) {
      throw Exception('Failed to get vote: $e');
    }
  }

  /// Open a new vote
  Future<void> openVote(
      String groupId, String action, String targetUserId) async {
    try {
      final vote = GroupVote(
        id: '', // Will be set by Firestore
        groupId: groupId,
        action: action,
        targetUserId: targetUserId,
        status: 'open',
        createdAt: DateTime.now(),
        closesAt: DateTime.now().add(const Duration(days: 3)),
        ballots: {},
        yesCount: 0,
        noCount: 0,
      );

      await _firestore
          .collection('groups')
          .doc(groupId)
          .collection('votes')
          .add(vote.toMap());
    } catch (e) {
      throw Exception('Failed to open vote: $e');
    }
  }

  /// Cast a ballot in a vote
  Future<void> castBallot(String voteId, bool yes) async {
    try {
      final voteDoc = await _firestore.collection('votes').doc(voteId).get();

      if (!voteDoc.exists) {
        throw Exception('Vote not found');
      }

      final vote = GroupVote.fromMap(voteId, voteDoc.data()!);

      if (vote.status != 'open') {
        throw Exception('Vote is not open');
      }

      // Update the ballot
      await _firestore.collection('votes').doc(voteId).update({
        'ballots.$voteId': yes,
        'yesCount': yes ? vote.yesCount + 1 : vote.yesCount,
        'noCount': yes ? vote.noCount : vote.noCount + 1,
      });
    } catch (e) {
      throw Exception('Failed to cast ballot: $e');
    }
  }

  /// Close a vote and apply the result
  Future<void> closeVote(String voteId) async {
    try {
      final voteDoc = await _firestore.collection('votes').doc(voteId).get();

      if (!voteDoc.exists) {
        throw Exception('Vote not found');
      }

      final vote = GroupVote.fromMap(voteId, voteDoc.data()!);

      if (vote.status != 'open') {
        throw Exception('Vote is already closed');
      }

      // Determine the result
      final result = vote.yesCount > vote.noCount ? 'passed' : 'failed';

      // Update vote status
      await _firestore.collection('votes').doc(voteId).update({
        'status': 'closed',
        'result': result,
        'closedAt': FieldValue.serverTimestamp(),
      });

      // Apply the result if passed
      if (result == 'passed') {
        await _applyVoteResult(vote);
      }
    } catch (e) {
      throw Exception('Failed to close vote: $e');
    }
  }

  /// Apply the result of a passed vote
  Future<void> _applyVoteResult(GroupVote vote) async {
    switch (vote.action) {
      case 'promote_admin':
        // This would typically call GroupAdminService.promoteToAdmin
        // For now, we'll just log it
        print('Applying promote admin result for user: ${vote.targetUserId}');
        break;
      case 'demote_admin':
        // This would typically call GroupAdminService.demoteAdmin
        print('Applying demote admin result for user: ${vote.targetUserId}');
        break;
      case 'remove_member':
        // This would typically call GroupAdminService.removeMember
        print('Applying remove member result for user: ${vote.targetUserId}');
        break;
      default:
        print('Unknown vote action: ${vote.action}');
    }
  }

  /// Cancel a vote
  Future<void> cancelVote(String voteId, String actorUserId) async {
    try {
      final voteDoc = await _firestore.collection('votes').doc(voteId).get();

      if (!voteDoc.exists) {
        throw Exception('Vote not found');
      }

      final vote = GroupVote.fromMap(voteId, voteDoc.data()!);

      if (vote.status != 'open') {
        throw Exception('Vote is not open');
      }

      // Check if actor has permission to cancel
      // This would typically check user role
      // For now, we'll allow it

      await _firestore.collection('votes').doc(voteId).update({
        'status': 'cancelled',
        'cancelledAt': FieldValue.serverTimestamp(),
        'cancelledBy': actorUserId,
      });
    } catch (e) {
      throw Exception('Failed to cancel vote: $e');
    }
  }
}
