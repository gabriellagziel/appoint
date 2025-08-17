import 'package:cloud_firestore/cloud_firestore.dart';
import 'group_sharing_service.dart';
import 'group_manager.dart';

class GroupAnalyticsService {
  final GroupSharingService _groupSharingService = GroupSharingService();
  final GroupManager _groupManager = GroupManager();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// קבלת אנליטיקה כללית של קבוצה
  Future<Map<String, dynamic>> getGroupAnalytics(String groupId) async {
    final group = await _groupSharingService.getGroupById(groupId);
    if (group == null) return {};

    final stats = await _groupManager.getGroupStats(groupId);
    final membershipHistory = await _getMembershipHistory(groupId);
    final inviteHistory = await _getInviteHistory(groupId);

    return {
      'group': {
        'id': group.id,
        'name': group.name,
        'memberCount': group.memberCount,
        'adminCount': group.adminCount,
        'createdAt': group.createdAt,
        'isActive': group.isActive,
      },
      'stats': stats,
      'membership': {
        'totalJoins':
            membershipHistory.where((h) => h['action'] == 'joined').length,
        'totalLeaves':
            membershipHistory.where((h) => h['action'] == 'left').length,
        'recentActivity': membershipHistory.take(10).toList(),
      },
      'invites': {
        'totalCreated':
            inviteHistory.where((h) => h['action'] == 'created').length,
        'totalCancelled':
            inviteHistory.where((h) => h['action'] == 'cancelled').length,
        'recentActivity': inviteHistory.take(10).toList(),
      },
    };
  }

  /// קבלת אנליטיקה של משתמש בקבוצות
  Future<Map<String, dynamic>> getUserGroupAnalytics(String userId) async {
    final userGroups = await _groupSharingService.getUserGroups(userId);
    final adminGroups = await _groupManager.getUserAdminGroups(userId);
    final membershipHistory = await _getUserMembershipHistory(userId);

    return {
      'totalGroups': userGroups.length,
      'adminGroups': adminGroups.length,
      'memberGroups': userGroups.length - adminGroups.length,
      'recentActivity': membershipHistory.take(10).toList(),
      'groups': userGroups
          .map((group) => {
                'id': group.id,
                'name': group.name,
                'isAdmin': group.admins.contains(userId),
                'memberCount': group.memberCount,
                'createdAt': group.createdAt,
              })
          .toList(),
    };
  }

  /// קבלת אנליטיקה כללית של המערכת
  Future<Map<String, dynamic>> getSystemAnalytics() async {
    final groupsQuery = await _firestore.collection('user_groups').get();
    final invitesQuery = await _firestore.collection('group_invites').get();
    final membershipQuery =
        await _firestore.collection('group_membership_history').get();

    final totalGroups = groupsQuery.docs.length;
    final activeGroups =
        groupsQuery.docs.where((doc) => doc.data()['isActive'] == true).length;
    final totalInvites = invitesQuery.docs.length;
    final activeInvites =
        invitesQuery.docs.where((doc) => doc.data()['isActive'] == true).length;
    final totalMembershipActions = membershipQuery.docs.length;

    return {
      'groups': {
        'total': totalGroups,
        'active': activeGroups,
        'archived': totalGroups - activeGroups,
      },
      'invites': {
        'total': totalInvites,
        'active': activeInvites,
        'cancelled': totalInvites - activeInvites,
      },
      'membership': {
        'totalActions': totalMembershipActions,
        'joins': membershipQuery.docs
            .where((doc) => doc.data()['action'] == 'joined')
            .length,
        'leaves': membershipQuery.docs
            .where((doc) => doc.data()['action'] == 'left')
            .length,
      },
    };
  }

  /// קבלת מגמות פעילות
  Future<Map<String, dynamic>> getActivityTrends(String groupId,
      {Duration? period}) async {
    final endDate = DateTime.now();
    final startDate = period != null
        ? endDate.subtract(period)
        : endDate.subtract(const Duration(days: 30));

    final membershipQuery = await _firestore
        .collection('group_membership_history')
        .where('groupId', isEqualTo: groupId)
        .where('timestamp',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .get();

    final activityByDay = <String, int>{};

    for (final doc in membershipQuery.docs) {
      final timestamp = (doc.data()['timestamp'] as Timestamp).toDate();
      final dayKey =
          '${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.day.toString().padLeft(2, '0')}';
      activityByDay[dayKey] = (activityByDay[dayKey] ?? 0) + 1;
    }

    return {
      'period': {
        'start': startDate,
        'end': endDate,
      },
      'activityByDay': activityByDay,
      'totalActions': membershipQuery.docs.length,
    };
  }

  /// קבלת היסטוריית חברות
  Future<List<Map<String, dynamic>>> _getMembershipHistory(
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
        'userId': data['userId'],
        'action': data['action'],
        'timestamp': (data['timestamp'] as Timestamp).toDate(),
        'performedBy': data['performedBy'],
      };
    }).toList();
  }

  /// קבלת היסטוריית הזמנות
  Future<List<Map<String, dynamic>>> _getInviteHistory(String groupId) async {
    final query = await _firestore
        .collection('group_invite_history')
        .where('groupId', isEqualTo: groupId)
        .orderBy('timestamp', descending: true)
        .limit(100)
        .get();

    return query.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'inviteCode': data['inviteCode'],
        'action': data['action'],
        'timestamp': (data['timestamp'] as Timestamp).toDate(),
        'performedBy': data['performedBy'],
      };
    }).toList();
  }

  /// קבלת היסטוריית חברות של משתמש
  Future<List<Map<String, dynamic>>> _getUserMembershipHistory(
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
        'action': data['action'],
        'timestamp': (data['timestamp'] as Timestamp).toDate(),
        'performedBy': data['performedBy'],
      };
    }).toList();
  }
}
