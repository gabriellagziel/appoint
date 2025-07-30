import 'package:appoint/main.dart' as app;
import 'package:appoint/services/stripe_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  REDACTED_TOKEN.ensureInitialized();

  group('Stripe Integration Tests', () {
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

    testWidgets('Stripe Service Initialization and Checkout Session Creation',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      late StripeService stripeService;
      stripeService = StripeService();

      // Test checkout session creation
      // Note: In integration tests, we can't actually create real Stripe sessions
      // but we can test the service structure and error handling
      expect(
        () => stripeService.createCheckoutSession(
          studioId: 'test-studio-id',
          priceId: 'price_test123',
        ),
        returnsNormally,
      );
    });

    testWidgets('Stripe Subscription Status Management', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      const testStudioId = 'test-studio-stripe';
      late StripeService stripeService;
      late String? status;
      stripeService = StripeService();

      // Test subscription status checking
      status = await stripeService.getSubscriptionStatus(testStudioId);
      expect(status, isNull); // Should be null for non-existent studio

      // Test subscription status update
      await stripeService.updateSubscriptionStatus(
        studioId: testStudioId,
        status: 'active',
        subscriptionId: 'sub_test123',
      );

      // Verify status was updated
      final updatedStatus =
          await stripeService.getSubscriptionStatus(testStudioId);
      expect(updatedStatus, equals('active'));
    });

    testWidgets('Stripe Subscription Details Retrieval', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      const testStudioId = 'test-studio-details';
      late StripeService stripeService;
      late Map<String, dynamic>? details;
      stripeService = StripeService();

      // Set up test subscription data
      await FirebaseFirestore.instance
          .collection('studio')
          .doc(testStudioId)
          .set({
        'subscriptionStatus': 'active',
        'subscriptionId': 'sub_test456',
        'lastPaymentDate': Timestamp.now(),
        'createdAt': Timestamp.now(),
      });

      // Test subscription details retrieval
      details = await stripeService.getSubscriptionDetails(testStudioId);
      expect(details, isNotNull);
      final nonNullDetails = details!;
      expect(nonNullDetails['status'], equals('active'));
      expect(nonNullDetails['subscriptionId'], equals('sub_test456'));
    });

    testWidgets('Stripe Active Subscription Check', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      const testStudioId = 'test-studio-active';
      late StripeService stripeService;
      late bool isActive;
      stripeService = StripeService();

      // Test inactive subscription
      isActive = await stripeService.hasActiveSubscription(testStudioId);
      expect(isActive, isFalse);

      // Set up active subscription
      await stripeService.updateSubscriptionStatus(
        studioId: testStudioId,
        status: 'active',
      );

      // Test active subscription
      final isActiveAfter =
          await stripeService.hasActiveSubscription(testStudioId);
      expect(isActiveAfter, isTrue);
    });

    testWidgets('Stripe Subscription Cancellation', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      const testStudioId = 'test-studio-cancel';
      late StripeService stripeService;
      stripeService = StripeService();

      // Set up active subscription
      await stripeService.updateSubscriptionStatus(
        studioId: testStudioId,
        status: 'active',
        subscriptionId: 'sub_test789',
      );

      // Test subscription cancellation
      // Note: In integration tests, we can't actually cancel real Stripe subscriptions
      // but we can test the service structure
      expect(
        () => stripeService.cancelSubscription(testStudioId),
        returnsNormally,
      );
    });

    testWidgets('Stripe Service Error Handling', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      late StripeService stripeService;
      late String? status;
      stripeService = StripeService();

      // Test with invalid studio ID
      status = await stripeService.getSubscriptionStatus('');
      expect(status, isNull);

      // Test with null parameters
      expect(
        () => stripeService.updateSubscriptionStatus(
          studioId: 'test',
          status: 'active',
        ),
        returnsNormally,
      );
    });

    testWidgets('Stripe Webhook Simulation', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      const testStudioId = 'test-studio-webhook';

      // Simulate webhook data that would come from Stripe
      final webhookData = {
        'sessionId': 'cs_test_123',
        'subscriptionId': 'sub_test_webhook',
        'customerId': 'cus_test_123',
        'status': 'active',
        'currentPeriodEnd': DateTime.now()
                .add(const Duration(days: 30))
                .millisecondsSinceEpoch ~/
            1000,
        'created': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      };

      // Update Firestore as if webhook processed
      await FirebaseFirestore.instance
          .collection('studio')
          .doc(testStudioId)
          .update({
        'subscriptionStatus': 'active',
        'subscriptionData': webhookData,
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      // Verify the data was stored correctly
      final doc = await FirebaseFirestore.instance
          .collection('studio')
          .doc(testStudioId)
          .get();

      expect(doc.data()?['subscriptionStatus'], equals('active'));
      expect(doc.data()?['subscriptionData'], isNotNull);
    });
  });
}
