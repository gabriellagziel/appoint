import 'package:cloud_firestore/cloud_firestore.dart';
import 'group_sharing_service.dart';
import 'group_permission_service.dart';

class GroupSecurityService {
  final GroupSharingService _groupSharingService = GroupSharingService();
  final GroupPermissionService _permissionService = GroupPermissionService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// בדיקת אבטחה לפני פעולה
  Future<bool> validateAction(String groupId, String userId, String action) async {
    final group = await _groupSharingService.getGroupById(groupId);
    if (group == null) return false;

    // Check if user is banned
    if (await _isUserBanned(groupId, userId)) {
      return false;
    }

    // Check rate limiting
    if (await _isRateLimited(userId, action)) {
      return false;
    }

    // Check suspicious activity
    if (await _isSuspiciousActivity(userId, groupId)) {
      return false;
    }

    return true;
  }

  /// בדיקה אם משתמש חסום
  Future<bool> _isUserBanned(String groupId, String userId) async {
    final banDoc = await _firestore
        .collection('group_bans')
        .doc('${groupId}_$userId')
        .get();

    if (!banDoc.exists) return false;

    final banData = banDoc.data();
    if (banData == null) return false;

    final banUntil = (banData['banUntil'] as Timestamp).toDate();
    return DateTime.now().isBefore(banUntil);
  }

  /// בדיקת הגבלת קצב
  Future<bool> _isRateLimited(String userId, String action) async {
    final now = DateTime.now();
    final windowStart = now.subtract(const Duration(minutes: 5));

    final query = await _firestore
        .collection('user_actions')
        .where('userId', isEqualTo: userId)
        .where('action', isEqualTo: action)
        .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(windowStart))
        .get();

    // Limit based on action type
    int maxActions;
    switch (action) {
      case 'join_group':
        maxActions = 10;
        break;
      case 'create_invite':
        maxActions = 5;
        break;
      case 'leave_group':
        maxActions = 20;
        break;
      default:
        maxActions = 50;
    }

    return query.docs.length >= maxActions;
  }

  /// בדיקת פעילות חשודה
  Future<bool> _isSuspiciousActivity(String userId, String groupId) async {
    final now = DateTime.now();
    final windowStart = now.subtract(const Duration(hours: 1));

    final query = await _firestore
        .collection('user_actions')
        .where('userId', isEqualTo: userId)
        .where('groupId', isEqualTo: groupId)
        .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(windowStart))
        .get();

    // If user performed more than 50 actions in the last hour, it's suspicious
    return query.docs.length > 50;
  }

  /// רישום פעולת משתמש
  Future<void> logUserAction(String userId, String action, {
    String? groupId,
    Map<String, dynamic>? metadata,
  }) async {
    await _firestore.collection('user_actions').add({
      'userId': userId,
      'action': action,
      'groupId': groupId,
      'metadata': metadata ?? {},
      'timestamp': Timestamp.now(),
      'ipAddress': 'unknown', // Would be set by backend
      'userAgent': 'unknown', // Would be set by backend
    });
  }

  /// חסימת משתמש מקבוצה
  Future<void> banUser(String groupId, String userId, String reason, {
    Duration? duration,
    String? bannedBy,
  }) async {
    final banUntil = DateTime.now().add(duration ?? const Duration(days: 7));

    await _firestore.collection('group_bans').doc('${groupId}_$userId').set({
      'groupId': groupId,
      'userId': userId,
      'reason': reason,
      'bannedBy': bannedBy,
      'bannedAt': Timestamp.now(),
      'banUntil': Timestamp.fromDate(banUntil),
    });

    // Log the ban action
    await logUserAction(bannedBy ?? 'system', 'ban_user',
      groupId: groupId,
      metadata: {
        'bannedUserId': userId,
        'reason': reason,
        'duration': duration?.inDays,
      },
    );
  }

  /// הסרת חסימה של משתמש
  Future<void> unbanUser(String groupId, String userId, String? unbannedBy) async {
    await _firestore.collection('group_bans').doc('${groupId}_$userId').delete();

    // Log the unban action
    await logUserAction(unbannedBy ?? 'system', 'unban_user',
      groupId: groupId,
      metadata: {
        'unbannedUserId': userId,
      },
    );
  }

  /// קבלת רשימת משתמשים חסומים
  Future<List<Map<String, dynamic>>> getBannedUsers(String groupId) async {
    final query = await _firestore
        .collection('group_bans')
        .where('groupId', isEqualTo: groupId)
        .get();

    return query.docs.map((doc) {
      final data = doc.data();
      return {
        'userId': data['userId'],
        'reason': data['reason'],
        'bannedBy': data['bannedBy'],
        'bannedAt': (data['bannedAt'] as Timestamp).toDate(),
        'banUntil': (data['banUntil'] as Timestamp).toDate(),
      };
    }).toList();
  }

  /// קבלת היסטוריית פעולות של משתמש
  Future<List<Map<String, dynamic>>> getUserActionHistory(String userId, {
    String? groupId,
    int limit = 100,
  }) async {
    Query query = _firestore
        .collection('user_actions')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .limit(limit);

    if (groupId != null) {
      query = query.where('groupId', isEqualTo: groupId);
    }

    final querySnapshot = await query.get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        'id': doc.id,
        'action': data['action'],
        'groupId': data['groupId'],
        'metadata': data['metadata'] ?? {},
        'timestamp': (data['timestamp'] as Timestamp).toDate(),
      };
    }).toList();
  }

  /// קבלת סטטיסטיקות אבטחה
  Future<Map<String, dynamic>> getSecurityStats(String groupId) async {
    final bannedUsers = await getBannedUsers(groupId);
    final now = DateTime.now();
    final windowStart = now.subtract(const Duration(days: 7));

    final actionsQuery = await _firestore
        .collection('user_actions')
        .where('groupId', isEqualTo: groupId)
        .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(windowStart))
        .get();

    final suspiciousActions = actionsQuery.docs.where((doc) {
      final data = doc.data();
      final action = data['action'] as String?;
      return action == 'suspicious_activity' || action == 'rate_limited';
    }).length;

    return {
      'bannedUsers': bannedUsers.length,
      'activeBans': bannedUsers.where((ban) => ban['banUntil'].isAfter(now)).length,
      'recentActions': actionsQuery.docs.length,
      'suspiciousActions': suspiciousActions,
    };
  }

  /// בדיקת תקינות הזמנה
  Future<bool> validateInvite(String inviteCode) async {
    final invite = await _groupSharingService.getGroupInvite(inviteCode);
    if (invite == null) return false;

    // Check if invite is valid
    if (!invite.isValid) return false;

    // Check if group still exists and is active
    final group = await _groupSharingService.getGroupById(invite.groupId);
    if (group == null || !group.isActive) return false;

    return true;
  }

  /// בדיקת הרשאות מתקדמת
  Future<bool> checkAdvancedPermissions(String groupId, String userId, String action) async {
    // First check basic permissions
    if (!await validateAction(groupId, userId, action)) {
      return false;
    }

    // Check specific permissions based on action
    switch (action) {
      case 'edit_group':
        return await _permissionService.canEditGroup(groupId, userId);
      case 'manage_members':
        return await _permissionService.canManageMembers(groupId, userId);
      case 'manage_admins':
        return await _permissionService.canManageAdmins(groupId, userId);
      case 'delete_group':
        return await _permissionService.canDeleteGroup(groupId, userId);
      case 'create_invite':
        return await _permissionService.canInviteToGroup(groupId, userId);
      default:
        return true;
    }
  }
}

