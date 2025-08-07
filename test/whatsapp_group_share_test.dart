import 'package:appoint/models/invite.dart';
import 'package:appoint/services/whatsapp_group_share_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'firebase_test_helper.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockFirebaseAnalytics extends Mock implements FirebaseAnalytics {}
class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}
class MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  group('WhatsApp Group Share Service Tests', () {
    late WhatsAppGroupShareService service;
    late MockFirebaseFirestore mockFirestore;
    late MockFirebaseAnalytics mockAnalytics;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockAnalytics = MockFirebaseAnalytics();
      service = WhatsAppGroupShareService(
        firestore: mockFirestore,
        analytics: mockAnalytics,
      );
    });

    test('should generate unique share links', () async {
      // Mock Firestore collection
      final mockCollection = MockCollectionReference();
      final mockDoc = MockDocumentReference();
      
      when(() => mockFirestore.collection('whatsapp_shares'))
          .thenReturn(mockCollection);
      when(() => mockCollection.add(any()))
          .thenAnswer((_) async => mockDoc);

      final shareUrl = await service.generateGroupShareLink(
        appointmentId: 'test-appointment',
        creatorId: 'test-creator',
        meetingTitle: 'Test Meeting',
        meetingDate: DateTime.now(),
      );

      expect(shareUrl, contains('test-appointment'));
      expect(shareUrl, contains('test-creator'));
      expect(shareUrl, contains('source=whatsapp_group'));
      expect(shareUrl, contains('group_share=1'));
      expect(shareUrl, contains('shareId='));
    });

    test('should generate different share IDs for multiple calls', () async {
      // Mock Firestore
      final mockCollection = MockCollectionReference();
      final mockDoc = MockDocumentReference();
      
      when(() => mockFirestore.collection('whatsapp_shares'))
          .thenReturn(mockCollection);
      when(() => mockCollection.add(any()))
          .thenAnswer((_) async => mockDoc);

      final shareUrl1 = await service.generateGroupShareLink(
        appointmentId: 'test-appointment-1',
        creatorId: 'test-creator',
      );

      final shareUrl2 = await service.generateGroupShareLink(
        appointmentId: 'test-appointment-2',
        creatorId: 'test-creator',
      );

      // Extract shareId from URLs
      final shareId1 = Uri.parse(shareUrl1).queryParameters['shareId'];
      final shareId2 = Uri.parse(shareUrl2).queryParameters['shareId'];

      expect(shareId1, isNotNull);
      expect(shareId2, isNotNull);
      expect(shareId1, isNot(equals(shareId2)));
      expect(shareId1?.length, equals(12));
      expect(shareId2?.length, equals(12));
    });

    test('should track link clicks', () async {
      final mockCollection = MockCollectionReference();
      final mockDoc = MockDocumentReference();
      
      when(() => mockFirestore.collection('share_clicks'))
          .thenReturn(mockCollection);
      when(() => mockCollection.add(any()))
          .thenAnswer((_) async => mockDoc);
      when(() => mockAnalytics.logEvent(
            name: any(named: 'name'),
            parameters: any(named: 'parameters'),
          )).thenAnswer((_) async {});

      await service.trackLinkClick(
        shareId: 'test-share-id',
        appointmentId: 'test-appointment',
        userAgent: 'test-agent',
      );

      verify(() => mockCollection.add({
        'shareId': 'test-share-id',
        'appointmentId': 'test-appointment',
        'clickedAt': any(named: 'clickedAt'),
        'userAgent': 'test-agent',
        'source': InviteSource.whatsapp_group.name,
      })).called(1);

      verify(() => mockAnalytics.logEvent(
        name: 'share_link_clicked',
        parameters: {
          'share_id': 'test-share-id',
          'appointment_id': 'test-appointment',
          'source': InviteSource.whatsapp_group.name,
        },
      )).called(1);
    });

    test('should track participant joins', () async {
      final mockCollection = MockCollectionReference();
      final mockDoc = MockDocumentReference();
      
      when(() => mockFirestore.collection('share_conversions'))
          .thenReturn(mockCollection);
      when(() => mockCollection.add(any()))
          .thenAnswer((_) async => mockDoc);
      when(() => mockAnalytics.logEvent(
            name: any(named: 'name'),
            parameters: any(named: 'parameters'),
          )).thenAnswer((_) async {});

      await service.trackParticipantJoined(
        shareId: 'test-share-id',
        appointmentId: 'test-appointment',
        participantId: 'test-participant',
      );

      verify(() => mockCollection.add({
        'shareId': 'test-share-id',
        'appointmentId': 'test-appointment',
        'participantId': 'test-participant',
        'joinedAt': any(named: 'joinedAt'),
        'source': InviteSource.whatsapp_group.name,
      })).called(1);

      verify(() => mockAnalytics.logEvent(
        name: 'participant_joined_via_share',
        parameters: {
          'share_id': 'test-share-id',
          'appointment_id': 'test-appointment',
          'participant_id': 'test-participant',
          'source': InviteSource.whatsapp_group.name,
        },
      )).called(1);
    });

    test('should handle errors gracefully in link generation', () async {
      when(() => mockFirestore.collection('whatsapp_shares'))
          .thenThrow(Exception('Firestore error'));

      expect(
        () => service.generateGroupShareLink(
          appointmentId: 'test-appointment',
          creatorId: 'test-creator',
        ),
        throwsException,
      );
    });

    test('should handle errors gracefully in tracking', () async {
      when(() => mockFirestore.collection('share_clicks'))
          .thenThrow(Exception('Firestore error'));

      // Should not throw, should handle gracefully
      await service.trackLinkClick(
        shareId: 'test-share-id',
        appointmentId: 'test-appointment',
      );

      // Verify error handling (method completes without throwing)
      expect(true, isTrue);
    });
  });

  group('InviteSource Enum Tests', () {
    test('should have correct enum values', () {
      expect(InviteSource.values.length, equals(5));
      expect(InviteSource.values, contains(InviteSource.direct_invite));
      expect(InviteSource.values, contains(InviteSource.whatsapp_group));
      expect(InviteSource.values, contains(InviteSource.email));
      expect(InviteSource.values, contains(InviteSource.sms));
      expect(InviteSource.values, contains(InviteSource.other));
    });

    test('should have correct enum names', () {
      expect(InviteSource.direct_invite.name, equals('direct_invite'));
      expect(InviteSource.whatsapp_group.name, equals('whatsapp_group'));
      expect(InviteSource.email.name, equals('email'));
      expect(InviteSource.sms.name, equals('sms'));
      expect(InviteSource.other.name, equals('other'));
    });
  });

  group('Enhanced Invite Model Tests', () {
    test('should create invite with source tracking', () {
      final invite = Invite(
        id: 'test-invite',
        appointmentId: 'test-appointment',
        inviteeId: 'test-invitee',
        status: InviteStatus.pending,
        requiresInstallFallback: false,
        source: InviteSource.whatsapp_group,
        shareId: 'test-share-id',
      );

      expect(invite.id, equals('test-invite'));
      expect(invite.source, equals(InviteSource.whatsapp_group));
      expect(invite.shareId, equals('test-share-id'));
    });

    test('should create invite with default source', () {
      final invite = Invite(
        id: 'test-invite',
        appointmentId: 'test-appointment',
        inviteeId: 'test-invitee',
        status: InviteStatus.pending,
        requiresInstallFallback: false,
      );

      expect(invite.source, equals(InviteSource.direct_invite));
      expect(invite.shareId, isNull);
    });
  });

  group('Share Link URL Parsing Tests', () {
    test('should generate proper URL structure', () async {
      final mockCollection = MockCollectionReference();
      final mockDoc = MockDocumentReference();
      
      when(() => mockFirestore.collection('whatsapp_shares'))
          .thenReturn(mockCollection);
      when(() => mockCollection.add(any()))
          .thenAnswer((_) async => mockDoc);

      final service = WhatsAppGroupShareService(firestore: mockFirestore);
      final shareUrl = await service.generateGroupShareLink(
        appointmentId: 'test-appointment-123',
        creatorId: 'creator-456',
        meetingTitle: 'Test Meeting',
        meetingDate: DateTime(2024, 12, 25, 14, 30),
      );

      final uri = Uri.parse(shareUrl);
      
      expect(uri.host, equals('app-oint-core.web.app'));
      expect(uri.path, equals('/invite/test-appointment-123'));
      expect(uri.queryParameters['creatorId'], equals('creator-456'));
      expect(uri.queryParameters['source'], equals('whatsapp_group'));
      expect(uri.queryParameters['group_share'], equals('1'));
      expect(uri.queryParameters['shareId'], isNotNull);
      expect(uri.queryParameters['shareId']?.length, equals(12));
    });

    test('should handle special characters in meeting title', () async {
      final mockCollection = MockCollectionReference();
      final mockDoc = MockDocumentReference();
      
      when(() => mockFirestore.collection('whatsapp_shares'))
          .thenReturn(mockCollection);
      when(() => mockCollection.add(any()))
          .thenAnswer((_) async => mockDoc);

      final service = WhatsAppGroupShareService(firestore: mockFirestore);
      final shareUrl = await service.generateGroupShareLink(
        appointmentId: 'test-appointment',
        creatorId: 'creator-id',
        meetingTitle: 'Meeting with & special characters!',
        meetingDate: DateTime.now(),
      );

      // Should not throw and should generate valid URL
      expect(() => Uri.parse(shareUrl), returnsNormally);
      
      final uri = Uri.parse(shareUrl);
      expect(uri.queryParameters['appointmentId'], equals('test-appointment'));
    });
  });
}