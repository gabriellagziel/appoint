import 'package:appoint/models/admin_broadcast_message.dart';
import 'package:appoint/models/user_profile.dart';
import 'package:appoint/services/broadcast_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
      AdminBroadcastMessage message,) async {
    try {
      final messageData = message.toJson();
      
      // If scheduled, add to scheduling queue
      if (message.scheduledFor != null && message.scheduledFor!.isAfter(DateTime.now())) {
        messageData['status'] = BroadcastMessageStatus.pending.name;
        messageData['isScheduled'] = true;
      }
      
      final docRef = await _broadcastsCollection.add(messageData);
      
      // If not scheduled, it can be sent immediately
      if (message.scheduledFor == null || message.scheduledFor!.isBefore(DateTime.now().add(Duration(minutes: 1)))) {
        messageData['status'] = BroadcastMessageStatus.pending.name;
        messageData['isScheduled'] = false;
      }
      
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
      doc = await _broadcastsCollection.doc(id).get();
      if (doc.exists) {
        return AdminBroadcastMessage.fromJson({
          'id': doc.id,
          ...doc.data()!,
        });
      }
      return null;
    } catch (e) {e) {
      throw Exception('Failed to get broadcast message: $e');
    }
  }

  // Estimate target audience size
  Future<int> estimateTargetAudience(
      BroadcastTargetingFilters filters,) async {
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

      snapshot = await query.get();
      return snapshot.docs.length;
    } catch (e) {e) {
      throw Exception('Failed to estimate target audience: $e');
    }
  }

  // Send broadcast message
  Future<void> sendBroadcastMessage(String messageId) async {
    try {
      message = await getBroadcastMessage(messageId);
      if (message == null) {
        throw Exception('Message not found');
      }

      // Get target users
      targetUsers = await _getTargetUsers(message.targetingFilters);

      // Update message with actual recipient count
      await _broadcastsCollection.doc(messageId).update({
        'actualRecipients': targetUsers.length,
        'status': BroadcastMessageStatus.sent.name,
      });

      // Send FCM messages
      for (user in targetUsers) {
        await _sendFCMNotification(user, message);
      }
    } catch (e) {e) {
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
      BroadcastTargetingFilters filters,) async {
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

      snapshot = await query.get();
      return snapshot.docs
          .map((doc) => UserProfile.fromJson({
                'id': doc.id,
                ...(doc.data()! as Map<String, dynamic>),
              }),)
          .toList();
    } catch (e) {e) {
      throw Exception('Failed to get target users: $e');
    }
  }

  // Send FCM notification to a user
  Future<void> _sendFCMNotification(
      UserProfile user, AdminBroadcastMessage message,) async {
    try {
      // Get user's FCM token
      final userDoc = await _usersCollection.doc(user.id).get();
      final fcmToken = userDoc.data()?['fcmToken'] as String?;

      if (fcmToken == null || fcmToken.isEmpty) {
        throw Exception('User has no FCM token');
      }

      // Prepare notification payload based on message type
      final notification = <String, dynamic>{
        'title': message.title,
        'body': message.content,
      };

      final data = <String, dynamic>{
        'messageId': message.id,
        'type': message.type.name,
        'clickAction': 'FLUTTER_NOTIFICATION_CLICK',
      };

      // Add type-specific data
      switch (message.type) {
        case BroadcastMessageType.image:
          if (message.imageUrl != null) {
            data['imageUrl'] = message.imageUrl!;
            notification['image'] = message.imageUrl!;
          }
          break;
        case BroadcastMessageType.video:
          if (message.videoUrl != null) {
            data['videoUrl'] = message.videoUrl!;
          }
          break;
        case BroadcastMessageType.link:
          if (message.externalLink != null) {
            data['externalLink'] = message.externalLink!;
          }
          break;
        case BroadcastMessageType.poll:
          if (message.pollOptions != null) {
            data['pollOptions'] = json.encode(message.pollOptions!);
          }
          break;
        case BroadcastMessageType.text:
          // Text messages don't need additional data
          break;
      }

      // Send via Firebase Cloud Messaging
      await _sendFCMToToken(fcmToken, notification, data);
      
      // Track successful send
      await _trackMessageSent(message.id, user.id);
      
    } catch (e) {
      // Track failed send
      await _trackMessageFailed(message.id, user.id, e.toString());
      rethrow;
    }
  }

  // Send FCM message to specific token
  Future<void> _sendFCMToToken(
    String token,
    Map<String, dynamic> notification,
    Map<String, dynamic> data,
  ) async {
    try {
      final config = BroadcastConfig.instance;
      
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'key=${config.fcmServerKey}',
      };

      final payload = {
        'to': token,
        'notification': notification,
        'data': data,
        'priority': 'high',
        'content_available': true,
      };

      final response = await http.post(
        Uri.parse(config.fcmEndpoint),
        headers: headers,
        body: json.encode(payload),
      );

      if (response.statusCode != 200) {
        throw Exception('FCM request failed: ${response.statusCode} ${response.body}');
      }

      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (responseData['failure'] == 1) {
        final error = responseData['results']?[0]?['error'];
        throw Exception('FCM send failed: $error');
      }
      
    } catch (e) {
      throw Exception('Failed to send FCM: $e');
    }
  }

  // Track successful message send
  Future<void> _trackMessageSent(String messageId, String userId) async {
    try {
      await _firestore.collection('broadcast_analytics').add({
        'messageId': messageId,
        'userId': userId,
        'event': 'sent',
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Don't throw here, analytics failure shouldn't stop the broadcast
      print('Failed to track message sent: $e');
    }
  }

  // Track failed message send
  Future<void> _trackMessageFailed(String messageId, String userId, String error) async {
    try {
      await _firestore.collection('broadcast_analytics').add({
        'messageId': messageId,
        'userId': userId,
        'event': 'failed',
        'error': error,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Don't throw here, analytics failure shouldn't stop the broadcast
      print('Failed to track message failure: $e');
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
    } catch (e) {e) {
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

  // Process scheduled messages (should be called periodically)
  Future<void> processScheduledMessages() async {
    try {
      final now = DateTime.now();
      
      // Get scheduled messages that are ready to send
      final scheduledQuery = await _broadcastsCollection
          .where('isScheduled', isEqualTo: true)
          .where('status', isEqualTo: BroadcastMessageStatus.pending.name)
          .where('scheduledFor', isLessThanOrEqualTo: now.toIso8601String())
          .get();

      for (final doc in scheduledQuery.docs) {
        try {
          final message = AdminBroadcastMessage.fromJson({
            'id': doc.id,
            ...doc.data(),
          });
          
          // Send the scheduled message
          await sendBroadcastMessage(doc.id);
          
        } catch (e) {
          // Mark message as failed
          await doc.reference.update({
            'status': BroadcastMessageStatus.failed.name,
            'failureReason': 'Scheduled send failed: $e',
          });
        }
      }
    } catch (e) {
      throw Exception('Failed to process scheduled messages: $e');
    }
  }

  // Send messages in batches to avoid overwhelming the system
  Future<void> sendBroadcastMessageInBatches(String messageId, {int batchSize = 100}) async {
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

      // Send in batches
      for (int i = 0; i < targetUsers.length; i += batchSize) {
        final batch = targetUsers.skip(i).take(batchSize).toList();
        
        // Send batch concurrently but with limited concurrency
        final futures = batch.map((user) => _sendFCMNotification(user, message));
        await Future.wait(futures, eagerError: false);
        
        // Small delay between batches to avoid rate limiting
        if (i + batchSize < targetUsers.length) {
          await Future.delayed(const Duration(seconds: 1));
        }
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

  // Track message interaction (open, click, poll response)
  Future<void> trackMessageInteraction(
    String messageId,
    String userId,
    String interactionType, {
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      await _firestore.collection('broadcast_analytics').add({
        'messageId': messageId,
        'userId': userId,
        'event': interactionType, // 'opened', 'clicked', 'poll_response'
        'timestamp': FieldValue.serverTimestamp(),
        if (additionalData != null) ...additionalData,
      });

      // Update message analytics counters
      final updates = <String, dynamic>{};
      
      switch (interactionType) {
        case 'opened':
          updates['openedCount'] = FieldValue.increment(1);
          break;
        case 'clicked':
          updates['clickedCount'] = FieldValue.increment(1);
          break;
        case 'poll_response':
          if (additionalData?['selectedOption'] != null) {
            final option = additionalData!['selectedOption'] as String;
            updates['pollResponses.$option'] = FieldValue.increment(1);
          }
          break;
      }

      if (updates.isNotEmpty) {
        await _broadcastsCollection.doc(messageId).update(updates);
      }
      
    } catch (e) {
      throw Exception('Failed to track message interaction: $e');
    }
  }

  // Get message analytics
  Future<Map<String, dynamic>> getMessageAnalytics(String messageId) async {
    try {
      final analyticsQuery = await _firestore
          .collection('broadcast_analytics')
          .where('messageId', isEqualTo: messageId)
          .get();

      final analytics = <String, dynamic>{
        'totalSent': 0,
        'totalOpened': 0,
        'totalClicked': 0,
        'totalFailed': 0,
        'openRate': 0.0,
        'clickRate': 0.0,
        'pollResponses': <String, int>{},
      };

      for (final doc in analyticsQuery.docs) {
        final data = doc.data();
        final event = data['event'] as String;
        
        switch (event) {
          case 'sent':
            analytics['totalSent'] = (analytics['totalSent'] as int) + 1;
            break;
          case 'opened':
            analytics['totalOpened'] = (analytics['totalOpened'] as int) + 1;
            break;
          case 'clicked':
            analytics['totalClicked'] = (analytics['totalClicked'] as int) + 1;
            break;
          case 'failed':
            analytics['totalFailed'] = (analytics['totalFailed'] as int) + 1;
            break;
          case 'poll_response':
            final option = data['selectedOption'] as String?;
            if (option != null) {
              final responses = analytics['pollResponses'] as Map<String, int>;
              responses[option] = (responses[option] ?? 0) + 1;
            }
            break;
        }
      }

      // Calculate rates
      final totalSent = analytics['totalSent'] as int;
      if (totalSent > 0) {
        analytics['openRate'] = (analytics['totalOpened'] as int) / totalSent;
        analytics['clickRate'] = (analytics['totalClicked'] as int) / totalSent;
      }

      return analytics;
    } catch (e) {
      throw Exception('Failed to get message analytics: $e');
    }
  }
}

// Provider
broadcastServiceProvider = Provider<BroadcastService>((final ref) => BroadcastService());
