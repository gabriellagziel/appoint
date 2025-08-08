import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/group_audit_event.dart';

class GroupAuditService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Log an audit event
  Future<bool> logEvent({
    required String groupId,
    required String actorUserId,
    required AuditEventType type,
    Map<String, dynamic>? metadata,
    String? targetUserId,
    String? description,
  }) async {
    try {
      final eventId = _firestore.collection('audit').doc().id;
      final event = GroupAuditEvent(
        id: eventId,
        groupId: groupId,
        actorUserId: actorUserId,
        type: type,
        metadata: metadata ?? {},
        timestamp: DateTime.now(),
        targetUserId: targetUserId,
        description: description,
      );

      await _firestore
          .collection('user_groups')
          .doc(groupId)
          .collection('audit')
          .doc(eventId)
          .set(event.toMap());

      return true;
    } catch (e) {
      print('Error logging audit event: $e');
      return false;
    }
  }

  /// Get audit events for a group
  Future<List<GroupAuditEvent>> getGroupAuditEvents(String groupId,
      {int limit = 50}) async {
    try {
      final querySnapshot = await _firestore
          .collection('user_groups')
          .doc(groupId)
          .collection('audit')
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => GroupAuditEvent.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      print('Error getting audit events: $e');
      return [];
    }
  }

  /// Get audit events by type
  Future<List<GroupAuditEvent>> getAuditEventsByType(
      String groupId, AuditEventType type) async {
    try {
      final allEvents = await getGroupAuditEvents(groupId);
      return allEvents.where((event) => event.type == type).toList();
    } catch (e) {
      print('Error getting audit events by type: $e');
      return [];
    }
  }

  /// Get recent audit events (last 7 days)
  Future<List<GroupAuditEvent>> getRecentAuditEvents(String groupId) async {
    try {
      final allEvents = await getGroupAuditEvents(groupId);
      final weekAgo = DateTime.now().subtract(const Duration(days: 7));
      return allEvents
          .where((event) => event.timestamp.isAfter(weekAgo))
          .toList();
    } catch (e) {
      print('Error getting recent audit events: $e');
      return [];
    }
  }

  /// Get audit events for a specific user
  Future<List<GroupAuditEvent>> getAuditEventsForUser(
      String groupId, String userId) async {
    try {
      final allEvents = await getGroupAuditEvents(groupId);
      return allEvents
          .where((event) =>
              event.actorUserId == userId || event.targetUserId == userId)
          .toList();
    } catch (e) {
      print('Error getting audit events for user: $e');
      return [];
    }
  }
}
