import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appoint/models/group_role.dart';

class GroupAdminService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get all members of a group
  Future<List<GroupMember>> getGroupMembers(String groupId) async {
    try {
      final membersDoc = await _firestore
          .collection('groups')
          .doc(groupId)
          .collection('members')
          .get();

      return membersDoc.docs.map((doc) {
        return GroupMember.fromMap(doc.id, doc.data());
      }).toList();
    } catch (e) {
      throw Exception('Failed to get group members: $e');
    }
  }

  /// Get user role in a group
  Future<GroupRole?> getUserRole(String groupId, String userId) async {
    try {
      final memberDoc = await _firestore
          .collection('groups')
          .doc(groupId)
          .collection('members')
          .doc(userId)
          .get();

      if (!memberDoc.exists) return null;

      return GroupMember.fromMap(userId, memberDoc.data()!).role;
    } catch (e) {
      throw Exception('Failed to get user role: $e');
    }
  }

  /// Promote a member to admin
  Future<void> promoteToAdmin(String groupId, String userId) async {
    try {
      await _firestore
          .collection('groups')
          .doc(groupId)
          .collection('members')
          .doc(userId)
          .update({
        'role': GroupRole.admin.name,
      });
    } catch (e) {
      throw Exception('Failed to promote user to admin: $e');
    }
  }

  /// Demote an admin to member
  Future<void> demoteAdmin(String groupId, String userId) async {
    try {
      await _firestore
          .collection('groups')
          .doc(groupId)
          .collection('members')
          .doc(userId)
          .update({
        'role': GroupRole.member.name,
      });
    } catch (e) {
      throw Exception('Failed to demote admin: $e');
    }
  }

  /// Transfer group ownership
  Future<void> transferOwnership(String groupId, String userId) async {
    try {
      final batch = _firestore.batch();

      // Update the new owner's role
      batch.update(
        _firestore
            .collection('groups')
            .doc(groupId)
            .collection('members')
            .doc(userId),
        {'role': GroupRole.owner.name},
      );

      // Update the current owner's role to admin
      final currentOwner = await _getCurrentOwner(groupId);
      if (currentOwner != null && currentOwner != userId) {
        batch.update(
          _firestore
              .collection('groups')
              .doc(groupId)
              .collection('members')
              .doc(currentOwner),
          {'role': GroupRole.admin.name},
        );
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to transfer ownership: $e');
    }
  }

  /// Remove a member from the group
  Future<void> removeMember(String groupId, String userId) async {
    try {
      await _firestore
          .collection('groups')
          .doc(groupId)
          .collection('members')
          .doc(userId)
          .delete();
    } catch (e) {
      throw Exception('Failed to remove member: $e');
    }
  }

  /// Get current owner of the group
  Future<String?> _getCurrentOwner(String groupId) async {
    try {
      final members = await getGroupMembers(groupId);
      final owner = members.firstWhere(
        (member) => member.role == GroupRole.owner,
        orElse: () => throw Exception('No owner found'),
      );
      return owner.userId;
    } catch (e) {
      return null;
    }
  }
}
