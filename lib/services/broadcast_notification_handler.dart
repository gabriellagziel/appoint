import 'dart:convert';
import 'package:appoint/services/broadcast_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

/// Handles broadcast notification reception and user interactions
class BroadcastNotificationHandler {
  BroadcastNotificationHandler._();
  static final BroadcastNotificationHandler _instance =
      BroadcastNotificationHandler._();
  static BroadcastNotificationHandler get instance => _instance;

  late final BroadcastService _broadcastService;

  /// Initialize the handler with broadcast service
  void initialize(BroadcastService broadcastService) {
    _broadcastService = broadcastService;
  }

  /// Handle incoming broadcast message when app is in foreground
  Future<void> handleForegroundMessage(RemoteMessage message) async {
    try {
      await _trackMessageReceived(message);
      await _showInAppNotification(message);
    } catch (e) {
      print('Error handling foreground message: $e');
    }
  }

  /// Handle notification tap when app is opened from notification
  Future<void> handleNotificationTap(RemoteMessage message) async {
    try {
      await _trackMessageOpened(message);
      await _handleMessageAction(message);
    } catch (e) {
      print('Error handling notification tap: $e');
    }
  }

  /// Handle background message
  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    try {
      await _trackMessageReceived(message);
    } catch (e) {
      print('Error handling background message: $e');
    }
  }

  /// Track that message was received
  Future<void> _trackMessageReceived(RemoteMessage message) async {
    final messageId = message.data['messageId'];
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (messageId != null && userId != null) {
      try {
        await _broadcastService.trackMessageInteraction(
          messageId,
          userId,
          'received',
        );
      } catch (e) {
        print('Failed to track message received: $e');
      }
    }
  }

  /// Track that message was opened
  Future<void> _trackMessageOpened(RemoteMessage message) async {
    final messageId = message.data['messageId'];
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (messageId != null && userId != null) {
      try {
        await _broadcastService.trackMessageInteraction(
          messageId,
          userId,
          'opened',
        );
      } catch (e) {
        print('Failed to track message opened: $e');
      }
    }
  }

  /// Track message click/interaction
  Future<void> _trackMessageClicked(String messageId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      try {
        await _broadcastService.trackMessageInteraction(
          messageId,
          userId,
          'clicked',
        );
      } catch (e) {
        print('Failed to track message clicked: $e');
      }
    }
  }

  /// Track poll response
  Future<void> trackPollResponse(
      String messageId, String selectedOption) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      try {
        await _broadcastService.trackMessageInteraction(
          messageId,
          userId,
          'poll_response',
          additionalData: {'selectedOption': selectedOption},
        );
      } catch (e) {
        print('Failed to track poll response: $e');
      }
    }
  }

  /// Show in-app notification for foreground messages
  Future<void> _showInAppNotification(RemoteMessage message) async {
    // This would show a snackbar or custom notification widget
    // Implementation depends on your app's navigation system
    print('Showing in-app notification: ${message.notification?.title}');
  }

  /// Handle message-specific actions based on type
  Future<void> _handleMessageAction(RemoteMessage message) async {
    final messageType = message.data['type'];
    final messageId = message.data['messageId'];

    if (messageId != null) {
      await _trackMessageClicked(messageId);
    }

    switch (messageType) {
      case 'link':
        await _handleLinkMessage(message);
      case 'poll':
        await _handlePollMessage(message);
      case 'image':
        await _handleImageMessage(message);
      case 'video':
        await _handleVideoMessage(message);
      default:
        await _handleTextMessage(message);
    }
  }

  /// Handle link message by opening the external link
  Future<void> _handleLinkMessage(RemoteMessage message) async {
    final link = message.data['externalLink'];
    if (link != null) {
      try {
        await launchUrl(Uri.parse(link));
      } catch (e) {
        print('Failed to launch URL: $e');
      }
    }
  }

  /// Handle poll message by showing poll UI
  Future<void> _handlePollMessage(RemoteMessage message) async {
    final pollOptionsJson = message.data['pollOptions'];
    if (pollOptionsJson != null) {
      try {
        final pollOptions = List<String>.from(json.decode(pollOptionsJson));
        // Show poll dialog - implementation depends on your UI framework
        await _showPollDialog(message.data['messageId'], pollOptions);
      } catch (e) {
        print('Failed to parse poll options: $e');
      }
    }
  }

  /// Handle image message by showing image viewer
  Future<void> _handleImageMessage(RemoteMessage message) async {
    final imageUrl = message.data['imageUrl'];
    if (imageUrl != null) {
      // Show image viewer - implementation depends on your UI framework
      print('Showing image: $imageUrl');
    }
  }

  /// Handle video message by opening video player
  Future<void> _handleVideoMessage(RemoteMessage message) async {
    final videoUrl = message.data['videoUrl'];
    if (videoUrl != null) {
      // Open video player - implementation depends on your UI framework
      print('Playing video: $videoUrl');
    }
  }

  /// Handle text message (default case)
  Future<void> _handleTextMessage(RemoteMessage message) async {
    // Just show the message content
    print('Text message: ${message.notification?.body}');
  }

  /// Show poll dialog (placeholder - needs UI implementation)
  Future<void> _showPollDialog(String? messageId, List<String> options) async {
    // This would show a dialog with poll options
    // When user selects an option, call trackPollResponse
    print('Poll options: $options');

    // Example of tracking a poll response (you'd do this when user actually selects)
    // await trackPollResponse(messageId!, options.first);
  }

  /// Create a broadcast message widget for in-app display
  Widget createBroadcastMessageWidget({
    required RemoteMessage message,
    required VoidCallback onTap,
  }) {
    final title = message.notification?.title ?? 'New Message';
    final body = message.notification?.body ?? '';
    final messageType = message.data['type'] ?? 'text';

    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: _getMessageIcon(messageType),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(body),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          onTap();
          _handleMessageAction(message);
        },
      ),
    );
  }

  /// Get appropriate icon for message type
  Widget _getMessageIcon(String messageType) {
    switch (messageType) {
      case 'image':
        return const Icon(Icons.image, color: Colors.blue);
      case 'video':
        return const Icon(Icons.videocam, color: Colors.red);
      case 'poll':
        return const Icon(Icons.poll, color: Colors.green);
      case 'link':
        return const Icon(Icons.link, color: Colors.orange);
      default:
        return const Icon(Icons.message, color: Colors.grey);
    }
  }
}

/// Provider for the broadcast notification handler
final broadcastNotificationHandlerProvider =
    Provider<BroadcastNotificationHandler>(
  (ref) {
    final handler = BroadcastNotificationHandler.instance;
    final broadcastService = ref.read(adminBroadcastServiceProvider);
    handler.initialize(broadcastService);
    return handler;
  },
);
