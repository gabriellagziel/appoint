import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appoint/models/meeting_checklist.dart';

class ChecklistService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Create a new checklist
  Future<MeetingChecklist> createChecklist(
    String meetingId,
    String title,
  ) async {
    try {
      // Get meeting info for groupId
      final meetingDoc = await _firestore.collection('meetings').doc(meetingId).get();
      if (!meetingDoc.exists) {
        throw Exception('Meeting not found');
      }
      final groupId = meetingDoc.data()!['groupId'] as String;

      final checklist = MeetingChecklist(
        id: '', // Will be set by Firestore
        meetingId: meetingId,
        groupId: groupId,
        title: title,
        createdBy: _getCurrentUserId(),
        createdAt: DateTime.now(),
      );

      final docRef = await _firestore
          .collection('meetings')
          .doc(meetingId)
          .collection('checklists')
          .add(checklist.toMap());

      return checklist.copyWith(id: docRef.id);
    } catch (e) {
      throw Exception('Failed to create checklist: $e');
    }
  }

  /// List all checklists for a meeting
  Stream<List<MeetingChecklist>> listChecklists(String meetingId) {
    return _firestore
        .collection('meetings')
        .doc(meetingId)
        .collection('checklists')
        .where('isArchived', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MeetingChecklist.fromMap(doc.id, doc.data()))
            .toList());
  }

  /// Get specific checklist by ID
  Future<MeetingChecklist?> getChecklist(String meetingId, String listId) async {
    try {
      final doc = await _firestore
          .collection('meetings')
          .doc(meetingId)
          .collection('checklists')
          .doc(listId)
          .get();

      if (!doc.exists) return null;
      return MeetingChecklist.fromMap(doc.id, doc.data()!);
    } catch (e) {
      throw Exception('Failed to get checklist: $e');
    }
  }

  /// Archive a checklist
  Future<void> archiveChecklist(String meetingId, String listId) async {
    try {
      await _firestore
          .collection('meetings')
          .doc(meetingId)
          .collection('checklists')
          .doc(listId)
          .update({'isArchived': true});
    } catch (e) {
      throw Exception('Failed to archive checklist: $e');
    }
  }

  /// Update checklist title
  Future<void> updateChecklistTitle(String meetingId, String listId, String title) async {
    try {
      await _firestore
          .collection('meetings')
          .doc(meetingId)
          .collection('checklists')
          .doc(listId)
          .update({'title': title});
    } catch (e) {
      throw Exception('Failed to update checklist title: $e');
    }
  }

  /// Create a new checklist item
  Future<ChecklistItem> createItem(
    String meetingId,
    String listId,
    Map<String, dynamic> payload,
  ) async {
    try {
      // Get the next order index
      final itemsSnapshot = await _firestore
          .collection('meetings')
          .doc(meetingId)
          .collection('checklists')
          .doc(listId)
          .collection('items')
          .orderBy('orderIndex', descending: true)
          .limit(1)
          .get();

      final nextOrderIndex = itemsSnapshot.docs.isEmpty ? 0 : 
          (itemsSnapshot.docs.first.data()['orderIndex'] as int) + 1;

      final item = ChecklistItem(
        id: '', // Will be set by Firestore
        listId: listId,
        text: payload['text'] as String,
        createdBy: _getCurrentUserId(),
        assigneeId: payload['assigneeId'] as String?,
        dueAt: payload['dueAt'] != null ? (payload['dueAt'] as Timestamp).toDate() : null,
        priority: _parsePriority(payload['priority'] as String? ?? 'medium'),
        orderIndex: nextOrderIndex,
      );

      final docRef = await _firestore
          .collection('meetings')
          .doc(meetingId)
          .collection('checklists')
          .doc(listId)
          .collection('items')
          .add(item.toMap());

      return item.copyWith(id: docRef.id);
    } catch (e) {
      throw Exception('Failed to create checklist item: $e');
    }
  }

  /// List all items in a checklist
  Stream<List<ChecklistItem>> listItems(String meetingId, String listId) {
    return _firestore
        .collection('meetings')
        .doc(meetingId)
        .collection('checklists')
        .doc(listId)
        .collection('items')
        .orderBy('orderIndex', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChecklistItem.fromMap(doc.id, doc.data()))
            .toList());
  }

  /// Get specific item by ID
  Future<ChecklistItem?> getItem(String meetingId, String listId, String itemId) async {
    try {
      final doc = await _firestore
          .collection('meetings')
          .doc(meetingId)
          .collection('checklists')
          .doc(listId)
          .collection('items')
          .doc(itemId)
          .get();

      if (!doc.exists) return null;
      return ChecklistItem.fromMap(doc.id, doc.data()!);
    } catch (e) {
      throw Exception('Failed to get checklist item: $e');
    }
  }

  /// Update checklist item
  Future<void> updateItem(
    String meetingId,
    String listId,
    String itemId,
    Map<String, dynamic> patch,
  ) async {
    try {
      final updates = <String, dynamic>{};
      
      if (patch.containsKey('text')) updates['text'] = patch['text'];
      if (patch.containsKey('assigneeId')) updates['assigneeId'] = patch['assigneeId'];
      if (patch.containsKey('dueAt')) {
        updates['dueAt'] = patch['dueAt'] != null ? 
            Timestamp.fromDate(patch['dueAt'] as DateTime) : null;
      }
      if (patch.containsKey('priority')) updates['priority'] = patch['priority'];

      await _firestore
          .collection('meetings')
          .doc(meetingId)
          .collection('checklists')
          .doc(listId)
          .collection('items')
          .doc(itemId)
          .update(updates);
    } catch (e) {
      throw Exception('Failed to update checklist item: $e');
    }
  }

  /// Toggle item done status
  Future<void> toggleDone(String meetingId, String listId, String itemId, bool isDone) async {
    try {
      final updates = <String, dynamic>{
        'isDone': isDone,
        'doneBy': isDone ? _getCurrentUserId() : null,
        'doneAt': isDone ? Timestamp.fromDate(DateTime.now()) : null,
      };

      await _firestore
          .collection('meetings')
          .doc(meetingId)
          .collection('checklists')
          .doc(listId)
          .collection('items')
          .doc(itemId)
          .update(updates);
    } catch (e) {
      throw Exception('Failed to toggle item done status: $e');
    }
  }

  /// Delete checklist item
  Future<void> deleteItem(String meetingId, String listId, String itemId) async {
    try {
      await _firestore
          .collection('meetings')
          .doc(meetingId)
          .collection('checklists')
          .doc(listId)
          .collection('items')
          .doc(itemId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete checklist item: $e');
    }
  }

  /// Reorder items in a checklist
  Future<void> reorderItems(
    String meetingId,
    String listId,
    List<String> orderedIds,
  ) async {
    try {
      final batch = _firestore.batch();
      
      for (int i = 0; i < orderedIds.length; i++) {
        final itemRef = _firestore
            .collection('meetings')
            .doc(meetingId)
            .collection('checklists')
            .doc(listId)
            .collection('items')
            .doc(orderedIds[i]);
        
        batch.update(itemRef, {'orderIndex': i});
      }
      
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to reorder items: $e');
    }
  }

  /// Get checklist statistics
  Map<String, dynamic> getChecklistStats(List<ChecklistItem> items) {
    final totalItems = items.length;
    final doneItems = items.where((item) => item.isDone).length;
    final pendingItems = totalItems - doneItems;
    final overdueItems = items.where((item) => item.isOverdue).length;
    final dueSoonItems = items.where((item) => item.isDueSoon).length;

    return {
      'totalItems': totalItems,
      'doneItems': doneItems,
      'pendingItems': pendingItems,
      'overdueItems': overdueItems,
      'dueSoonItems': dueSoonItems,
      'completionPercentage': totalItems > 0 ? (doneItems / totalItems * 100).round() : 0,
    };
  }

  /// Get items by assignee
  List<ChecklistItem> getItemsByAssignee(List<ChecklistItem> items, String assigneeId) {
    return items.where((item) => item.assigneeId == assigneeId).toList();
  }

  /// Get items by priority
  List<ChecklistItem> getItemsByPriority(List<ChecklistItem> items, ChecklistItemPriority priority) {
    return items.where((item) => item.priority == priority).toList();
  }

  /// Get overdue items
  List<ChecklistItem> getOverdueItems(List<ChecklistItem> items) {
    return items.where((item) => item.isOverdue).toList();
  }

  /// Get due soon items
  List<ChecklistItem> getDueSoonItems(List<ChecklistItem> items) {
    return items.where((item) => item.isDueSoon).toList();
  }

  // Helper methods
  ChecklistItemPriority _parsePriority(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return ChecklistItemPriority.high;
      case 'low':
        return ChecklistItemPriority.low;
      default:
        return ChecklistItemPriority.medium;
    }
  }

  String _getCurrentUserId() {
    // TODO: Get current user ID from auth service
    return 'current-user-id';
  }
}
