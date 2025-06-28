import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/models/admin_broadcast_message.dart';
import '../fake_firebase_setup.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await initializeTestFirebase();

  group('AdminBroadcastMessage Model', () {
    test('should correctly create a text broadcast message', () {
      final targetingFilters = BroadcastTargetingFilters(
        countries: ['US', 'CA'],
        cities: ['New York', 'Toronto'],
        minAge: 18,
        maxAge: 65,
        subscriptionTiers: ['premium', 'basic'],
        accountTypes: ['personal', 'business'],
        languages: ['en', 'es'],
        accountStatuses: ['active'],
        userRoles: ['user', 'admin'],
      );

      final message = AdminBroadcastMessage(
        id: 'broadcast-123',
        title: 'Important Announcement',
        content: 'This is a test broadcast message',
        type: BroadcastMessageType.text,
        targetingFilters: targetingFilters,
        createdByAdminId: 'admin-123',
        createdByAdminName: 'Admin User',
        createdAt: DateTime(2025, 6, 18, 10, 0),
        status: BroadcastMessageStatus.pending,
      );

      expect(message.id, 'broadcast-123');
      expect(message.title, 'Important Announcement');
      expect(message.content, 'This is a test broadcast message');
      expect(message.type, BroadcastMessageType.text);
      expect(message.status, BroadcastMessageStatus.pending);
      expect(message.createdByAdminId, 'admin-123');
      expect(message.createdByAdminName, 'Admin User');
      expect(message.targetingFilters.countries, ['US', 'CA']);
      expect(message.targetingFilters.minAge, 18);
      expect(message.targetingFilters.maxAge, 65);
    });

    test('should correctly create an image broadcast message', () {
      final targetingFilters = BroadcastTargetingFilters(
        countries: ['US'],
        userRoles: ['user'],
      );

      final message = AdminBroadcastMessage(
        id: 'broadcast-456',
        title: 'New Feature Image',
        content: 'Check out our new feature!',
        type: BroadcastMessageType.image,
        imageUrl: 'https://example.com/image.jpg',
        targetingFilters: targetingFilters,
        createdByAdminId: 'admin-123',
        createdByAdminName: 'Admin User',
        createdAt: DateTime(2025, 6, 18, 10, 0),
        status: BroadcastMessageStatus.sent,
        estimatedRecipients: 1000,
        actualRecipients: 950,
        openedCount: 500,
        clickedCount: 100,
      );

      expect(message.type, BroadcastMessageType.image);
      expect(message.imageUrl, 'https://example.com/image.jpg');
      expect(message.status, BroadcastMessageStatus.sent);
      expect(message.estimatedRecipients, 1000);
      expect(message.actualRecipients, 950);
      expect(message.openedCount, 500);
      expect(message.clickedCount, 100);
    });

    test('should correctly create a poll broadcast message', () {
      final targetingFilters = BroadcastTargetingFilters(
        userRoles: ['user'],
      );

      final message = AdminBroadcastMessage(
        id: 'broadcast-789',
        title: 'User Feedback Poll',
        content: 'What feature would you like to see next?',
        type: BroadcastMessageType.poll,
        pollOptions: ['Feature A', 'Feature B', 'Feature C'],
        targetingFilters: targetingFilters,
        createdByAdminId: 'admin-123',
        createdByAdminName: 'Admin User',
        createdAt: DateTime(2025, 6, 18, 10, 0),
        status: BroadcastMessageStatus.pending,
        pollResponses: {
          'Feature A': 45,
          'Feature B': 30,
          'Feature C': 25,
        },
      );

      expect(message.type, BroadcastMessageType.poll);
      expect(message.pollOptions, ['Feature A', 'Feature B', 'Feature C']);
      expect(message.pollResponses, {
        'Feature A': 45,
        'Feature B': 30,
        'Feature C': 25,
      });
    });

    test('should be able to convert to JSON and back', () {
      final targetingFilters = BroadcastTargetingFilters(
        countries: ['US'],
        userRoles: ['user'],
      );

      final message = AdminBroadcastMessage(
        id: 'broadcast-123',
        title: 'Test Message',
        content: 'Test content',
        type: BroadcastMessageType.text,
        targetingFilters: targetingFilters,
        createdByAdminId: 'admin-123',
        createdByAdminName: 'Admin User',
        createdAt: DateTime(2025, 6, 18, 10, 0),
        status: BroadcastMessageStatus.pending,
      );

      final json = message.toJson();
      final newMessage = AdminBroadcastMessage.fromJson(json);

      expect(newMessage.id, message.id);
      expect(newMessage.title, message.title);
      expect(newMessage.content, message.content);
      expect(newMessage.type, message.type);
      expect(newMessage.status, message.status);
      expect(newMessage.createdByAdminId, message.createdByAdminId);
      expect(newMessage.createdByAdminName, message.createdByAdminName);
    });

    test('should handle scheduled broadcast messages', () {
      final targetingFilters = BroadcastTargetingFilters(
        userRoles: ['user'],
      );

      final message = AdminBroadcastMessage(
        id: 'broadcast-123',
        title: 'Scheduled Message',
        content: 'This message is scheduled',
        type: BroadcastMessageType.text,
        targetingFilters: targetingFilters,
        createdByAdminId: 'admin-123',
        createdByAdminName: 'Admin User',
        createdAt: DateTime(2025, 6, 18, 10, 0),
        scheduledFor: DateTime(2025, 6, 19, 10, 0),
        status: BroadcastMessageStatus.pending,
      );

      expect(message.scheduledFor, DateTime(2025, 6, 19, 10, 0));
    });

    test('should handle failed broadcast messages', () {
      final targetingFilters = BroadcastTargetingFilters(
        userRoles: ['user'],
      );

      final message = AdminBroadcastMessage(
        id: 'broadcast-123',
        title: 'Failed Message',
        content: 'This message failed to send',
        type: BroadcastMessageType.text,
        targetingFilters: targetingFilters,
        createdByAdminId: 'admin-123',
        createdByAdminName: 'Admin User',
        createdAt: DateTime(2025, 6, 18, 10, 0),
        status: BroadcastMessageStatus.failed,
        failureReason: 'Network error',
        failedRecipients: ['user-1', 'user-2'],
      );

      expect(message.status, BroadcastMessageStatus.failed);
      expect(message.failureReason, 'Network error');
      expect(message.failedRecipients, ['user-1', 'user-2']);
    });

    test('should handle different broadcast message types', () {
      final targetingFilters = BroadcastTargetingFilters(
        userRoles: ['user'],
      );

      final textMessage = AdminBroadcastMessage(
        id: 'broadcast-1',
        title: 'Text Message',
        content: 'Text content',
        type: BroadcastMessageType.text,
        targetingFilters: targetingFilters,
        createdByAdminId: 'admin-123',
        createdByAdminName: 'Admin User',
        createdAt: DateTime(2025, 6, 18, 10, 0),
        status: BroadcastMessageStatus.pending,
      );

      final imageMessage = AdminBroadcastMessage(
        id: 'broadcast-2',
        title: 'Image Message',
        content: 'Image content',
        type: BroadcastMessageType.image,
        imageUrl: 'https://example.com/image.jpg',
        targetingFilters: targetingFilters,
        createdByAdminId: 'admin-123',
        createdByAdminName: 'Admin User',
        createdAt: DateTime(2025, 6, 18, 10, 0),
        status: BroadcastMessageStatus.pending,
      );

      final videoMessage = AdminBroadcastMessage(
        id: 'broadcast-3',
        title: 'Video Message',
        content: 'Video content',
        type: BroadcastMessageType.video,
        videoUrl: 'https://example.com/video.mp4',
        targetingFilters: targetingFilters,
        createdByAdminId: 'admin-123',
        createdByAdminName: 'Admin User',
        createdAt: DateTime(2025, 6, 18, 10, 0),
        status: BroadcastMessageStatus.pending,
      );

      final linkMessage = AdminBroadcastMessage(
        id: 'broadcast-4',
        title: 'Link Message',
        content: 'Link content',
        type: BroadcastMessageType.link,
        externalLink: 'https://example.com',
        targetingFilters: targetingFilters,
        createdByAdminId: 'admin-123',
        createdByAdminName: 'Admin User',
        createdAt: DateTime(2025, 6, 18, 10, 0),
        status: BroadcastMessageStatus.pending,
      );

      expect(textMessage.type, BroadcastMessageType.text);
      expect(imageMessage.type, BroadcastMessageType.image);
      expect(videoMessage.type, BroadcastMessageType.video);
      expect(linkMessage.type, BroadcastMessageType.link);
    });
  });
}
