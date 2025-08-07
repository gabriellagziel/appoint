import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_group.dart';
import 'group_sharing_service.dart';

enum GroupPermission {
  view,
  edit,
  invite,
  manageMembers,
  manageAdmins,
  delete,
}

class GroupPermissionService {
  final GroupSharingService _groupSharingService = GroupSharingService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// בדיקה אם למשתמש יש הרשאה מסוימת בקבוצה
  Future<bool> hasPermission(String groupId, String userId, GroupPermission permission) async {
    final group = await _groupSharingService.getGroupById(groupId);
    if (group == null) return false;

    // Creator has all permissions
    if (group.createdBy == userId) return true;

    // Admins have most permissions
    if (group.admins.contains(userId)) {
      switch (permission) {
        case GroupPermission.view:
        case GroupPermission.edit:
        case GroupPermission.invite:
        case GroupPermission.manageMembers:
          return true;
        case GroupPermission.manageAdmins:
        case GroupPermission.delete:
          return false; // Only creator can manage admins and delete
      }
    }

    // Members have limited permissions
    if (group.members.contains(userId)) {
      switch (permission) {
        case GroupPermission.view:
          return true;
        case GroupPermission.edit:
        case GroupPermission.invite:
        case GroupPermission.manageMembers:
        case GroupPermission.manageAdmins:
        case GroupPermission.delete:
          return false;
      }
    }

    return false;
  }

  /// קבלת כל ההרשאות של משתמש בקבוצה
  Future<List<GroupPermission>> getUserPermissions(String groupId, String userId) async {
    final permissions = <GroupPermission>[];
    
    for (final permission in GroupPermission.values) {
      if (await hasPermission(groupId, userId, permission)) {
        permissions.add(permission);
      }
    }
    
    return permissions;
  }

  /// בדיקה אם משתמש יכול לערוך קבוצה
  Future<bool> canEditGroup(String groupId, String userId) async {
    return await hasPermission(groupId, userId, GroupPermission.edit);
  }

  /// בדיקה אם משתמש יכול להזמין אנשים לקבוצה
  Future<bool> canInviteToGroup(String groupId, String userId) async {
    return await hasPermission(groupId, userId, GroupPermission.invite);
  }

  /// בדיקה אם משתמש יכול לנהל חברים
  Future<bool> canManageMembers(String groupId, String userId) async {
    return await hasPermission(groupId, userId, GroupPermission.manageMembers);
  }

  /// בדיקה אם משתמש יכול לנהל מנהלים
  Future<bool> canManageAdmins(String groupId, String userId) async {
    return await hasPermission(groupId, userId, GroupPermission.manageAdmins);
  }

  /// בדיקה אם משתמש יכול למחוק קבוצה
  Future<bool> canDeleteGroup(String groupId, String userId) async {
    return await hasPermission(groupId, userId, GroupPermission.delete);
  }

  /// קבלת רשימת משתמשים עם הרשאות מסוימות
  Future<List<String>> getUsersWithPermission(String groupId, GroupPermission permission) async {
    final group = await _groupSharingService.getGroupById(groupId);
    if (group == null) return [];

    final usersWithPermission = <String>[];

    for (final userId in group.members) {
      if (await hasPermission(groupId, userId, permission)) {
        usersWithPermission.add(userId);
      }
    }

    return usersWithPermission;
  }

  /// קבלת סטטיסטיקות הרשאות לקבוצה
  Future<Map<String, dynamic>> getGroupPermissionStats(String groupId) async {
    final group = await _groupSharingService.getGroupById(groupId);
    if (group == null) return {};

    final stats = <String, dynamic>{};
    
    for (final permission in GroupPermission.values) {
      final usersWithPermission = await getUsersWithPermission(groupId, permission);
      stats[permission.name] = usersWithPermission.length;
    }

    stats['totalMembers'] = group.memberCount;
    stats['totalAdmins'] = group.adminCount;
    stats['creator'] = group.createdBy;

    return stats;
  }

  /// קבלת היסטוריית הרשאות (אם נדרש בעתיד)
  Future<List<Map<String, dynamic>>> getPermissionHistory(String groupId) async {
    final query = await _firestore
        .collection('group_permission_history')
        .where('groupId', isEqualTo: groupId)
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
        'permission': data['permission'],
        'timestamp': (data['timestamp'] as Timestamp).toDate(),
        'performedBy': data['performedBy'],
      };
    }).toList();
  }

  /// רישום פעולת הרשאה (לאבטחה)
  Future<void> logPermissionAction({
    required String groupId,
    required String userId,
    required String action,
    required GroupPermission permission,
    required String performedBy,
  }) async {
    await _firestore.collection('group_permission_history').add({
      'groupId': groupId,
      'userId': userId,
      'action': action,
      'permission': permission.name,
      'timestamp': Timestamp.now(),
      'performedBy': performedBy,
    });
  }
}

