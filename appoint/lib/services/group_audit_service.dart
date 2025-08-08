import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appoint/models/group_audit_event.dart';

class GroupAuditService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get all audit events for a group
  Future<List<GroupAuditEvent>> getGroupAuditEvents(String groupId) async {
    try {
      final eventsDoc = await _firestore
          .collection('groups')
          .doc(groupId)
          .collection('audit')
          .orderBy('timestamp', descending: true)
          .limit(100)
          .get();

      return eventsDoc.docs.map((doc) {
        return GroupAuditEvent.fromMap(doc.id, doc.data());
      }).toList();
    } catch (e) {
      throw Exception('Failed to get group audit events: $e');
    }
  }

  /// Get recent audit events
  Future<List<GroupAuditEvent>> getRecentAuditEvents(String groupId) async {
    try {
      final eventsDoc = await _firestore
          .collection('groups')
          .doc(groupId)
          .collection('audit')
          .orderBy('timestamp', descending: true)
          .limit(20)
          .get();

      return eventsDoc.docs.map((doc) {
        return GroupAuditEvent.fromMap(doc.id, doc.data());
      }).toList();
    } catch (e) {
      throw Exception('Failed to get recent audit events: $e');
    }
  }

  /// Get audit events by type
  Future<List<GroupAuditEvent>> getAuditEventsByType(
      String groupId, AuditEventType type) async {
    try {
      final eventsDoc = await _firestore
          .collection('groups')
          .doc(groupId)
          .collection('audit')
          .where('type', isEqualTo: type.name)
          .orderBy('timestamp', descending: true)
          .limit(50)
          .get();

      return eventsDoc.docs.map((doc) {
        return GroupAuditEvent.fromMap(doc.id, doc.data());
      }).toList();
    } catch (e) {
      throw Exception('Failed to get audit events by type: $e');
    }
  }

  /// Log an audit event
  Future<void> logAuditEvent(String groupId, GroupAuditEvent event) async {
    try {
      await _firestore
          .collection('groups')
          .doc(groupId)
          .collection('audit')
          .add(event.toMap());
    } catch (e) {
      throw Exception('Failed to log audit event: $e');
    }
  }

  /// Log a role change event
  Future<void> logRoleChange(String groupId, String actorUserId,
      String targetUserId, String oldRole, String newRole) async {
    final event = GroupAuditEvent(
      id: '',
      groupId: groupId,
      type: AuditEventType.roleChanged,
      actorUserId: actorUserId,
      targetUserId: targetUserId,
      timestamp: DateTime.now(),
      metadata: {
        'oldRole': oldRole,
        'newRole': newRole,
      },
    );

    await logAuditEvent(groupId, event);
  }

  /// Log a policy change event
  Future<void> logPolicyChange(
      String groupId, String actorUserId, Map<String, dynamic> changes) async {
    final event = GroupAuditEvent(
      id: '',
      groupId: groupId,
      type: AuditEventType.policyChanged,
      actorUserId: actorUserId,
      timestamp: DateTime.now(),
      metadata: changes,
    );

    await logAuditEvent(groupId, event);
  }

  /// Log a member removal event
  Future<void> logMemberRemoved(
      String groupId, String actorUserId, String targetUserId) async {
    final event = GroupAuditEvent(
      id: '',
      groupId: groupId,
      type: AuditEventType.memberRemoved,
      actorUserId: actorUserId,
      targetUserId: targetUserId,
      timestamp: DateTime.now(),
    );

    await logAuditEvent(groupId, event);
  }

  /// Log a vote event
  Future<void> logVoteEvent(String groupId, String actorUserId, String voteId,
      String action, String targetUserId) async {
    final event = GroupAuditEvent(
      id: '',
      groupId: groupId,
      type: AuditEventType.voteOpened,
      actorUserId: actorUserId,
      targetUserId: targetUserId,
      timestamp: DateTime.now(),
      metadata: {
        'voteId': voteId,
        'action': action,
      },
    );

    await logAuditEvent(groupId, event);
  }
}
