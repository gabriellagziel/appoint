import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_group.dart';
import '../models/group_invite.dart';
import 'group_sharing_service.dart';
import 'group_permission_service.dart';

class GroupMembershipService {
  final GroupSharingService _groupSharingService = GroupSharingService();
  final GroupPermissionService _permissionService = GroupPermissionService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// הצטרפות לקבוצה באמצעות קוד הזמנה
  Future<UserGroup> joinGroup(String inviteCode, String userId) async {
    try {
      final group =
          await _groupSharingService.joinGroupFromCode(inviteCode, userId);

      // Log membership action
      await _logMembershipAction(
        groupId: group.id,
        userId: userId,
        action: 'joined',
        performedBy: userId,
      );

      return group;
    } catch (e) {
      throw Exception('Failed to join group: $e');
    }
  }

  /// יציאה מקבוצה
  Future<void> leaveGroup(String groupId, String userId) async {
    try {
      await _groupSharingService.leaveGroup(groupId, userId);

      // Log membership action
      await _logMembershipAction(
        groupId: groupId,
        userId: userId,
        action: 'left',
        performedBy: userId,
      );
    } catch (e) {
      throw Exception('Failed to leave group: $e');
    }
  }

  /// הוספת חברים לקבוצה (רק למנהלים)
  Future<void> addMembers(
      String groupId, List<String> userIds, String performedBy) async {
    if (!await _permissionService.canManageMembers(groupId, performedBy)) {
      throw Exception('Insufficient permissions to add members');
    }

    try {
      await _groupSharingService.addGroupMembers(groupId, userIds);

      // Log membership actions
      for (final userId in userIds) {
        await _logMembershipAction(
          groupId: groupId,
          userId: userId,
          action: 'added',
          performedBy: performedBy,
        );
      }
    } catch (e) {
      throw Exception('Failed to add members: $e');
    }
  }

  /// הסרת חברים מהקבוצה (רק למנהלים)
  Future<void> removeMembers(
      String groupId, List<String> userIds, String performedBy) async {
    if (!await _permissionService.canManageMembers(groupId, performedBy)) {
      throw Exception('Insufficient permissions to remove members');
    }

    try {
      await _groupSharingService.removeGroupMembers(groupId, userIds);

      // Log membership actions
      for (final userId in userIds) {
        await _logMembershipAction(
          groupId: groupId,
          userId: userId,
          action: 'removed',
          performedBy: performedBy,
        );
      }
    } catch (e) {
      throw Exception('Failed to remove members: $e');
    }
  }

  /// הוספת מנהל לקבוצה (רק ליוצר)
  Future<void> addAdmin(
      String groupId, String userId, String performedBy) async {
    if (!await _permissionService.canManageAdmins(groupId, performedBy)) {
      throw Exception('Insufficient permissions to add admin');
    }

    try {
      await _groupSharingService.addGroupAdmin(groupId, userId);

      // Log membership action
      await _logMembershipAction(
        groupId: groupId,
        userId: userId,
        action: 'admin_added',
        performedBy: performedBy,
      );
    } catch (e) {
      throw Exception('Failed to add admin: $e');
    }
  }

  /// הסרת מנהל מהקבוצה (רק ליוצר)
  Future<void> removeAdmin(
      String groupId, String userId, String performedBy) async {
    if (!await _permissionService.canManageAdmins(groupId, performedBy)) {
      throw Exception('Insufficient permissions to remove admin');
    }

    try {
      await _groupSharingService.removeGroupAdmin(groupId, userId);

      // Log membership action
      await _logMembershipAction(
        groupId: groupId,
        userId: userId,
        action: 'admin_removed',
        performedBy: performedBy,
      );
    } catch (e) {
      throw Exception('Failed to remove admin: $e');
    }
  }

  /// קבלת היסטוריית חברות בקבוצה
  Future<List<Map<String, dynamic>>> getMembershipHistory(
      String groupId) async {
    final query = await _firestore
        .collection('group_membership_history')
        .where('groupId', isEqualTo: groupId)
        .orderBy('timestamp', descending: true)
        .limit(100)
        .get();

    return query.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'groupId': data['groupId'],
        'userId': data['userId'],
        'action': data['action'],
        'timestamp': (data['timestamp'] as Timestamp).toDate(),
        'performedBy': data['performedBy'],
      };
    }).toList();
  }

  /// קבלת היסטוריית חברות של משתמש
  Future<List<Map<String, dynamic>>> getUserMembershipHistory(
      String userId) async {
    final query = await _firestore
        .collection('group_membership_history')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .limit(50)
        .get();

    return query.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'groupId': data['groupId'],
        'userId': data['userId'],
        'action': data['action'],
        'timestamp': (data['timestamp'] as Timestamp).toDate(),
        'performedBy': data['performedBy'],
      };
    }).toList();
  }

  /// קבלת סטטיסטיקות חברות
  Future<Map<String, dynamic>> getMembershipStats(String groupId) async {
    final group = await _groupSharingService.getGroupById(groupId);
    if (group == null) return {};

    final history = await getMembershipHistory(groupId);

    final stats = <String, dynamic>{
      'totalMembers': group.memberCount,
      'totalAdmins': group.adminCount,
      'totalActions': history.length,
      'recentJoins': history.where((h) => h['action'] == 'joined').length,
      'recentLeaves': history.where((h) => h['action'] == 'left').length,
      'recentAdminChanges':
          history.where((h) => h['action'].toString().contains('admin')).length,
    };

    return stats;
  }

  /// בדיקה אם משתמש חבר בקבוצה
  Future<bool> isUserMember(String groupId, String userId) async {
    return await _groupSharingService.isUserGroupMember(groupId, userId);
  }

  /// בדיקה אם משתמש מנהל בקבוצה
  Future<bool> isUserAdmin(String groupId, String userId) async {
    return await _groupSharingService.isUserGroupAdmin(groupId, userId);
  }

  /// קבלת כל הקבוצות של משתמש
  Future<List<UserGroup>> getUserGroups(String userId) async {
    return await _groupSharingService.getUserGroups(userId);
  }

  /// קבלת קבוצות שהמשתמש מנהל
  Future<List<UserGroup>> getUserAdminGroups(String userId) async {
    final groups = await getUserGroups(userId);
    return groups.where((group) => group.admins.contains(userId)).toList();
  }

  /// רישום פעולת חברות
  Future<void> _logMembershipAction({
    required String groupId,
    required String userId,
    required String action,
    required String performedBy,
  }) async {
    await _firestore.collection('group_membership_history').add({
      'groupId': groupId,
      'userId': userId,
      'action': action,
      'timestamp': Timestamp.now(),
      'performedBy': performedBy,
    });
  }
}
