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

      // Prepare notification payload
      // TODO(username): Implement FCM notification sending via Firebase Functions
      // For now, we'll just log it
      // Removed debug print: debugPrint('Sending FCM notification to ${user.id}');
    } catch (e) {
      // Removed debug print: debugPrint('Failed to send FCM notification to ${user.id}: $e');
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

  // Get messages for a specific user based on targeting filters
  Future<List<AdminBroadcastMessage>> getMessagesForUser(UserProfile user) async {
    try {
      // Get all broadcast messages
      final allMessages = await _broadcastsCollection
          .where('status', isEqualTo: BroadcastMessageStatus.sent.name)
          .orderBy('createdAt', descending: true)
          .get();

      final List<AdminBroadcastMessage> userMessages = [];

      for (final doc in allMessages.docs) {
        final message = AdminBroadcastMessage.fromJson({
          'id': doc.id,
          ...doc.data(),
        });

        // Check if user matches the targeting filters
        if (await _userMatchesFilters(user, message.targetingFilters)) {
          userMessages.add(message);
        }
      }

      return userMessages;
    } catch (e) {
      throw Exception('Failed to get messages for user: $e');
    }
  }

  // Check if a user matches the targeting filters
  Future<bool> _userMatchesFilters(UserProfile user, BroadcastTargetingFilters filters) async {
    // If no filters are set, message goes to all users
    if (filters.countries == null &&
        filters.cities == null &&
        filters.subscriptionTiers == null &&
        filters.userRoles == null &&
        filters.accountStatuses == null &&
        filters.joinedAfter == null &&
        filters.joinedBefore == null) {
      return true;
    }

    // Get user's complete data from Firestore
    final userDoc = await _usersCollection.doc(user.id).get();
    if (!userDoc.exists) {
      return false;
    }

    final userData = userDoc.data()!;

    // Check country filter
    if (filters.countries != null && filters.countries!.isNotEmpty) {
      final userCountry = userData['country'] as String?;
      if (userCountry == null || !filters.countries!.contains(userCountry)) {
        return false;
      }
    }

    // Check city filter
    if (filters.cities != null && filters.cities!.isNotEmpty) {
      final userCity = userData['city'] as String?;
      if (userCity == null || !filters.cities!.contains(userCity)) {
        return false;
      }
    }

    // Check subscription tier filter
    if (filters.subscriptionTiers != null && filters.subscriptionTiers!.isNotEmpty) {
      final userSubscriptionTier = userData['subscriptionTier'] as String?;
      if (userSubscriptionTier == null || !filters.subscriptionTiers!.contains(userSubscriptionTier)) {
        return false;
      }
    }

    // Check user role filter
    if (filters.userRoles != null && filters.userRoles!.isNotEmpty) {
      final userRole = userData['role'] as String?;
      if (userRole == null || !filters.userRoles!.contains(userRole)) {
        return false;
      }
    }

    // Check account status filter
    if (filters.accountStatuses != null && filters.accountStatuses!.isNotEmpty) {
      final userStatus = userData['status'] as String?;
      if (userStatus == null || !filters.accountStatuses!.contains(userStatus)) {
        return false;
      }
    }

    // Check join date filters
    if (filters.joinedAfter != null) {
      final userCreatedAt = userData['createdAt'] as Timestamp?;
      if (userCreatedAt == null || userCreatedAt.toDate().isBefore(filters.joinedAfter!)) {
        return false;
      }
    }

    if (filters.joinedBefore != null) {
      final userCreatedAt = userData['createdAt'] as Timestamp?;
      if (userCreatedAt == null || userCreatedAt.toDate().isAfter(filters.joinedBefore!)) {
        return false;
      }
    }

    return true;
  }
}

// Provider
final broadcastServiceProvider = Provider<BroadcastService>((ref) => BroadcastService());
