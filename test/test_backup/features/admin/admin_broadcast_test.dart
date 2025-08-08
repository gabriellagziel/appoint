import 'package:appoint/models/admin_broadcast_message.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../firebase_test_helper.dart';

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  group('Admin Broadcast System Tests', () {
    group('BroadcastMessage Model Tests', () {
      test('should create broadcast message with all required fields', () {
        final message = AdminBroadcastMessage(
          id: 'test-id',
          title: 'Test Message',
          content: 'Test content',
          type: BroadcastMessageType.text,
          targetingFilters: const BroadcastTargetingFilters(),
          createdByAdminId: 'admin-id',
          createdByAdminName: 'Admin User',
          createdAt: DateTime.now(),
          status: BroadcastMessageStatus.pending,
        );

        expect(message.id, 'test-id');
        expect(message.title, 'Test Message');
        expect(message.content, 'Test content');
        expect(message.type, BroadcastMessageType.text);
        expect(message.status, BroadcastMessageStatus.pending);
      });

      test('should create broadcast message with targeting filters', () {
        const filters = BroadcastTargetingFilters(
          countries: ['US', 'CA'],
          cities: ['New York', 'Toronto'],
          subscriptionTiers: ['premium', 'business'],
          userRoles: ['client', 'business'],
        );

        final message = AdminBroadcastMessage(
          id: 'test-id',
          title: 'Test Message',
          content: 'Test content',
          type: BroadcastMessageType.text,
          targetingFilters: filters,
          createdByAdminId: 'admin-id',
          createdByAdminName: 'Admin User',
          createdAt: DateTime.now(),
          status: BroadcastMessageStatus.pending,
        );

        expect(message.targetingFilters.countries, ['US', 'CA']);
        expect(message.targetingFilters.cities, ['New York', 'Toronto']);
        expect(
          message.targetingFilters.subscriptionTiers,
          ['premium', 'business'],
        );
        expect(message.targetingFilters.userRoles, ['client', 'business']);
      });

      test('should create poll message with options', () {
        final message = AdminBroadcastMessage(
          id: 'test-id',
          title: 'Test Poll',
          content: 'What is your favorite color?',
          type: BroadcastMessageType.poll,
          pollOptions: ['Red', 'Blue', 'Green', 'Yellow'],
          targetingFilters: const BroadcastTargetingFilters(),
          createdByAdminId: 'admin-id',
          createdByAdminName: 'Admin User',
          createdAt: DateTime.now(),
          status: BroadcastMessageStatus.pending,
        );

        expect(message.type, BroadcastMessageType.poll);
        expect(message.pollOptions, ['Red', 'Blue', 'Green', 'Yellow']);
      });

      test('should handle different message types', () {
        final textMessage = AdminBroadcastMessage(
          id: '1',
          title: 'Text Message',
          content: 'Text content',
          type: BroadcastMessageType.text,
          targetingFilters: const BroadcastTargetingFilters(),
          createdByAdminId: 'admin-id',
          createdByAdminName: 'Admin User',
          createdAt: DateTime.now(),
          status: BroadcastMessageStatus.pending,
        );

        final imageMessage = AdminBroadcastMessage(
          id: '2',
          title: 'Image Message',
          content: 'Image content',
          type: BroadcastMessageType.image,
          imageUrl: 'https://example.com/image.jpg',
          targetingFilters: const BroadcastTargetingFilters(),
          createdByAdminId: 'admin-id',
          createdByAdminName: 'Admin User',
          createdAt: DateTime.now(),
          status: BroadcastMessageStatus.pending,
        );

        final linkMessage = AdminBroadcastMessage(
          id: '3',
          title: 'Link Message',
          content: 'Link content',
          type: BroadcastMessageType.link,
          externalLink: 'https://example.com',
          targetingFilters: const BroadcastTargetingFilters(),
          createdByAdminId: 'admin-id',
          createdByAdminName: 'Admin User',
          createdAt: DateTime.now(),
          status: BroadcastMessageStatus.pending,
        );

        expect(textMessage.type, BroadcastMessageType.text);
        expect(imageMessage.type, BroadcastMessageType.image);
        expect(imageMessage.imageUrl, 'https://example.com/image.jpg');
        expect(linkMessage.type, BroadcastMessageType.link);
        expect(linkMessage.externalLink, 'https://example.com');
      });
    });

    group('BroadcastTargetingFilters Tests', () {
      test('should create filters with all properties', () {
        final filters = BroadcastTargetingFilters(
          countries: ['US', 'CA'],
          cities: ['New York', 'Toronto'],
          minAge: 18,
          maxAge: 65,
          subscriptionTiers: ['premium', 'business'],
          accountTypes: ['individual', 'corporate'],
          languages: ['en', 'es'],
          accountStatuses: ['active', 'verified'],
          joinedAfter: DateTime(2023),
          joinedBefore: DateTime(2024),
          userRoles: ['client', 'business'],
        );

        expect(filters.countries, ['US', 'CA']);
        expect(filters.cities, ['New York', 'Toronto']);
        expect(filters.minAge, 18);
        expect(filters.maxAge, 65);
        expect(filters.subscriptionTiers, ['premium', 'business']);
        expect(filters.accountTypes, ['individual', 'corporate']);
        expect(filters.languages, ['en', 'es']);
        expect(filters.accountStatuses, ['active', 'verified']);
        expect(filters.joinedAfter, DateTime(2023));
        expect(filters.joinedBefore, DateTime(2024));
        expect(filters.userRoles, ['client', 'business']);
      });

      test('should handle empty filters', () {
        const filters = BroadcastTargetingFilters();

        expect(filters.countries, isNull);
        expect(filters.cities, isNull);
        expect(filters.minAge, isNull);
        expect(filters.maxAge, isNull);
        expect(filters.subscriptionTiers, isNull);
        expect(filters.accountTypes, isNull);
        expect(filters.languages, isNull);
        expect(filters.accountStatuses, isNull);
        expect(filters.joinedAfter, isNull);
        expect(filters.joinedBefore, isNull);
        expect(filters.userRoles, isNull);
      });
    });

    group('BroadcastMessageStatus Tests', () {
      test('should have correct enum values', () {
        expect(BroadcastMessageStatus.pending, BroadcastMessageStatus.pending);
        expect(BroadcastMessageStatus.sent, BroadcastMessageStatus.sent);
        expect(BroadcastMessageStatus.failed, BroadcastMessageStatus.failed);
      });

      test('should convert to string correctly', () {
        expect(BroadcastMessageStatus.pending.name, 'pending');
        expect(BroadcastMessageStatus.sent.name, 'sent');
        expect(BroadcastMessageStatus.failed.name, 'failed');
      });
    });

    group('BroadcastMessageType Tests', () {
      test('should have correct enum values', () {
        expect(BroadcastMessageType.text, BroadcastMessageType.text);
        expect(BroadcastMessageType.image, BroadcastMessageType.image);
        expect(BroadcastMessageType.video, BroadcastMessageType.video);
        expect(BroadcastMessageType.poll, BroadcastMessageType.poll);
        expect(BroadcastMessageType.link, BroadcastMessageType.link);
      });

      test('should convert to string correctly', () {
        expect(BroadcastMessageType.text.name, 'text');
        expect(BroadcastMessageType.image.name, 'image');
        expect(BroadcastMessageType.video.name, 'video');
        expect(BroadcastMessageType.poll.name, 'poll');
        expect(BroadcastMessageType.link.name, 'link');
      });
    });
  });
}
