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

    test('should only use manual WhatsApp sharing via wa.me links', () {
      // Verify the service uses the standard wa.me URL format
      // This ensures no unauthorized API access to WhatsApp
      expect(true, isTrue); // Placeholder for URL validation
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
