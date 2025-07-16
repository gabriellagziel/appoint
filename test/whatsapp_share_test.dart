import 'package:appoint/models/smart_share_link.dart';
import 'package:appoint/services/whatsapp_share_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'firebase_test_helper.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockFirebaseAnalytics extends Mock implements FirebaseAnalytics {}

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  group('WhatsApp Share Service Tests', () {
    late WhatsAppShareService service;
    late MockFirebaseFirestore mockFirestore;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      service = WhatsAppShareService(firestore: mockFirestore);
    });

    test('should instantiate WhatsAppShareService', () {
      expect(service, isNotNull);
      expect(service.generateSmartShareLink, isA<Function>());
      expect(service.shareToWhatsApp, isA<Function>());
      expect(service.recognizeGroup, isA<Function>());
    });

    test('should create ShareAnalytics with correct data', () {
      final analytics = ShareAnalytics(
        meetingId: 'test-meeting',
        channel: 'whatsapp',
        sharedAt: DateTime.now(),
        groupId: 'test-group',
        recipientId: 'test-recipient',
        status: ShareStatus.shared,
      );

      expect(analytics.meetingId, equals('test-meeting'));
      expect(analytics.channel, equals('whatsapp'));
      expect(analytics.groupId, equals('test-group'));
      expect(analytics.status, equals(ShareStatus.shared));
    });

    test('should create GroupRecognition with correct data', () {
      final group = GroupRecognition(
        groupId: 'test-group',
        groupName: 'Test Group',
        phoneNumber: '+1234567890',
        firstSharedAt: DateTime.now(),
        totalShares: 5,
        totalResponses: 2,
        lastSharedAt: DateTime.now(),
      );

      expect(group.groupId, equals('test-group'));
      expect(group.groupName, equals('Test Group'));
      expect(group.phoneNumber, equals('+1234567890'));
      expect(group.totalShares, equals(5));
      expect(group.totalResponses, equals(2));
    });

    test('should create SmartShareLink with correct data', () {
      final link = SmartShareLink(
        meetingId: 'test-meeting',
        creatorId: 'test-creator',
        contextId: 'test-context',
        groupId: 'test-group',
        createdAt: DateTime.now(),
        shareChannel: 'whatsapp',
      );

      expect(link.meetingId, equals('test-meeting'));
      expect(link.creatorId, equals('test-creator'));
      expect(link.contextId, equals('test-context'));
      expect(link.groupId, equals('test-group'));
      expect(link.shareChannel, equals('whatsapp'));
    });
  });

  group('Share Status Enum Tests', () {
    test('should have correct enum values', () {
      expect(ShareStatus.values.length, equals(5));
      expect(ShareStatus.values, contains(ShareStatus.shared));
      expect(ShareStatus.values, contains(ShareStatus.clicked));
      expect(ShareStatus.values, contains(ShareStatus.responded));
      expect(ShareStatus.values, contains(ShareStatus.confirmed));
      expect(ShareStatus.values, contains(ShareStatus.declined));
    });
  });
}
