import 'package:cloud_firestore/cloud_firestore.dart';
import 'group_sharing_service.dart';
import 'group_permission_service.dart';

Map<String, dynamic> _asMap(Object? v) =>
    v is Map ? v.cast<String, dynamic>() : <String, dynamic>{};

DateTime? _asDate(Object? v) {
  if (v == null) return null;
  if (v is DateTime) return v;
  try {
    // Firestore Timestamp has toDate()
    final dynamic d = v;
    return d.toDate() as DateTime;
  } catch (_) {}
  if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
  return null;
}

enum GroupNotificationType {
  memberJoined,
  memberLeft,
  adminAdded,
  adminRemoved,
  inviteCreated,
  inviteCancelled,
  groupUpdated,
  groupDeleted,
}

class GroupNotificationService {
  final GroupSharingService _groupSharingService = GroupSharingService();
  final GroupPermissionService _permissionService = GroupPermissionService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// שליחת התראה לכל חברי הקבוצה
  Future<void> notifyGroupMembers(
    String groupId,
    GroupNotificationType type, {
    required String title,
    required String message,
    Map<String, dynamic>? data,
    String? performedBy,
  }) async {
    final group = await _groupSharingService.getGroupById(groupId);
    if (group == null) return;

    final notification = {
      'groupId': groupId,
      'type': type.name,
      'title': title,
      'message': message,
      'data': data ?? {},
      'performedBy': performedBy,
      'timestamp': Timestamp.now(),
      'isRead': false,
    };

    // Send to all group members
    for (final memberId in group.members) {
      await _firestore
          .collection('users')
          .doc(memberId)
          .collection('notifications')
          .add(notification);
    }
  }

  /// שליחת התראה למנהלי הקבוצה
  Future<void> notifyGroupAdmins(
    String groupId,
    GroupNotificationType type, {
    required String title,
    required String message,
    Map<String, dynamic>? data,
    String? performedBy,
  }) async {
    final group = await _groupSharingService.getGroupById(groupId);
    if (group == null) return;

    final notification = {
      'groupId': groupId,
      'type': type.name,
      'title': title,
      'message': message,
      'data': data ?? {},
      'performedBy': performedBy,
      'timestamp': Timestamp.now(),
      'isRead': false,
    };

    // Send to all group admins
    for (final adminId in group.admins) {
      await _firestore
          .collection('users')
          .doc(adminId)
          .collection('notifications')
          .add(notification);
    }
  }

  /// שליחת התראה למשתמש ספציפי
  Future<void> notifyUser(
    String userId,
    GroupNotificationType type, {
    required String title,
    required String message,
    Map<String, dynamic>? data,
    String? performedBy,
  }) async {
    final notification = {
      'type': type.name,
      'title': title,
      'message': message,
      'data': data ?? {},
      'performedBy': performedBy,
      'timestamp': Timestamp.now(),
      'isRead': false,
    };

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .add(notification);
  }

  /// קבלת התראות של משתמש
  Future<List<Map<String, dynamic>>> getUserNotifications(
    String userId, {
    bool? isRead,
    int limit = 50,
  }) async {
    Query query = _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .limit(limit);

    if (isRead != null) {
      query = query.where('isRead', isEqualTo: isRead);
    }

    final querySnapshot = await query.get();

    return querySnapshot.docs.map((doc) {
      final Map<String, dynamic> data =
          Map<String, dynamic>.from(doc.data() as Map<String, dynamic>);
      return {
        'id': doc.id,
        'type': (data['type'] as String?) ?? 'unknown',
        'title': (data['title'] as String?) ?? '',
        'message': (data['message'] as String?) ?? '',
        'data': _asMap(data['data']),
        'performedBy': data['performedBy'],
        'timestamp': _asDate(data['timestamp']),
        'isRead': data['isRead'] ?? false,
        'groupId': data['groupId'],
      };
    }).toList();
  }

  /// סימון התראה כנקראה
  Future<void> markNotificationAsRead(
      String userId, String notificationId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .doc(notificationId)
        .update({'isRead': true});
  }

  /// סימון כל ההתראות כנקראו
  Future<void> markAllNotificationsAsRead(String userId) async {
    final batch = _firestore.batch();
    final notifications = await _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .where('isRead', isEqualTo: false)
        .get();

    for (final doc in notifications.docs) {
      batch.update(doc.reference, {'isRead': true});
    }

    await batch.commit();
  }

  /// מחיקת התראה
  Future<void> deleteNotification(String userId, String notificationId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .doc(notificationId)
        .delete();
  }

  /// קבלת סטטיסטיקות התראות
  Future<Map<String, dynamic>> getNotificationStats(String userId) async {
    final allNotifications = await getUserNotifications(userId);
    final unreadNotifications =
        allNotifications.where((n) => !n['isRead']).toList();

    return {
      'total': allNotifications.length,
      'unread': unreadNotifications.length,
      'read': allNotifications.length - unreadNotifications.length,
      'byType': _groupNotificationsByType(allNotifications),
    };
  }

  /// קבלת התראות לפי סוג
  Map<String, int> _groupNotificationsByType(
      List<Map<String, dynamic>> notifications) {
    final grouped = <String, int>{};

    for (final notification in notifications) {
      final type = (notification['type'] as String?) ?? 'unknown';
      grouped[type] = (grouped[type] ?? 0) + 1;
    }

    return grouped;
  }

  /// שליחת התראה על הצטרפות חבר
  Future<void> notifyMemberJoined(
      String groupId, String memberId, String performedBy) async {
    final group = await _groupSharingService.getGroupById(groupId);
    if (group == null) return;

    await notifyGroupAdmins(
      groupId,
      GroupNotificationType.memberJoined,
      title: 'חבר חדש הצטרף',
      message: 'משתמש חדש הצטרף לקבוצה ${group.name}',
      data: {'memberId': memberId},
      performedBy: performedBy,
    );
  }

  /// שליחת התראה על יציאת חבר
  Future<void> notifyMemberLeft(
      String groupId, String memberId, String performedBy) async {
    final group = await _groupSharingService.getGroupById(groupId);
    if (group == null) return;

    await notifyGroupAdmins(
      groupId,
      GroupNotificationType.memberLeft,
      title: 'חבר עזב',
      message: 'משתמש עזב את הקבוצה ${group.name}',
      data: {'memberId': memberId},
      performedBy: performedBy,
    );
  }

  /// שליחת התראה על הוספת מנהל
  Future<void> notifyAdminAdded(
      String groupId, String adminId, String performedBy) async {
    final group = await _groupSharingService.getGroupById(groupId);
    if (group == null) return;

    await notifyUser(
      adminId,
      GroupNotificationType.adminAdded,
      title: 'הרשאות מנהל',
      message: 'קיבלת הרשאות מנהל בקבוצה ${group.name}',
      data: {'groupId': groupId},
      performedBy: performedBy,
    );
  }

  /// שליחת התראה על ביטול הזמנה
  Future<void> notifyInviteCancelled(
      String groupId, String inviteCode, String performedBy) async {
    final group = await _groupSharingService.getGroupById(groupId);
    if (group == null) return;

    await notifyGroupAdmins(
      groupId,
      GroupNotificationType.inviteCancelled,
      title: 'הזמנה בוטלה',
      message: 'הזמנה לקבוצה ${group.name} בוטלה',
      data: {'inviteCode': inviteCode},
      performedBy: performedBy,
    );
  }
}
