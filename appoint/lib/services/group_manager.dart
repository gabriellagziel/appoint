import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_group.dart';
import '../models/group_invite.dart';
import 'group_sharing_service.dart';

class GroupManager {
  final GroupSharingService _groupSharingService = GroupSharingService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// יצירת קבוצה חדשה עם הגדרות מתקדמות
  Future<UserGroup> createGroup({
    required String creatorId,
    required String name,
    String? description,
    String? imageUrl,
    List<String>? initialMembers,
    List<String>? initialAdmins,
    int maxInviteUses = -1,
    Duration? inviteExpiresIn,
  }) async {
    final groupCode = await _groupSharingService.createGroupInvite(
      creatorId,
      groupName: name,
      description: description,
      maxUses: maxInviteUses,
      expiresIn: inviteExpiresIn,
    );

    // Update group with additional data
    final group = await _groupSharingService.getGroupById(groupCode);
    if (group == null) throw Exception("Failed to create group");

    final updates = <String, dynamic>{};
    if (imageUrl != null) updates['imageUrl'] = imageUrl;
    if (initialMembers != null) {
      final allMembers = List<String>.from(group.members)
        ..addAll(initialMembers);
      updates['members'] = allMembers;
    }
    if (initialAdmins != null) {
      final allAdmins = List<String>.from(group.admins)..addAll(initialAdmins);
      updates['admins'] = allAdmins;
    }

    if (updates.isNotEmpty) {
      await _groupSharingService.updateGroup(group.id, updates);
    }

    List<String> updatedMembers = group.members;
    List<String> updatedAdmins = group.admins;

    if (initialMembers != null) {
      updatedMembers = List<String>.from(group.members)..addAll(initialMembers);
    }
    if (initialAdmins != null) {
      updatedAdmins = List<String>.from(group.admins)..addAll(initialAdmins);
    }

    return group.copyWith(
      imageUrl: imageUrl,
      members: updatedMembers,
      admins: updatedAdmins,
    );
  }

  /// קבלת כל הקבוצות של משתמש עם פרטים מלאים
  Future<List<UserGroup>> getUserGroupsWithDetails(String userId) async {
    final groups = await _groupSharingService.getUserGroups(userId);

    // Add additional details like member count, admin status, etc.
    return groups.map((group) => group).toList();
  }

  /// קבלת קבוצות שהמשתמש מנהל
  Future<List<UserGroup>> getUserAdminGroups(String userId) async {
    final groups = await _groupSharingService.getUserGroups(userId);
    return groups.where((group) => group.admins.contains(userId)).toList();
  }

  /// קבלת פרטי קבוצה עם רשימת חברים מלאה
  Future<Map<String, dynamic>?> getGroupDetails(String groupId) async {
    final group = await _groupSharingService.getGroupById(groupId);
    if (group == null) return null;

    // Get user details for members and admins
    final memberDetails = await _getUserDetails(group.members);
    final adminDetails = await _getUserDetails(group.admins);

    return {
      'group': group,
      'members': memberDetails,
      'admins': adminDetails,
      'memberCount': group.memberCount,
      'adminCount': group.adminCount,
    };
  }

  /// עדכון פרטי קבוצה
  Future<void> updateGroupDetails(
    String groupId, {
    String? name,
    String? description,
    String? imageUrl,
  }) async {
    final updates = <String, dynamic>{};
    if (name != null) updates['name'] = name;
    if (description != null) updates['description'] = description;
    if (imageUrl != null) updates['imageUrl'] = imageUrl;

    await _groupSharingService.updateGroup(groupId, updates);
  }

  /// הוספת חברים לקבוצה
  Future<void> addGroupMembers(String groupId, List<String> userIds) async {
    final group = await _groupSharingService.getGroupById(groupId);
    if (group == null) throw Exception("Group not found");

    final updatedMembers = List<String>.from(group.members)..addAll(userIds);
    await _groupSharingService
        .updateGroup(groupId, {'members': updatedMembers});
  }

  /// הסרת חברים מהקבוצה
  Future<void> removeGroupMembers(String groupId, List<String> userIds) async {
    final group = await _groupSharingService.getGroupById(groupId);
    if (group == null) throw Exception("Group not found");

    final updatedMembers = List<String>.from(group.members)
      ..removeWhere((id) => userIds.contains(id));
    await _groupSharingService
        .updateGroup(groupId, {'members': updatedMembers});
  }

