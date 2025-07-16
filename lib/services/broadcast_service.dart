import 'package:appoint/models/admin_broadcast_message.dart';
import 'package:appoint/models/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BroadcastService {

  BroadcastService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;
  final FirebaseFirestore _firestore;

  // Collection references
  CollectionReference<Map<String, dynamic>> get _broadcastsCollection =>
      _firestore.collection('admin_broadcasts');

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  // Create a new broadcast message
  Future<String> createBroadcastMessage(
      AdminBroadcastMessage message) async {
    try {
      final docRef = await _broadcastsCollection.add(message.toJson());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create broadcast message: $e');
    }
  }

  // Get all broadcast messages
  Stream<List<AdminBroadcastMessage>> getBroadcastMessages() => _broadcastsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AdminBroadcastMessage.fromJson({
                  'id': doc.id,
                  ...doc.data(),
                }),)
            .toList(),);

  // Get broadcast message by ID
  Future<AdminBroadcastMessage?> getBroadcastMessage(String id) async {
    try {
      final doc = await _broadcastsCollection.doc(id).get();
      if (doc.exists) {
        return AdminBroadcastMessage.fromJson({
          'id': doc.id,
          ...doc.data()!,
        });
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get broadcast message: $e');
    }
  }

  // Estimate target audience size
  Future<int> estimateTargetAudience(
      BroadcastTargetingFilters filters) async {
    try {
      Query query = _usersCollection;

      // Apply filters
      if (filters.countries != null && filters.countries!.isNotEmpty) {
        query = query.where('country', whereIn: filters.countries);
      }

      if (filters.cities != null && filters.cities!.isNotEmpty) {
        query = query.where('city', whereIn: filters.cities);
      }

      if (filters.subscriptionTiers != null &&
          filters.subscriptionTiers!.isNotEmpty) {
        query =
            query.where('subscriptionTier', whereIn: filters.subscriptionTiers);
      }

      if (filters.userRoles != null && filters.userRoles!.isNotEmpty) {
        query = query.where('role', whereIn: filters.userRoles);
      }

      if (filters.accountStatuses != null &&
          filters.accountStatuses!.isNotEmpty) {
        query = query.where('status', whereIn: filters.accountStatuses);
      }

      if (filters.joinedAfter != null) {
        query = query.where('createdAt',
            isGreaterThanOrEqualTo: filters.joinedAfter,);
      }

      if (filters.joinedBefore != null) {
        query =
            query.where('createdAt', isLessThanOrEqualTo: filters.joinedBefore);
      }

      final snapshot = await query.get();
      return snapshot.docs.length;
    } catch (e) {
      throw Exception('Failed to estimate target audience: $e');
    }
  }

  // Send broadcast message
  Future<void> sendBroadcastMessage(String messageId) async {
    try {
      final message = await getBroadcastMessage(messageId);
      if (message == null) {
        throw Exception('Message not found');
      }

      // Get target users
      final targetUsers = await _getTargetUsers(message.targetingFilters);

      // Update message with actual recipient count
      await _broadcastsCollection.doc(messageId).update({
        'actualRecipients': targetUsers.length,
        'status': BroadcastMessageStatus.sent.name,
      });

      // Send FCM messages
      for (final user in targetUsers) {
        await _sendFCMNotification(user, message);
      }
    } catch (e) {
      // Update message with failure status
      await _broadcastsCollection.doc(messageId).update({
        'status': BroadcastMessageStatus.failed.name,
        'failureReason': e.toString(),
      });
      throw Exception('Failed to send broadcast message: $e');
    }
  }

  // Get target users based on filters
  Future<List<UserProfile>> _getTargetUsers(
      BroadcastTargetingFilters filters) async {
    try {
      Query query = _usersCollection;

      // Apply filters
      if (filters.countries != null && filters.countries!.isNotEmpty) {
        query = query.where('country', whereIn: filters.countries);
      }

      if (filters.cities != null && filters.cities!.isNotEmpty) {
        query = query.where('city', whereIn: filters.cities);
      }

      if (filters.subscriptionTiers != null &&
          filters.subscriptionTiers!.isNotEmpty) {
        query =
            query.where('subscriptionTier', whereIn: filters.subscriptionTiers);
      }

      if (filters.userRoles != null && filters.userRoles!.isNotEmpty) {
        query = query.where('role', whereIn: filters.userRoles);
      }

      if (filters.accountStatuses != null &&
          filters.accountStatuses!.isNotEmpty) {
        query = query.where('status', whereIn: filters.accountStatuses);
      }

      if (filters.joinedAfter != null) {
        query = query.where('createdAt',
            isGreaterThanOrEqualTo: filters.joinedAfter,);
      }

      if (filters.joinedBefore != null) {
        query =
            query.where('createdAt', isLessThanOrEqualTo: filters.joinedBefore);
      }

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => UserProfile.fromJson({
                'id': doc.id,
                ...(doc.data()!),
              }),)
          .toList();
    } catch (e) {
      throw Exception('Failed to get target users: $e');
    }
  }

  // Send FCM notification to a user
  Future<void> _sendFCMNotification(
      UserProfile user, final AdminBroadcastMessage message,) async {
    try {
      // Get user's FCM token
      final userDoc = await _usersCollection.doc(user.id).get();
      final fcmToken = userDoc.data()?['fcmToken'] as String?;

      if (fcmToken == null) {
        throw Exception('User has no FCM token');
      }

      // Stub implementation for FCM notification sending
      // In a real implementation, this would call Firebase Functions to send the notification
      print('FCM notification would be sent to ${user.id} with token: $fcmToken');
      print('Message: ${message.title} - ${message.body}');
    } catch (e) {
      print('Failed to send FCM notification to ${user.id}: $e');
      rethrow;
    }
  }

  // Update message analytics
  Future<void> updateMessageAnalytics(
    final String messageId, {
    final int? openedCount,
    final int? clickedCount,
    final Map<String, int>? pollResponses,
  }) async {
    try {
      final updates = <String, dynamic>{};

      if (openedCount != null) {
        updates['openedCount'] = openedCount;
      }

      if (clickedCount != null) {
        updates['clickedCount'] = clickedCount;
      }

      if (pollResponses != null) {
        updates['pollResponses'] = pollResponses;
      }

      await _broadcastsCollection.doc(messageId).update(updates);
    } catch (e) {
      throw Exception('Failed to update message analytics: $e');
    }
  }

  // Delete broadcast message
  Future<void> deleteBroadcastMessage(String id) async {
    try {
      await _broadcastsCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete broadcast message: $e');
    }
  }
}

// Provider
final broadcastServiceProvider = Provider<BroadcastService>((ref) => BroadcastService());
