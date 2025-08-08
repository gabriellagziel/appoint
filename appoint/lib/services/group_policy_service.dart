import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appoint/models/group_policy.dart';

class GroupPolicyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get group policy
  Future<GroupPolicy> getGroupPolicy(String groupId) async {
    try {
      final policyDoc = await _firestore
          .collection('groups')
          .doc(groupId)
          .collection('policy')
          .doc('settings')
          .get();

      if (!policyDoc.exists) {
        // Return default policy if none exists
        return GroupPolicy.defaultPolicy();
      }

      return GroupPolicy.fromMap(policyDoc.data()!);
    } catch (e) {
      throw Exception('Failed to get group policy: $e');
    }
  }

  /// Update group policy
  Future<void> updatePolicy(String groupId, GroupPolicy policy) async {
    try {
      await _firestore
          .collection('groups')
          .doc(groupId)
          .collection('policy')
          .doc('settings')
          .set(policy.toMap());
    } catch (e) {
      throw Exception('Failed to update group policy: $e');
    }
  }

  /// Update specific policy settings
  Future<void> updatePolicySettings(
      String groupId, Map<String, dynamic> settings) async {
    try {
      await _firestore
          .collection('groups')
          .doc(groupId)
          .collection('policy')
          .doc('settings')
          .update(settings);
    } catch (e) {
      throw Exception('Failed to update policy settings: $e');
    }
  }

  /// Get policy for a specific action
  Future<bool> getPolicyForAction(String groupId, String action) async {
    try {
      final policy = await getGroupPolicy(groupId);

      switch (action) {
        case 'membersCanInvite':
          return policy.membersCanInvite;
        case 'requireVoteForAdmin':
          return policy.requireVoteForAdmin;
        case 'allowNonMembersRSVP':
          return policy.allowNonMembersRSVP;
        default:
          return false;
      }
    } catch (e) {
      throw Exception('Failed to get policy for action: $e');
    }
  }
}
