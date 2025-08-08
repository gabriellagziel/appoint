import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/saved_group.dart';

class SavedGroupsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get all saved groups for a user
  Future<List<SavedGroup>> getSavedGroups(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('saved_groups')
          .orderBy('lastUsedAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => SavedGroup.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      print('Error getting saved groups: $e');
      return [];
    }
  }

  /// Get saved groups sorted by pinned first, then by last used
  Future<List<SavedGroup>> getSavedGroupsSorted(String userId) async {
    final groups = await getSavedGroups(userId);

    // Sort: pinned first, then by lastUsedAt (most recent first)
    groups.sort((a, b) {
      if (a.pinned != b.pinned) {
        return a.pinned ? -1 : 1;
      }
      return b.lastUsedAt.compareTo(a.lastUsedAt);
    });

    return groups;
  }

  /// Save a group for a user
  Future<bool> saveGroup(String userId, String groupId) async {
    try {
      final savedGroup = SavedGroup(
        groupId: groupId,
        pinned: false,
        lastUsedAt: DateTime.now(),
        useCount: 1,
      );

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('saved_groups')
          .doc(groupId)
          .set(savedGroup.toMap());

      return true;
    } catch (e) {
      print('Error saving group: $e');
      return false;
    }
  }

  /// Pin/unpin a group
  Future<bool> pinGroup(String userId, String groupId, bool pinned) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('saved_groups')
          .doc(groupId)
          .update({'pinned': pinned});

      return true;
    } catch (e) {
      print('Error pinning group: $e');
      return false;
    }
  }

  /// Set an alias for a group
  Future<bool> aliasGroup(String userId, String groupId, String alias) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('saved_groups')
          .doc(groupId)
          .update({'alias': alias});

      return true;
    } catch (e) {
      print('Error setting group alias: $e');
      return false;
    }
  }

  /// Touch a group (update usage stats)
  Future<bool> touchGroup(String userId, String groupId) async {
    try {
      final docRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('saved_groups')
          .doc(groupId);

      final doc = await docRef.get();

      if (doc.exists) {
        // Update existing saved group
        await docRef.update({
          'lastUsedAt': Timestamp.fromDate(DateTime.now()),
          'useCount': FieldValue.increment(1),
        });
      } else {
        // Create new saved group
        final savedGroup = SavedGroup(
          groupId: groupId,
          pinned: false,
          lastUsedAt: DateTime.now(),
          useCount: 1,
        );
        await docRef.set(savedGroup.toMap());
      }

      return true;
    } catch (e) {
      print('Error touching group: $e');
      return false;
    }
  }

  /// Remove a saved group
  Future<bool> removeSavedGroup(String userId, String groupId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('saved_groups')
          .doc(groupId)
          .delete();

      return true;
    } catch (e) {
      print('Error removing saved group: $e');
      return false;
    }
  }

  /// Check if a group is saved
  Future<bool> isGroupSaved(String userId, String groupId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('saved_groups')
          .doc(groupId)
          .get();

      return doc.exists;
    } catch (e) {
      print('Error checking if group is saved: $e');
      return false;
    }
  }

  /// Get a specific saved group
  Future<SavedGroup?> getSavedGroup(String userId, String groupId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('saved_groups')
          .doc(groupId)
          .get();

      if (!doc.exists) return null;

      return SavedGroup.fromMap(doc.id, doc.data()!);
    } catch (e) {
      print('Error getting saved group: $e');
      return null;
    }
  }
}
