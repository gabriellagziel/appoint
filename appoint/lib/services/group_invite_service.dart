import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/group_invite.dart';
import 'group_sharing_service.dart';
import 'group_permission_service.dart';

class GroupInviteService {
  final GroupSharingService _groupSharingService = GroupSharingService();
  final GroupPermissionService _permissionService = GroupPermissionService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// יצירת הזמנה חדשה לקבוצה
  Future<String> createInvite(
    String groupId,
    String creatorId, {
    int maxUses = -1,
    Duration? expiresIn,
  }) async {
    if (!await _permissionService.canInviteToGroup(groupId, creatorId)) {
      throw Exception('Insufficient permissions to create invite');
    }

    final inviteCode = _generateInviteCode();
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

    // Log invite creation
    await _logInviteAction(
      inviteCode: inviteCode,
      groupId: groupId,
      action: 'created',
      performedBy: creatorId,
    );

    return inviteCode;
  }

  /// קבלת פרטי הזמנה
  Future<GroupInvite?> getInvite(String inviteCode) async {
    final doc =
        await _firestore.collection('group_invites').doc(inviteCode).get();

    if (!doc.exists) return null;

    return GroupInvite.fromMap(doc.id, doc.data()!);
  }

  /// קבלת כל ההזמנות הפעילות לקבוצה
  Future<List<GroupInvite>> getActiveInvites(String groupId) async {
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
  Future<void> cancelInvite(String inviteCode, String userId) async {
    final invite = await getInvite(inviteCode);
    if (invite == null) throw Exception('Invite not found');

    if (!await _permissionService.canInviteToGroup(invite.groupId, userId)) {
      throw Exception('Insufficient permissions to cancel invite');
    }

    await _firestore.collection('group_invites').doc(inviteCode).update({
      'isActive': false,
    });

    // Log invite cancellation
    await _logInviteAction(
      inviteCode: inviteCode,
      groupId: invite.groupId,
      action: 'cancelled',
      performedBy: userId,
    );
  }

  /// קבלת היסטוריית הזמנות
  Future<List<Map<String, dynamic>>> getInviteHistory(String groupId) async {
    final query = await _firestore
        .collection('group_invite_history')
        .where('groupId', isEqualTo: groupId)
        .orderBy('timestamp', descending: true)
        .limit(50)
        .get();

    return query.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'inviteCode': data['inviteCode'],
        'groupId': data['groupId'],
        'action': data['action'],
        'timestamp': (data['timestamp'] as Timestamp).toDate(),
        'performedBy': data['performedBy'],
      };
    }).toList();
  }

  /// קבלת סטטיסטיקות הזמנות
  Future<Map<String, dynamic>> getInviteStats(String groupId) async {
    final invites = await getActiveInvites(groupId);

    int totalUses = 0;
    int totalInvites = invites.length;

    for (final invite in invites) {
      totalUses += invite.usedBy.length;
    }

    return {
      'activeInvites': totalInvites,
      'totalUses': totalUses,
      'avgUsesPerInvite': totalInvites > 0 ? totalUses / totalInvites : 0,
    };
  }

  /// יצירת קישור שיתוף
  String createShareLink(String inviteCode) {
    return 'https://app-oint.com/group-invite/$inviteCode';
  }

  /// יצירת קוד הזמנה ייחודי
  String _generateInviteCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return String.fromCharCodes(Iterable.generate(
        6,
        (_) => chars
            .codeUnitAt(DateTime.now().millisecondsSinceEpoch % chars.length)));
  }

  /// רישום פעולת הזמנה
  Future<void> _logInviteAction({
    required String inviteCode,
    required String groupId,
    required String action,
    required String performedBy,
  }) async {
    await _firestore.collection('group_invite_history').add({
      'inviteCode': inviteCode,
      'groupId': groupId,
      'action': action,
      'timestamp': Timestamp.now(),
      'performedBy': performedBy,
    });
  }
}
