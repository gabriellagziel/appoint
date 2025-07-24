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

  CollectionReference<Map<String, dynamic>> get _analyticsCollection =>
      _firestore.collection('broadcast_analytics');

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

      // Update message with actual recipient count and sent timestamp
      await _broadcastsCollection.doc(messageId).update({
        'actualRecipients': targetUsers.length,
        'status': BroadcastMessageStatus.sent.name,
        'sentAt': FieldValue.serverTimestamp(),
      });

      // Send FCM messages and track sent events
      for (final user in targetUsers) {
        try {
          await _sendFCMNotification(user, message);
          // Track successful send
          await trackMessageInteraction(messageId, user.id, 'sent');
        } catch (e) {
          // Track failed send
          await trackMessageInteraction(
            messageId, 
            user.id, 
            'failed',
            additionalData: {'error': e.toString()},
          );
        }
      }
    } catch (e) {
      // Update message with failure status
      await _broadcastsCollection.doc(messageId).update({
        'status': BroadcastMessageStatus.failed.name,
        'failureReason': e.toString(),
        'processedAt': FieldValue.serverTimestamp(),
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

  /// Track message interaction events for analytics
  Future<void> trackMessageInteraction(
    String messageId,
    String userId,
    String event, {
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final data = {
        'messageId': messageId,
        'userId': userId,
        'event': event, // sent, received, opened, clicked, poll_response, failed
        'timestamp': FieldValue.serverTimestamp(),
        ...?additionalData,
      };

      await _analyticsCollection.add(data);

      // Update message-level analytics counters
      await _updateMessageCounters(messageId, event);
    } catch (e) {
      // Log error but don't fail the operation
      print('Failed to track message interaction: $e');
    }
  }

  /// Update message-level analytics counters
  Future<void> _updateMessageCounters(String messageId, String event) async {
    try {
      final messageRef = _broadcastsCollection.doc(messageId);
      
      switch (event) {
        case 'opened':
          await messageRef.update({
            'openedCount': FieldValue.increment(1),
          });
          break;
        case 'clicked':
          await messageRef.update({
            'clickedCount': FieldValue.increment(1),
          });
          break;
        case 'poll_response':
          await messageRef.update({
            'pollResponseCount': FieldValue.increment(1),
          });
          break;
        case 'failed':
          await messageRef.update({
            'failedCount': FieldValue.increment(1),
          });
          break;
      }
    } catch (e) {
      print('Failed to update message counters: $e');
    }
  }

  /// Get comprehensive analytics for a message
  Future<Map<String, dynamic>> getMessageAnalytics(String messageId) async {
    try {
      // Get message data
      final messageDoc = await _broadcastsCollection.doc(messageId).get();
      if (!messageDoc.exists) {
        throw Exception('Message not found');
      }

      final messageData = messageDoc.data()!;
      final actualRecipients = messageData['actualRecipients'] as int? ?? 0;
      final openedCount = messageData['openedCount'] as int? ?? 0;
      final clickedCount = messageData['clickedCount'] as int? ?? 0;
      final pollResponseCount = messageData['pollResponseCount'] as int? ?? 0;
      final failedCount = messageData['failedCount'] as int? ?? 0;

      // Get detailed analytics events
      final analyticsQuery = await _analyticsCollection
          .where('messageId', isEqualTo: messageId)
          .orderBy('timestamp', descending: true)
          .get();

      final events = analyticsQuery.docs.map((doc) => {
        'id': doc.id,
        ...doc.data(),
      }).toList();

      // Calculate rates
      final openRate = actualRecipients > 0 ? (openedCount / actualRecipients * 100) : 0.0;
      final clickRate = openedCount > 0 ? (clickedCount / openedCount * 100) : 0.0;
      final responseRate = actualRecipients > 0 ? (pollResponseCount / actualRecipients * 100) : 0.0;
      final deliveryRate = actualRecipients > 0 ? ((actualRecipients - failedCount) / actualRecipients * 100) : 0.0;

      // Get poll response breakdown if applicable
      Map<String, int>? pollBreakdown;
      if (messageData['type'] == BroadcastMessageType.poll.name) {
        pollBreakdown = await _getPollResponseBreakdown(messageId);
      }

      return {
        'messageId': messageId,
        'title': messageData['title'],
        'type': messageData['type'],
        'status': messageData['status'],
        'createdAt': messageData['createdAt'],
        'sentAt': messageData['sentAt'],
        'actualRecipients': actualRecipients,
        'openedCount': openedCount,
        'clickedCount': clickedCount,
        'pollResponseCount': pollResponseCount,
        'failedCount': failedCount,
        'openRate': openRate,
        'clickRate': clickRate,
        'responseRate': responseRate,
        'deliveryRate': deliveryRate,
        'pollBreakdown': pollBreakdown,
        'events': events,
      };
    } catch (e) {
      throw Exception('Failed to get message analytics: $e');
    }
  }

  /// Get poll response breakdown
  Future<Map<String, int>> _getPollResponseBreakdown(String messageId) async {
    try {
      final responseQuery = await _analyticsCollection
          .where('messageId', isEqualTo: messageId)
          .where('event', isEqualTo: 'poll_response')
          .get();

      final breakdown = <String, int>{};
      for (final doc in responseQuery.docs) {
        final data = doc.data();
        final selectedOption = data['selectedOption'] as String?;
        if (selectedOption != null) {
          breakdown[selectedOption] = (breakdown[selectedOption] ?? 0) + 1;
        }
      }

      return breakdown;
    } catch (e) {
      print('Failed to get poll response breakdown: $e');
      return {};
    }
  }

  /// Get analytics summary for multiple messages
  Future<Map<String, dynamic>> getAnalyticsSummary({
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) async {
    try {
      Query query = _broadcastsCollection
          .where('status', isEqualTo: BroadcastMessageStatus.sent.name)
          .orderBy('createdAt', descending: true);

      if (startDate != null) {
        query = query.where('createdAt', isGreaterThanOrEqualTo: startDate);
      }

      if (endDate != null) {
        query = query.where('createdAt', isLessThanOrEqualTo: endDate);
      }

      if (limit != null) {
        query = query.limit(limit);
      }

      final snapshot = await query.get();
      
      int totalMessages = 0;
      int totalRecipients = 0;
      int totalOpened = 0;
      int totalClicked = 0;
      int totalFailed = 0;
      final messagesByType = <String, int>{};
      final messagesByDate = <String, int>{};

      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        totalMessages++;
        totalRecipients += (data['actualRecipients'] as int? ?? 0);
        totalOpened += (data['openedCount'] as int? ?? 0);
        totalClicked += (data['clickedCount'] as int? ?? 0);
        totalFailed += (data['failedCount'] as int? ?? 0);

        // Count by type
        final type = data['type'] as String? ?? 'unknown';
        messagesByType[type] = (messagesByType[type] ?? 0) + 1;

        // Count by date
        final createdAt = (data['createdAt'] as Timestamp?)?.toDate();
        if (createdAt != null) {
          final dateKey = '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}';
          messagesByDate[dateKey] = (messagesByDate[dateKey] ?? 0) + 1;
        }
      }

      final avgOpenRate = totalRecipients > 0 ? (totalOpened / totalRecipients * 100) : 0.0;
      final avgClickRate = totalOpened > 0 ? (totalClicked / totalOpened * 100) : 0.0;
      final avgDeliveryRate = totalRecipients > 0 ? ((totalRecipients - totalFailed) / totalRecipients * 100) : 0.0;

      return {
        'totalMessages': totalMessages,
        'totalRecipients': totalRecipients,
        'totalOpened': totalOpened,
        'totalClicked': totalClicked,
        'totalFailed': totalFailed,
        'avgOpenRate': avgOpenRate,
        'avgClickRate': avgClickRate,
        'avgDeliveryRate': avgDeliveryRate,
        'messagesByType': messagesByType,
        'messagesByDate': messagesByDate,
      };
    } catch (e) {
      throw Exception('Failed to get analytics summary: $e');
    }
  }

  /// Process scheduled messages that are ready to be sent
  Future<void> processScheduledMessages() async {
    try {
      final now = DateTime.now();
      
      // Find messages scheduled for sending
      final scheduledQuery = await _broadcastsCollection
          .where('status', isEqualTo: BroadcastMessageStatus.pending.name)
          .where('scheduledFor', isLessThanOrEqualTo: now)
          .get();

      for (final doc in scheduledQuery.docs) {
        try {
          await sendBroadcastMessage(doc.id);
          print('Successfully sent scheduled message: ${doc.id}');
        } catch (e) {
          print('Failed to send scheduled message ${doc.id}: $e');
          
          // Update message with failure status
          await _broadcastsCollection.doc(doc.id).update({
            'status': BroadcastMessageStatus.failed.name,
            'failureReason': 'Scheduled send failed: $e',
            'processedAt': FieldValue.serverTimestamp(),
          });
        }
      }
    } catch (e) {
      print('Error processing scheduled messages: $e');
      throw Exception('Failed to process scheduled messages: $e');
    }
  }

  /// Export analytics data as CSV-formatted string
  Future<String> exportAnalyticsCSV({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      Query query = _broadcastsCollection
          .where('status', isEqualTo: BroadcastMessageStatus.sent.name)
          .orderBy('createdAt', descending: true);

      if (startDate != null) {
        query = query.where('createdAt', isGreaterThanOrEqualTo: startDate);
      }

      if (endDate != null) {
        query = query.where('createdAt', isLessThanOrEqualTo: endDate);
      }

      final snapshot = await query.get();
      
      final csvLines = <String>[];
      csvLines.add('Message ID,Title,Type,Created At,Recipients,Opened,Clicked,Open Rate %,Click Rate %,Status');

      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final recipients = data['actualRecipients'] as int? ?? 0;
        final opened = data['openedCount'] as int? ?? 0;
        final clicked = data['clickedCount'] as int? ?? 0;
        final openRate = recipients > 0 ? (opened / recipients * 100).toStringAsFixed(2) : '0.00';
        final clickRate = opened > 0 ? (clicked / opened * 100).toStringAsFixed(2) : '0.00';
        final createdAt = (data['createdAt'] as Timestamp?)?.toDate().toIso8601String() ?? '';

        csvLines.add('"${doc.id}","${data['title'] ?? ''}","${data['type'] ?? ''}","$createdAt","$recipients","$opened","$clicked","$openRate","$clickRate","${data['status'] ?? ''}"');
      }

      return csvLines.join('\n');
    } catch (e) {
      throw Exception('Failed to export analytics CSV: $e');
    }
  }

  /// Get real-time analytics stream for a message
  Stream<Map<String, dynamic>> getMessageAnalyticsStream(String messageId) {
    return _broadcastsCollection.doc(messageId).snapshots().map((snapshot) {
      if (!snapshot.exists) {
        return {'error': 'Message not found'};
      }

      final data = snapshot.data()!;
      final actualRecipients = data['actualRecipients'] as int? ?? 0;
      final openedCount = data['openedCount'] as int? ?? 0;
      final clickedCount = data['clickedCount'] as int? ?? 0;
      final failedCount = data['failedCount'] as int? ?? 0;

      final openRate = actualRecipients > 0 ? (openedCount / actualRecipients * 100) : 0.0;
      final clickRate = openedCount > 0 ? (clickedCount / openedCount * 100) : 0.0;
      final deliveryRate = actualRecipients > 0 ? ((actualRecipients - failedCount) / actualRecipients * 100) : 0.0;

      return {
        'messageId': messageId,
        'actualRecipients': actualRecipients,
        'openedCount': openedCount,
        'clickedCount': clickedCount,
        'failedCount': failedCount,
        'openRate': openRate,
        'clickRate': clickRate,
        'deliveryRate': deliveryRate,
        'lastUpdated': DateTime.now().toIso8601String(),
      };
    });
  }
}

// Provider
final broadcastServiceProvider = Provider<BroadcastService>((ref) => BroadcastService());

// Alias for compatibility with existing code
final adminBroadcastServiceProvider = broadcastServiceProvider;
