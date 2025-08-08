import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/group_policy.dart';
import '../../../models/group_audit_event.dart';
import 'group_audit_service.dart';

class GroupPolicyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GroupAuditService _auditService = GroupAuditService();

  /// Get policy for a group
  Future<GroupPolicy> getPolicy(String groupId) async {
    try {
      final groupDoc =
          await _firestore.collection('user_groups').doc(groupId).get();
      if (!groupDoc.exists) return const GroupPolicy();

      final data = groupDoc.data()!;
      final policyData = data['policy'] as Map<String, dynamic>?;

      if (policyData == null) return const GroupPolicy();

      return GroupPolicy.fromMap(policyData);
    } catch (e) {
      print('Error getting group policy: $e');
      return const GroupPolicy();
    }
  }

  /// Update policy for a group
  Future<bool> updatePolicy(
      String groupId, GroupPolicy newPolicy, String actorUserId) async {
    try {
      await _firestore.collection('user_groups').doc(groupId).update({
        'policy': newPolicy.toMap(),
      });

      // Log audit event
      await _auditService.logEvent(
        groupId: groupId,
        actorUserId: actorUserId,
        type: AuditEventType.policyChanged,
        metadata: {
          'membersCanInvite': newPolicy.membersCanInvite,
          'requireVoteForAdmin': newPolicy.requireVoteForAdmin,
          'allowNonMembersRSVP': newPolicy.allowNonMembersRSVP,
          'allowMediaSharing': newPolicy.allowMediaSharing,
          'allowChecklists': newPolicy.allowChecklists,
          'maxMembers': newPolicy.maxMembers,
          'voteDurationHours': newPolicy.voteDuration.inHours,
        },
      );

      return true;
    } catch (e) {
      print('Error updating group policy: $e');
      return false;
    }
  }

  /// Update specific policy settings
  Future<bool> updatePolicySettings(
      String groupId, Map<String, dynamic> settings, String actorUserId) async {
    try {
      final currentPolicy = await getPolicy(groupId);
      final updatedPolicy = currentPolicy.copyWith(
        membersCanInvite:
            settings['membersCanInvite'] ?? currentPolicy.membersCanInvite,
        requireVoteForAdmin: settings['requireVoteForAdmin'] ??
            currentPolicy.requireVoteForAdmin,
        allowNonMembersRSVP: settings['allowNonMembersRSVP'] ??
            currentPolicy.allowNonMembersRSVP,
        allowMediaSharing:
            settings['allowMediaSharing'] ?? currentPolicy.allowMediaSharing,
        allowChecklists:
            settings['allowChecklists'] ?? currentPolicy.allowChecklists,
        maxMembers: settings['maxMembers'] ?? currentPolicy.maxMembers,
        voteDuration: settings['voteDuration'] ?? currentPolicy.voteDuration,
        lastUpdated: DateTime.now(),
        updatedBy: actorUserId,
      );

      return await updatePolicy(groupId, updatedPolicy, actorUserId);
    } catch (e) {
      print('Error updating policy settings: $e');
      return false;
    }
  }

  /// Check if a specific policy allows an action
  Future<bool> checkPolicy(String groupId, String policyKey) async {
    try {
      final policy = await getPolicy(groupId);

      switch (policyKey) {
        case 'membersCanInvite':
          return policy.membersCanInvite;
        case 'requireVoteForAdmin':
          return policy.requireVoteForAdmin;
        case 'allowNonMembersRSVP':
          return policy.allowNonMembersRSVP;
        case 'allowMediaSharing':
          return policy.allowMediaSharing;
        case 'allowChecklists':
          return policy.allowChecklists;
        default:
          return false;
      }
    } catch (e) {
      print('Error checking policy: $e');
      return false;
    }
  }

  /// Get default policy
  GroupPolicy getDefaultPolicy() {
    return const GroupPolicy();
  }

  /// Validate policy settings
  bool validatePolicy(GroupPolicy policy) {
    // Check if max members is reasonable
    if (policy.maxMembers < 2 || policy.maxMembers > 1000) return false;

    // Check if vote duration is reasonable
    if (policy.voteDuration.inHours < 1 || policy.voteDuration.inDays > 30)
      return false;

    return true;
  }
}
