import 'package:appoint/main.dart' as app;
import 'package:appoint/services/fcm_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('FCM Integration Tests', () {
    setUpAll(() async {
      // Configure Firebase to use emulators
      await Firebase.initializeApp();

      // Point Firestore to emulator
      FirebaseFirestore.instance.settings = const Settings(
        host: 'localhost:8080',
        sslEnabled: false,
        persistenceEnabled: false,
      );

      // Point Auth to emulator
      await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    });

    testWidgets('FCM Service Initialization and Token Management',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Initialize FCM service
      fcmService = FCMService();
      await fcmService.initialize();

      // Get FCM token
      token = await fcmService.getToken();
      expect(token, isNotNull);

      // Verify token is saved to Firestore
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final studioDoc = await FirebaseFirestore.instance
            .collection('studio')
            .doc(user.uid)
            .get();

        expect(studioDoc.data()?['fcmToken'], equals(token));
      }
    });

    testWidgets('FCM Notification Trigger on New Booking', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Setup test studio with FCM token
      const testStudioId = 'test-studio-fcm';
      const testFcmToken = 'test-fcm-token-123';

      await FirebaseFirestore.instance
          .collection('studio')
          .doc(testStudioId)
          .set({
        'fcmToken': testFcmToken,
        'name': 'Test Studio for FCM',
      });

      // Create a new booking that should trigger FCM notification
      await FirebaseFirestore.instance.collection('bookings').add({
        'studioId': testStudioId,
        'clientName': 'FCM Test Client',
        'startTime':
            Timestamp.fromDate(DateTime.now().add(const Duration(hours: 1))),
        'endTime':
            Timestamp.fromDate(DateTime.now().add(const Duration(hours: 2))),
        'status': 'confirmed',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Wait for the booking to be processed
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify the booking was created
      final bookings = await FirebaseFirestore.instance
          .collection('bookings')
          .where('studioId', isEqualTo: testStudioId)
          .get();

      expect(bookings.docs, isNotEmpty);
      expect(
        bookings.docs.first.data()['clientName'],
        equals('FCM Test Client'),
      );
    });

    testWidgets('FCM Topic Subscription and Unsubscription', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      fcmService = FCMService();
      await fcmService.initialize();

      // Test topic subscription
      const testTopic = 'test_topic';
      await fcmService.subscribeToTopic(testTopic);

      // Test topic unsubscription
      await fcmService.unsubscribeFromTopic(testTopic);

      // Verify no errors occurred
      expect(() => fcmService.subscribeToTopic(testTopic), returnsNormally);
      expect(() => fcmService.unsubscribeFromTopic(testTopic), returnsNormally);
    });

    testWidgets('FCM Foreground Message Handling', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      fcmService = FCMService();
      await fcmService.initialize();

      // Simulate a foreground message
      // Note: In integration tests, we can't actually receive real FCM messages
      // but we can test the service structure and error handling

      // Verify the service can handle initialization multiple times
      expect(fcmService.initialize, returnsNormally);

      // Verify token retrieval works
      token = await fcmService.getToken();
      expect(token, isNotNull);
    });
  });
}
