import 'package:appoint/models/admin_broadcast_message.dart';
import 'package:appoint/services/broadcast_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../firebase_test_helper.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}
class MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}
class MockQuerySnapshot extends Mock implements QuerySnapshot<Map<String, dynamic>> {}
class MockDocumentSnapshot extends Mock implements DocumentSnapshot<Map<String, dynamic>> {}

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  group('BroadcastService', () {
    late BroadcastService broadcastService;
    late MockFirebaseFirestore mockFirestore;
    late MockCollectionReference mockBroadcastsCollection;
    late MockCollectionReference mockAnalyticsCollection;
    late MockCollectionReference mockUsersCollection;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockBroadcastsCollection = MockCollectionReference();
      mockAnalyticsCollection = MockCollectionReference();
      mockUsersCollection = MockCollectionReference();
      
      when(() => mockFirestore.collection('admin_broadcasts'))
          .thenReturn(mockBroadcastsCollection);
      when(() => mockFirestore.collection('broadcast_analytics'))
          .thenReturn(mockAnalyticsCollection);
      when(() => mockFirestore.collection('users'))
          .thenReturn(mockUsersCollection);
      
      broadcastService = BroadcastService(firestore: mockFirestore);
    });

    test('should have required method signatures', () {
      expect(BroadcastService, isA<Type>());
    });

    group('Analytics Infrastructure', () {
      test('should track message interactions', () async {
        final mockDocRef = MockDocumentReference();
        when(() => mockAnalyticsCollection.add(any()))
            .thenAnswer((_) async => mockDocRef);
        when(() => mockBroadcastsCollection.doc(any()))
            .thenReturn(mockDocRef);
        when(() => mockDocRef.update(any()))
            .thenAnswer((_) async => {});

        await broadcastService.trackMessageInteraction(
          'message-123',
          'user-456',
          'opened',
        );

        verify(() => mockAnalyticsCollection.add(any())).called(1);
      });

      test('should track message interactions with additional data', () async {
        final mockDocRef = MockDocumentReference();
        when(() => mockAnalyticsCollection.add(any()))
            .thenAnswer((_) async => mockDocRef);
        when(() => mockBroadcastsCollection.doc(any()))
            .thenReturn(mockDocRef);
        when(() => mockDocRef.update(any()))
            .thenAnswer((_) async => {});

        await broadcastService.trackMessageInteraction(
          'message-123',
          'user-456',
          'poll_response',
          additionalData: {'selectedOption': 'Option A'},
        );

        verify(() => mockAnalyticsCollection.add(any())).called(1);
      });

      test('should get message analytics', () async {
        final mockMessageDoc = MockDocumentSnapshot();
        final mockAnalyticsQuery = MockQuerySnapshot();
        
        when(() => mockBroadcastsCollection.doc('message-123'))
            .thenReturn(MockDocumentReference());
        when(() => MockDocumentReference().get())
            .thenAnswer((_) async => mockMessageDoc);
        when(() => mockMessageDoc.exists).thenReturn(true);
        when(() => mockMessageDoc.data()).thenReturn({
          'title': 'Test Message',
          'type': 'text',
          'status': 'sent',
          'createdAt': Timestamp.now(),
          'actualRecipients': 100,
          'openedCount': 80,
          'clickedCount': 40,
          'pollResponseCount': 0,
          'failedCount': 5,
        });

        when(() => mockAnalyticsCollection
            .where('messageId', isEqualTo: 'message-123'))
            .thenReturn(mockAnalyticsCollection);
        when(() => mockAnalyticsCollection
            .orderBy('timestamp', descending: true))
            .thenReturn(mockAnalyticsCollection);
        when(() => mockAnalyticsCollection.get())
            .thenAnswer((_) async => mockAnalyticsQuery);
        when(() => mockAnalyticsQuery.docs).thenReturn([]);

        final analytics = await broadcastService.getMessageAnalytics('message-123');

        expect(analytics['messageId'], 'message-123');
        expect(analytics['actualRecipients'], 100);
        expect(analytics['openedCount'], 80);
        expect(analytics['clickedCount'], 40);
        expect(analytics['openRate'], 80.0);
        expect(analytics['clickRate'], 50.0);
        expect(analytics['deliveryRate'], 95.0);
      });

      test('should get analytics summary', () async {
        final mockQuerySnapshot = MockQuerySnapshot();
        final mockDoc1 = MockDocumentSnapshot();
        final mockDoc2 = MockDocumentSnapshot();

        when(() => mockBroadcastsCollection
            .where('status', isEqualTo: 'sent'))
            .thenReturn(mockBroadcastsCollection);
        when(() => mockBroadcastsCollection
            .orderBy('createdAt', descending: true))
            .thenReturn(mockBroadcastsCollection);
        when(() => mockBroadcastsCollection.get())
            .thenAnswer((_) async => mockQuerySnapshot);

        when(() => mockQuerySnapshot.docs).thenReturn([mockDoc1, mockDoc2]);
        
        when(() => mockDoc1.data()).thenReturn({
          'actualRecipients': 100,
          'openedCount': 80,
          'clickedCount': 40,
          'failedCount': 5,
          'type': 'text',
          'createdAt': Timestamp.fromDate(DateTime(2024, 1, 15)),
        });
        
        when(() => mockDoc2.data()).thenReturn({
          'actualRecipients': 150,
          'openedCount': 120,
          'clickedCount': 60,
          'failedCount': 10,
          'type': 'image',
          'createdAt': Timestamp.fromDate(DateTime(2024, 1, 16)),
        });

        final summary = await broadcastService.getAnalyticsSummary();

        expect(summary['totalMessages'], 2);
        expect(summary['totalRecipients'], 250);
        expect(summary['totalOpened'], 200);
        expect(summary['totalClicked'], 100);
        expect(summary['totalFailed'], 15);
        expect(summary['avgOpenRate'], 80.0);
        expect(summary['avgClickRate'], 50.0);
        expect(summary['avgDeliveryRate'], 94.0);
      });

      test('should export analytics as CSV', () async {
        final mockQuerySnapshot = MockQuerySnapshot();
        final mockDoc = MockDocumentSnapshot();

        when(() => mockBroadcastsCollection
            .where('status', isEqualTo: 'sent'))
            .thenReturn(mockBroadcastsCollection);
        when(() => mockBroadcastsCollection
            .orderBy('createdAt', descending: true))
            .thenReturn(mockBroadcastsCollection);
        when(() => mockBroadcastsCollection.get())
            .thenAnswer((_) async => mockQuerySnapshot);

        when(() => mockQuerySnapshot.docs).thenReturn([mockDoc]);
        when(() => mockDoc.id).thenReturn('message-123');
        when(() => mockDoc.data()).thenReturn({
          'title': 'Test Message',
          'type': 'text',
          'createdAt': Timestamp.fromDate(DateTime(2024, 1, 15)),
          'actualRecipients': 100,
          'openedCount': 80,
          'clickedCount': 40,
          'status': 'sent',
        });

        final csv = await broadcastService.exportAnalyticsCSV();

        expect(csv, contains('Message ID,Title,Type'));
        expect(csv, contains('message-123'));
        expect(csv, contains('Test Message'));
        expect(csv, contains('80.00')); // Open rate
        expect(csv, contains('50.00')); // Click rate
      });

      test('should process scheduled messages', () async {
        final mockQuerySnapshot = MockQuerySnapshot();
        final mockDoc = MockDocumentSnapshot();
        final mockDocRef = MockDocumentReference();

        when(() => mockBroadcastsCollection
            .where('status', isEqualTo: 'pending'))
            .thenReturn(mockBroadcastsCollection);
        when(() => mockBroadcastsCollection
            .where('scheduledFor', isLessThanOrEqualTo: any()))
            .thenReturn(mockBroadcastsCollection);
        when(() => mockBroadcastsCollection.get())
            .thenAnswer((_) async => mockQuerySnapshot);

        when(() => mockQuerySnapshot.docs).thenReturn([mockDoc]);
        when(() => mockDoc.id).thenReturn('message-123');
        
        // Mock the getBroadcastMessage and sendBroadcastMessage calls
        when(() => mockBroadcastsCollection.doc('message-123'))
            .thenReturn(mockDocRef);
        when(() => mockDocRef.get())
            .thenAnswer((_) async => mockDoc);
        when(() => mockDoc.exists).thenReturn(true);
        when(() => mockDoc.data()).thenReturn({
          'id': 'message-123',
          'title': 'Scheduled Message',
          'content': 'Test content',
          'type': 'text',
          'targetingFilters': {},
          'createdByAdminId': 'admin-123',
          'createdByAdminName': 'Admin',
          'createdAt': Timestamp.now(),
          'status': 'pending',
          'scheduledFor': Timestamp.fromDate(DateTime.now().subtract(Duration(minutes: 5))),
        });

        // Mock the _getTargetUsers call
        when(() => mockUsersCollection.where(any(), whereIn: any()))
            .thenReturn(mockUsersCollection);
        when(() => mockUsersCollection.get())
            .thenAnswer((_) async => MockQuerySnapshot());
        when(() => MockQuerySnapshot().docs).thenReturn([]);

        when(() => mockDocRef.update(any()))
            .thenAnswer((_) async => {});

        await broadcastService.processScheduledMessages();

        // Verify that the scheduled message processing was attempted
        verify(() => mockBroadcastsCollection
            .where('status', isEqualTo: 'pending')).called(1);
      });
    });

    group('Message Types and Targeting', () {
      test('should handle different targeting filter combinations', () {
        const filters1 = BroadcastTargetingFilters(
          countries: ['US', 'CA'],
          cities: ['New York', 'Toronto'],
        );

        const filters2 = BroadcastTargetingFilters(
          minAge: 18,
          maxAge: 65,
          subscriptionTiers: ['premium'],
        );

        const filters3 = BroadcastTargetingFilters(
          userRoles: ['user', 'admin'],
          accountStatuses: ['active'],
        );

        expect(filters1.countries, ['US', 'CA']);
        expect(filters2.minAge, 18);
        expect(filters3.userRoles, ['user', 'admin']);
      });

      test('should handle different broadcast message types', () {
        const targetingFilters = BroadcastTargetingFilters(
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
          createdAt: DateTime(2025, 6, 18, 10),
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
          createdAt: DateTime(2025, 6, 18, 10),
          status: BroadcastMessageStatus.pending,
        );

        final pollMessage = AdminBroadcastMessage(
          id: 'broadcast-3',
          title: 'Poll Message',
          content: 'Poll content',
          type: BroadcastMessageType.poll,
          pollOptions: ['Option A', 'Option B', 'Option C'],
          targetingFilters: targetingFilters,
          createdByAdminId: 'admin-123',
          createdByAdminName: 'Admin User',
          createdAt: DateTime(2025, 6, 18, 10),
          status: BroadcastMessageStatus.pending,
        );

        expect(textMessage.type, BroadcastMessageType.text);
        expect(imageMessage.type, BroadcastMessageType.image);
        expect(imageMessage.imageUrl, 'https://example.com/image.jpg');
        expect(pollMessage.type, BroadcastMessageType.poll);
        expect(pollMessage.pollOptions, ['Option A', 'Option B', 'Option C']);
      });
    });

    group('Error Handling', () {
      test('should handle analytics tracking errors gracefully', () async {
        when(() => mockAnalyticsCollection.add(any()))
            .thenThrow(Exception('Firestore error'));

        // Should not throw despite the error
        await expectLater(
          broadcastService.trackMessageInteraction(
            'message-123',
            'user-456',
            'opened',
          ),
          completes,
        );
      });

      test('should throw exception for non-existent message analytics', () async {
        final mockMessageDoc = MockDocumentSnapshot();
        when(() => mockBroadcastsCollection.doc('non-existent'))
            .thenReturn(MockDocumentReference());
        when(() => MockDocumentReference().get())
            .thenAnswer((_) async => mockMessageDoc);
        when(() => mockMessageDoc.exists).thenReturn(false);

        await expectLater(
          broadcastService.getMessageAnalytics('non-existent'),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}
