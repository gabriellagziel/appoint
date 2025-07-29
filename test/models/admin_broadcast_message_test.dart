import 'package:appoint/models/admin_broadcast_message.dart';
import 'package:flutter_test/flutter_test.dart';

import '../firebase_test_helper.dart';

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  group('AdminBroadcastMessage', () {
    test('should create message with required fields', () {
      final message = AdminBroadcastMessage(
        id: 'test-id',
        title: 'Test Title',
        content: 'Test Content',
        type: BroadcastMessageType.text,
        targetingFilters: const BroadcastTargetingFilters(),
        createdByAdminId: 'admin-123',
        createdByAdminName: 'Admin User',
        createdAt: DateTime.now(),
        status: BroadcastMessageStatus.pending,
      );

      expect(message.id, equals('test-id'));
      expect(message.title, equals('Test Title'));
      expect(message.content, equals('Test Content'));
      expect(message.type, equals(BroadcastMessageType.text));
      expect(message.createdByAdminId, equals('admin-123'));
      expect(message.status, equals(BroadcastMessageStatus.pending));
    });

    test('should create image message with image URL', () {
      final message = AdminBroadcastMessage(
        id: 'test-id',
        title: 'Test Image',
        content: 'Test Image Content',
        type: BroadcastMessageType.image,
        imageUrl: 'https://example.com/image.jpg',
        targetingFilters: const BroadcastTargetingFilters(),
        createdByAdminId: 'admin-123',
        createdByAdminName: 'Admin User',
        createdAt: DateTime.now(),
        status: BroadcastMessageStatus.pending,
      );

      expect(message.type, equals(BroadcastMessageType.image));
      expect(message.imageUrl, equals('https://example.com/image.jpg'));
    });

    test('should serialize and deserialize correctly', () {
      final original = AdminBroadcastMessage(
        id: 'test-id',
        title: 'Test Title',
        content: 'Test Content',
        type: BroadcastMessageType.text,
        targetingFilters: const BroadcastTargetingFilters(
          countries: ['US', 'CA'],
          userRoles: ['user'],
        ),
        createdByAdminId: 'admin-123',
        createdByAdminName: 'Admin User',
        createdAt: DateTime(2024, 1, 1, 10),
        status: BroadcastMessageStatus.pending,
      );

      json = original.toJson();
      deserialized = AdminBroadcastMessage.fromJson(json);

      expect(deserialized.id, equals(original.id));
      expect(deserialized.title, equals(original.title));
      expect(deserialized.content, equals(original.content));
      expect(deserialized.type, equals(original.type));
      expect(deserialized.createdByAdminId, equals(original.createdByAdminId));
      expect(deserialized.status, equals(original.status));
      expect(deserialized.targetingFilters.countries, equals(['US', 'CA']));
      expect(deserialized.targetingFilters.userRoles, equals(['user']));
    });

    test('should handle different message types', () {
      final textMessage = AdminBroadcastMessage(
        id: 'text-id',
        title: 'Text Message',
        content: 'Text content',
        type: BroadcastMessageType.text,
        targetingFilters: const BroadcastTargetingFilters(),
        createdByAdminId: 'admin-123',
        createdByAdminName: 'Admin User',
        createdAt: DateTime.now(),
        status: BroadcastMessageStatus.pending,
      );

      final imageMessage = AdminBroadcastMessage(
        id: 'image-id',
        title: 'Image Message',
        content: 'Image content',
        type: BroadcastMessageType.image,
        imageUrl: 'https://example.com/image.jpg',
        targetingFilters: const BroadcastTargetingFilters(),
        createdByAdminId: 'admin-123',
        createdByAdminName: 'Admin User',
        createdAt: DateTime.now(),
        status: BroadcastMessageStatus.pending,
      );

      expect(textMessage.type, equals(BroadcastMessageType.text));
      expect(imageMessage.type, equals(BroadcastMessageType.image));
      expect(imageMessage.imageUrl, isNotNull);
      expect(textMessage.imageUrl, isNull);
    });

    test('should handle different statuses', () {
      final pendingMessage = AdminBroadcastMessage(
        id: 'pending-id',
        title: 'Pending Message',
        content: 'Pending content',
        type: BroadcastMessageType.text,
        targetingFilters: const BroadcastTargetingFilters(),
        createdByAdminId: 'admin-123',
        createdByAdminName: 'Admin User',
        createdAt: DateTime.now(),
        status: BroadcastMessageStatus.pending,
      );

      final sentMessage = AdminBroadcastMessage(
        id: 'sent-id',
        title: 'Sent Message',
        content: 'Sent content',
        type: BroadcastMessageType.text,
        targetingFilters: const BroadcastTargetingFilters(),
        createdByAdminId: 'admin-123',
        createdByAdminName: 'Admin User',
        createdAt: DateTime.now(),
        status: BroadcastMessageStatus.sent,
      );

      expect(pendingMessage.status, equals(BroadcastMessageStatus.pending));
      expect(sentMessage.status, equals(BroadcastMessageStatus.sent));
    });

    test('should handle targeting filters', () {
      const filters = BroadcastTargetingFilters(
        countries: ['US', 'CA'],
        cities: ['New York', 'Toronto'],
        minAge: 18,
        maxAge: 65,
        userRoles: ['user', 'premium'],
        subscriptionTiers: ['basic', 'premium'],
        accountStatuses: ['active'],
      );

      final message = AdminBroadcastMessage(
        id: 'targeted-id',
        title: 'Targeted Message',
        content: 'Targeted content',
        type: BroadcastMessageType.text,
        targetingFilters: filters,
        createdByAdminId: 'admin-123',
        createdByAdminName: 'Admin User',
        createdAt: DateTime.now(),
        status: BroadcastMessageStatus.pending,
      );

      expect(message.targetingFilters.countries, equals(['US', 'CA']));
      expect(message.targetingFilters.cities, equals(['New York', 'Toronto']));
      expect(message.targetingFilters.minAge, equals(18));
      expect(message.targetingFilters.maxAge, equals(65));
      expect(message.targetingFilters.userRoles, equals(['user', 'premium']));
      expect(
        message.targetingFilters.subscriptionTiers,
        equals(['basic', 'premium']),
      );
      expect(message.targetingFilters.accountStatuses, equals(['active']));
    });

    test('should handle optional fields', () {
      final message = AdminBroadcastMessage(
        id: 'optional-id',
        title: 'Optional Fields',
        content: 'Optional content',
        type: BroadcastMessageType.text,
        targetingFilters: const BroadcastTargetingFilters(),
        createdByAdminId: 'admin-123',
        createdByAdminName: 'Admin User',
        createdAt: DateTime.now(),
        status: BroadcastMessageStatus.pending,
        scheduledFor: DateTime(2024, 1, 2, 10),
        actualRecipients: 1000,
        openedCount: 500,
        clickedCount: 100,
      );

      expect(message.scheduledFor, isNotNull);
      expect(message.actualRecipients, equals(1000));
      expect(message.openedCount, equals(500));
      expect(message.clickedCount, equals(100));
    });

    test('should handle empty targeting filters', () {
      const emptyFilters = BroadcastTargetingFilters();
      final message = AdminBroadcastMessage(
        id: 'empty-filters-id',
        title: 'Empty Filters',
        content: 'Empty filters content',
        type: BroadcastMessageType.text,
        targetingFilters: emptyFilters,
        createdByAdminId: 'admin-123',
        createdByAdminName: 'Admin User',
        createdAt: DateTime.now(),
        status: BroadcastMessageStatus.pending,
      );

      expect(message.targetingFilters.countries, isNull);
      expect(message.targetingFilters.cities, isNull);
      expect(message.targetingFilters.userRoles, isNull);
      expect(message.targetingFilters.subscriptionTiers, isNull);
      expect(message.targetingFilters.accountStatuses, isNull);
      expect(message.targetingFilters.minAge, isNull);
      expect(message.targetingFilters.maxAge, isNull);
    });
  });
}