  /// יצירת הזמנה חדשה לקבוצה קיימת
  Future<String> createNewGroupInvite(
    String groupId,
    String creatorId, {
    int maxUses = -1,
    Duration? expiresIn,
  }) async {
    final group = await _groupSharingService.getGroupById(groupId);
    if (group == null) throw Exception("Group not found");

    if (!group.admins.contains(creatorId)) {
      throw Exception("Only admins can create invites");
    }

    final inviteCode = _generateGroupCode();
    final invite = GroupInvite(
      code: inviteCode,
      groupId: groupId,
      createdBy: creatorId,
      usedBy: [],
      createdAt: DateTime.now(),
      maxUses: maxUses,
      expiresAt: expiresIn != null ? DateTime.now().add(expiresIn) : null,
    );

    await _firestore
        .collection('group_invites')
        .doc(inviteCode)
        .set(invite.toMap());
    return inviteCode;
  }

  /// קבלת כל ההזמנות הפעילות לקבוצה
  Future<List<GroupInvite>> getActiveGroupInvites(String groupId) async {
    final query = await _firestore
        .collection('group_invites')
        .where('groupId', isEqualTo: groupId)
        .where('isActive', isEqualTo: true)
        .get();

    return query.docs
        .map((doc) => GroupInvite.fromMap(doc.id, doc.data()))
        .where((invite) => invite.isValid)
        .toList();
  }

  /// ביטול הזמנה
  Future<void> cancelGroupInvite(String inviteCode, String userId) async {
    final invite = await _groupSharingService.getGroupInvite(inviteCode);
    if (invite == null) throw Exception("Invite not found");

    final group = await _groupSharingService.getGroupById(invite.groupId);
    if (group == null) throw Exception("Group not found");

    if (!group.admins.contains(userId)) {
      throw Exception("Only admins can cancel invites");
    }

    await _firestore.collection('group_invites').doc(inviteCode).update({
      'isActive': false,
    });
  }

  /// קבלת סטטיסטיקות קבוצה
  Future<Map<String, dynamic>> getGroupStats(String groupId) async {
    final group = await _groupSharingService.getGroupById(groupId);
    if (group == null) throw Exception("Group not found");

    final invites = await getActiveGroupInvites(groupId);
    final totalInviteUses =
        invites.fold<int>(0, (sum, invite) => sum + invite.usedBy.length);

    return {
      'memberCount': group.memberCount,
      'adminCount': group.adminCount,
      'activeInvites': invites.length,
      'totalInviteUses': totalInviteUses,
      'createdAt': group.createdAt,
      'isActive': group.isActive,
    };
  }

  /// ארכוב קבוצה (במקום מחיקה)
  Future<void> archiveGroup(String groupId, String userId) async {
    final group = await _groupSharingService.getGroupById(groupId);
    if (group == null) throw Exception("Group not found");

    if (!group.admins.contains(userId)) {
      throw Exception("Only admins can archive groups");
    }

    await _groupSharingService.updateGroup(groupId, {'isActive': false});
  }

  /// שחזור קבוצה מארכיון
  Future<void> restoreGroup(String groupId, String userId) async {
    final group = await _groupSharingService.getGroupById(groupId);
    if (group == null) throw Exception("Group not found");

    if (!group.admins.contains(userId)) {
      throw Exception("Only admins can restore groups");
    }

    await _groupSharingService.updateGroup(groupId, {'isActive': true});
  }

  /// קבלת פרטי משתמשים
  Future<List<Map<String, dynamic>>> _getUserDetails(
      List<String> userIds) async {
    if (userIds.isEmpty) return [];

    final usersQuery = await _firestore
        .collection('users')
        .where(FieldPath.documentId, whereIn: userIds)
        .get();

    return usersQuery.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'name': data['name'] ?? 'Unknown User',
        'email': data['email'] ?? '',
        'photoUrl': data['photoUrl'],
      };
    }).toList();
  }

  /// יצירת קוד קבוצה ייחודי
  String _generateGroupCode() {
    const chars = 'REDACTED_TOKEN';
    return String.fromCharCodes(Iterable.generate(
        6,
        (_) => chars
            .codeUnitAt(DateTime.now().millisecondsSinceEpoch % chars.length)));
  }
}
