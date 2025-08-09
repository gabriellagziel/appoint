import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/group_role.dart';
import '../../../models/group_audit_event.dart';
import '../../../models/group_vote.dart';
import 'group_audit_service.dart';
import 'group_vote_service.dart';
import 'group_policy_service.dart';

class GroupAdminService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GroupAuditService _auditService = GroupAuditService();
  final GroupVoteService _voteService = GroupVoteService();
  final GroupPolicyService _policyService = GroupPolicyService();

  /// Get group members with their roles
  Future<List<GroupMember>> getGroupMembers(String groupId) async {
    try {
      final groupDoc =
          await _firestore.collection('user_groups').doc(groupId).get();
      if (!groupDoc.exists) return [];

      final data = groupDoc.data()!;
      final members = <GroupMember>[];

      // Get owner
      if (data['ownerId'] != null) {
        members.add(GroupMember(
          userId: data['ownerId'],
          role: GroupRole.owner,
          joinedAt: (data['createdAt'] as Timestamp).toDate(),
        ));
      }

      // Get roles from roles map
      final rolesMap = Map<String, dynamic>.from(data['roles'] ?? {});
      for (final entry in rolesMap.entries) {
        final userId = entry.key;
        final roleData = entry.value as Map<String, dynamic>;

        // Skip if this is the owner (already added)
        if (userId == data['ownerId']) continue;

        members.add(GroupMember(
          userId: userId,
          role: GroupRole.values.firstWhere(
            (role) => role.name == roleData['role'],
            orElse: () => GroupRole.member,
          ),
          joinedAt: (roleData['joinedAt'] as Timestamp).toDate(),
          invitedBy: roleData['invitedBy'],
        ));
      }

      return members;
    } catch (e) {
      print('Error getting group members: $e');
      return [];
    }
  }

  /// Get user's role in a group
  Future<GroupRole?> getUserRole(String groupId, String userId) async {
    try {
      final members = await getGroupMembers(groupId);
      final member = members.firstWhere(
        (m) => m.userId == userId,
        orElse: () => GroupMember(
          userId: '',
          role: GroupRole.member,
          joinedAt: DateTime.now(),
        ),
      );

      return member.userId.isNotEmpty ? member.role : null;
    } catch (e) {
      print('Error getting user role: $e');
      return null;
    }
  }

  /// Promote a member to admin
  Future<bool> promoteToAdmin(
      String groupId, String targetUserId, String actorUserId) async {
    try {
      final policy = await _policyService.getPolicy(groupId);
      final actorRole = await getUserRole(groupId, actorUserId);
      final targetRole = await getUserRole(groupId, targetUserId);

      if (actorRole == null || targetRole == null) return false;

      // Check permissions
      if (!actorRole.canManageRoles()) return false;
      if (targetRole == GroupRole.owner) return false;

      // Check if vote is required
      if (policy.requireVoteForAdmin && actorRole != GroupRole.owner) {
        return await _voteService.openVote(
          groupId: groupId,
          action: VoteAction.promoteAdmin,
          targetUserId: targetUserId,
          createdBy: actorUserId,
          closesAt: DateTime.now().add(policy.voteDuration),
        );
      } else {
        return await _changeRole(
            groupId, targetUserId, GroupRole.admin, actorUserId);
      }
    } catch (e) {
      print('Error promoting to admin: $e');
      return false;
    }
  }

  /// Demote an admin to member
  Future<bool> demoteAdmin(
      String groupId, String targetUserId, String actorUserId) async {
    try {
      final policy = await _policyService.getPolicy(groupId);
      final actorRole = await getUserRole(groupId, actorUserId);
      final targetRole = await getUserRole(groupId, targetUserId);

      if (actorRole == null || targetRole == null) return false;

      // Check permissions
      if (!actorRole.canManageRoles()) return false;
      if (targetRole == GroupRole.owner) return false;

      // Check if vote is required
      if (policy.requireVoteForAdmin && actorRole != GroupRole.owner) {
        return await _voteService.openVote(
          groupId: groupId,
          action: VoteAction.demoteAdmin,
          targetUserId: targetUserId,
          createdBy: actorUserId,
          closesAt: DateTime.now().add(policy.voteDuration),
        );
      } else {
        return await _changeRole(
            groupId, targetUserId, GroupRole.member, actorUserId);
      }
    } catch (e) {
      print('Error demoting admin: $e');
      return false;
    }
  }

  /// Transfer ownership
  Future<bool> transferOwnership(
      String groupId, String targetUserId, String actorUserId) async {
    try {
      final actorRole = await getUserRole(groupId, actorUserId);
      final targetRole = await getUserRole(groupId, targetUserId);

      if (actorRole == null || targetRole == null) return false;

      // Only owner can transfer ownership
      if (actorRole != GroupRole.owner) return false;

      // Always require vote for ownership transfer
      return await _voteService.openVote(
        groupId: groupId,
        action: VoteAction.transferOwnership,
        targetUserId: targetUserId,
        createdBy: actorUserId,
        closesAt: DateTime.now()
            .add(const Duration(hours: 72)), // Longer for ownership
      );
    } catch (e) {
      print('Error transferring ownership: $e');
      return false;
    }
  }

  /// Remove a member from the group
  Future<bool> removeMember(
      String groupId, String targetUserId, String actorUserId) async {
    try {
      final actorRole = await getUserRole(groupId, actorUserId);
      final targetRole = await getUserRole(groupId, targetUserId);

      if (actorRole == null || targetRole == null) return false;

      // Check permissions
      if (!actorRole.canRemoveMembers()) return false;
      if (targetRole == GroupRole.owner) return false;
      if (actorRole == GroupRole.admin && targetRole == GroupRole.admin) {
        return false;
      }

      return await _removeMemberFromGroup(groupId, targetUserId, actorUserId);
    } catch (e) {
      print('Error removing member: $e');
      return false;
    }
  }

  /// Demote an admin to member
  Future<bool> demoteAdmin(
      String groupId, String targetUserId, String actorUserId) async {
    try {
      final policy = await _policyService.getPolicy(groupId);
      final actorRole = await getUserRole(groupId, actorUserId);
      final targetRole = await getUserRole(groupId, targetUserId);

      if (actorRole == null || targetRole == null) return false;

      // Check permissions
      if (!actorRole.canManageRoles()) return false;
      if (targetRole == GroupRole.owner) return false;

      // Check if vote is required
      if (policy.requireVoteForAdmin && actorRole != GroupRole.owner) {
        return await _voteService.openVote(
          groupId: groupId,
          action: VoteAction.demoteAdmin,
          targetUserId: targetUserId,
          createdBy: actorUserId,
          closesAt: DateTime.now().add(policy.voteDuration),
        );
      } else {
        return await _changeRole(
            groupId, targetUserId, GroupRole.member, actorUserId);
      }
    } catch (e) {
      print('Error demoting admin: $e');
      return false;
    }
  }

  /// Transfer ownership
  Future<bool> transferOwnership(
      String groupId, String targetUserId, String actorUserId) async {
    try {
      final actorRole = await getUserRole(groupId, actorUserId);
      final targetRole = await getUserRole(groupId, targetUserId);

      if (actorRole == null || targetRole == null) return false;

      // Only owner can transfer ownership
      if (actorRole != GroupRole.owner) return false;

      // Always require vote for ownership transfer
      return await _voteService.openVote(
        groupId: groupId,
        action: VoteAction.transferOwnership,
        targetUserId: targetUserId,
        createdBy: actorUserId,
        closesAt: DateTime.now()
            .add(const Duration(hours: 72)), // Longer for ownership
      );
    } catch (e) {
      print('Error transferring ownership: $e');
      return false;
    }
  }

  /// Remove a member from the group
  Future<bool> removeMember(
      String groupId, String targetUserId, String actorUserId) async {
    try {
      final actorRole = await getUserRole(groupId, actorUserId);
      final targetRole = await getUserRole(groupId, targetUserId);

      if (actorRole == null || targetRole == null) return false;

      // Check permissions
      if (!actorRole.canRemoveMembers()) return false;
      if (targetRole == GroupRole.owner) return false;
      if (actorRole == GroupRole.admin && targetRole == GroupRole.admin) {
        return false;
      }

      return await _removeMemberFromGroup(groupId, targetUserId, actorUserId);
    } catch (e) {
      print('Error removing member: $e');
      return false;
    }
  }

  /// Change a member's role directly
  Future<bool> _changeRole(String groupId, String userId, GroupRole newRole,
      String actorUserId) async {
    try {
      final batch = _firestore.batch();
      final groupRef = _firestore.collection('user_groups').doc(groupId);

      // Update roles map
      batch.update(groupRef, {
        'roles.$userId.role': newRole.name,
        'roles.$userId.changedAt': Timestamp.fromDate(DateTime.now()),
        'roles.$userId.changedBy': actorUserId,
      });

      // If promoting to admin, ensure they're in members list
      if (newRole == GroupRole.admin) {
        batch.update(groupRef, {
          'members': FieldValue.arrayUnion([userId]),
        });
      }

      await batch.commit();

      // Log audit event
      await _auditService.logEvent(
        groupId: groupId,
        actorUserId: actorUserId,
        type: AuditEventType.roleChanged,
        targetUserId: userId,
        metadata: {
          'oldRole': 'member',
          'newRole': newRole.name,
        },
      );

      return true;
    } catch (e) {
      print('Error changing role: $e');
      return false;
    }
  }

  /// Execute vote result
  Future<bool> executeVoteResult(GroupVote vote) async {
    try {
      if (!vote.hasPassed) return false;

      switch (vote.action) {
        case VoteAction.promoteAdmin:
          return await _changeRole(
              vote.groupId, vote.targetUserId, GroupRole.admin, vote.createdBy);
        case VoteAction.demoteAdmin:
          return await _changeRole(vote.groupId, vote.targetUserId,
              GroupRole.member, vote.createdBy);
        case VoteAction.transferOwnership:
          return await _transferOwnershipDirect(
              vote.groupId, vote.targetUserId, vote.createdBy);
        case VoteAction.removeMember:
          return await _removeMemberFromGroup(
              vote.groupId, vote.targetUserId, vote.createdBy);
        case VoteAction.changePolicy:
          // Handle policy changes
          return true;
      }
    } catch (e) {
      print('Error executing vote result: $e');
      return false;
    }
    return false;
  }

  /// Remove member from group (used by vote service)
  Future<bool> _removeMemberFromGroup(
      String groupId, String userId, String actorUserId) async {
    try {
      final batch = _firestore.batch();
      final groupRef = _firestore.collection('user_groups').doc(groupId);

      // Remove from members list
      batch.update(groupRef, {
        'members': FieldValue.arrayRemove([userId]),
      });

      // Remove from roles map
      batch.update(groupRef, {
        'roles.$userId': FieldValue.delete(),
      });

      await batch.commit();

      // Log audit event
      await _auditService.logEvent(
        groupId: groupId,
        actorUserId: actorUserId,
        type: AuditEventType.memberRemoved,
        targetUserId: userId,
      );

      return true;
    } catch (e) {
      print('Error removing member: $e');
      return false;
    }
  }

  /// Direct ownership transfer (used by vote service)
  Future<bool> _transferOwnershipDirect(
      String groupId, String newOwnerId, String actorUserId) async {
    try {
      final batch = _firestore.batch();
      final groupRef = _firestore.collection('user_groups').doc(groupId);

      // Get current owner
      final groupDoc = await groupRef.get();
      final data = groupDoc.data()!;
      final currentOwnerId = data['ownerId'];

      // Update ownership
      batch.update(groupRef, {
        'ownerId': newOwnerId,
        'roles.$newOwnerId.role': GroupRole.owner.name,
        'roles.$newOwnerId.changedAt': Timestamp.fromDate(DateTime.now()),
        'roles.$newOwnerId.changedBy': actorUserId,
      });

      // Demote old owner to admin
      if (currentOwnerId != null && currentOwnerId != newOwnerId) {
        batch.update(groupRef, {
          'roles.$currentOwnerId.role': GroupRole.admin.name,
          'roles.$currentOwnerId.changedAt': Timestamp.fromDate(DateTime.now()),
          'roles.$currentOwnerId.changedBy': actorUserId,
        });
      }

      await batch.commit();

      // Log audit event
      await _auditService.logEvent(
        groupId: groupId,
        actorUserId: actorUserId,
        type: AuditEventType.roleChanged,
        targetUserId: newOwnerId,
        metadata: {
          'oldRole': 'admin',
          'newRole': 'owner',
        },
      );

      return true;
    } catch (e) {
      print('Error transferring ownership: $e');
      return false;
    }
  }
}
