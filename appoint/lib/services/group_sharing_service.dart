import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import '../models/user_group.dart';
import '../models/group_invite.dart';

class GroupSharingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _random = Random();

  /// יצירת קבוצה חדשה עם קוד הזמנה
  Future<String> createGroupInvite(
    String creatorId, {
    String? groupName,
    String? description,
    int maxUses = -1,
    Duration? expiresIn,
  }) async {
    final groupId = _generateId();
    final groupCode = _generateGroupCode();

    final group = UserGroup(
      id: groupId,
      name: groupName ?? "Group by $creatorId",
      createdBy: creatorId,
      members: [creatorId],
      admins: [creatorId],
      createdAt: DateTime.now(),
      description: description,
    );

    final invite = GroupInvite(
      code: groupCode,
      groupId: groupId,
      createdBy: creatorId,
      usedBy: [],
      createdAt: DateTime.now(),
      maxUses: maxUses,
      expiresAt: expiresIn != null ? DateTime.now().add(expiresIn) : null,
    );

    // Batch write for atomicity
    final batch = _firestore.batch();

    batch.set(
      _firestore.collection('user_groups').doc(groupId),
      group.toMap(),
    );

    batch.set(
      _firestore.collection('group_invites').doc(groupCode),
      invite.toMap(),
    );

    await batch.commit();

    return groupCode;
  }

  /// הצטרפות לקבוצה באמצעות קוד הזמנה
  Future<UserGroup> joinGroupFromCode(String code, String userId) async {
    final inviteDoc =
        await _firestore.collection('group_invites').doc(code).get();

    if (!inviteDoc.exists) {
      throw Exception("Invalid group invite code");
    }

    final invite = GroupInvite.fromMap(inviteDoc.id, inviteDoc.data()!);

    if (!invite.isValid) {
      throw Exception("Invite code is no longer valid");
    }

    final groupRef = _firestore.collection('user_groups').doc(invite.groupId);
    final groupDoc = await groupRef.get();

    if (!groupDoc.exists) {
      throw Exception("Group not found");
    }

    final group = UserGroup.fromMap(groupDoc.id, groupDoc.data()!);

    if (!group.members.contains(userId)) {
      final updatedMembers = List<String>.from(group.members)..add(userId);

      await groupRef.update({'members': updatedMembers});

      // Update invite usage
      final updatedUsedBy = List<String>.from(invite.usedBy)..add(userId);
      await _firestore.collection('group_invites').doc(code).update({
        'usedBy': updatedUsedBy,
      });
    }

    return group.copyWith(
        members: List<String>.from(group.members)..add(userId));
  }

  /// קבלת פרטי קבוצה לפי ID
  Future<UserGroup?> getGroupById(String groupId) async {
    final doc = await _firestore.collection('user_groups').doc(groupId).get();

    if (!doc.exists) return null;

    return UserGroup.fromMap(doc.id, doc.data()!);
  }

  /// קבלת קבוצות של משתמש
  Future<List<UserGroup>> getUserGroups(String userId) async {
    final query = await _firestore
        .collection('user_groups')
        .where('members', arrayContains: userId)
        .where('isActive', isEqualTo: true)
        .get();

    return query.docs
        .map((doc) => UserGroup.fromMap(doc.id, doc.data()))
        .toList();
  }

  /// קבלת הזמנת קבוצה לפי קוד
  Future<GroupInvite?> getGroupInvite(String code) async {
    final doc = await _firestore.collection('group_invites').doc(code).get();

    if (!doc.exists) return null;

    return GroupInvite.fromMap(doc.id, doc.data()!);
  }

  /// יצירת קישור שיתוף לקבוצה
  String createGroupShareLink(String groupCode) {
    return 'https://app-oint.com/group-invite/$groupCode';
  }

  /// עדכון פרטי קבוצה
  Future<void> updateGroup(String groupId, Map<String, dynamic> updates) async {
    await _firestore.collection('user_groups').doc(groupId).update(updates);
  }

  /// הוספת מנהל לקבוצה
  Future<void> addGroupAdmin(String groupId, String userId) async {
    final groupRef = _firestore.collection('user_groups').doc(groupId);
    final group = await getGroupById(groupId);

    if (group == null) throw Exception("Group not found");

    if (!group.admins.contains(userId)) {
      final updatedAdmins = List<String>.from(group.admins)..add(userId);
      await groupRef.update({'admins': updatedAdmins});
    }
  }

  /// הסרת מנהל מהקבוצה
  Future<void> removeGroupAdmin(String groupId, String userId) async {
    final groupRef = _firestore.collection('user_groups').doc(groupId);
    final group = await getGroupById(groupId);

    if (group == null) throw Exception("Group not found");

    if (group.admins.contains(userId) && group.admins.length > 1) {
      final updatedAdmins = List<String>.from(group.admins)..remove(userId);
      await groupRef.update({'admins': updatedAdmins});
    }
  }

  /// יציאה מקבוצה
  Future<void> leaveGroup(String groupId, String userId) async {
    final groupRef = _firestore.collection('user_groups').doc(groupId);
    final group = await getGroupById(groupId);

    if (group == null) throw Exception("Group not found");

    if (group.members.contains(userId)) {
      final updatedMembers = List<String>.from(group.members)..remove(userId);
      final updatedAdmins = List<String>.from(group.admins)..remove(userId);

      await groupRef.update({
        'members': updatedMembers,
        'admins': updatedAdmins,
      });
    }
  }

  /// מחיקת קבוצה (רק למנהלים)
  Future<void> deleteGroup(String groupId, String userId) async {
    final group = await getGroupById(groupId);

    if (group == null) throw Exception("Group not found");

    if (!group.admins.contains(userId)) {
      throw Exception("Only admins can delete groups");
    }

    final batch = _firestore.batch();

    // Delete group
    batch.delete(_firestore.collection('user_groups').doc(groupId));

    // Delete related invites
    final invitesQuery = await _firestore
        .collection('group_invites')
        .where('groupId', isEqualTo: groupId)
        .get();

    for (final doc in invitesQuery.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  /// יצירת ID ייחודי
  String _generateId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return String.fromCharCodes(Iterable.generate(
        32, (_) => chars.codeUnitAt(_random.nextInt(chars.length))));
  }

  /// יצירת קוד קבוצה ייחודי
  String _generateGroupCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return String.fromCharCodes(Iterable.generate(
        6, (_) => chars.codeUnitAt(_random.nextInt(chars.length))));
  }

  /// בדיקה אם משתמש הוא מנהל בקבוצה
  Future<bool> isUserGroupAdmin(String groupId, String userId) async {
    final group = await getGroupById(groupId);
    return group?.admins.contains(userId) ?? false;
  }

  /// בדיקה אם משתמש הוא חבר בקבוצה
  Future<bool> isUserGroupMember(String groupId, String userId) async {
    final group = await getGroupById(groupId);
    return group?.members.contains(userId) ?? false;
  }
}
