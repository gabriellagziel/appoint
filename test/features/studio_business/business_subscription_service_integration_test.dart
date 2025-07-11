import 'package:appoint/features/studio_business/models/business_subscription.dart';
import 'package:appoint/services/business_subscription_service.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../firebase_test_setup.dart';

class MockFirebaseFunctions extends Fake implements FirebaseFunctions {}

void main() {
  late FakeFirebaseFirestore fakeFs;
  late MockFirebaseAuth mockAuth;
  late MockFirebaseFunctions mockFunctions;
  late BusinessSubscriptionService service;
  late MockUser user;

  setUpAll(() async {
    await setupFirebaseMocks();
  });

  setUp(() async {
    fakeFs = FakeFirebaseFirestore();
    user = MockUser(uid: 'test-user', email: 'test@user.com');
    mockAuth = MockFirebaseAuth(mockUser: user);
    await mockAuth.signInWithEmailAndPassword(
      email: user.email!,
      password: 'any',
    );
    mockFunctions = MockFirebaseFunctions();

    service = BusinessSubscriptionService(
      firestore: fakeFs,
      auth: mockAuth,
      functions: mockFunctions,
    );
  });

  tearDown(() async {
    // Clean up the subscription document after each test
    await fakeFs.collection('business_subscriptions').doc('test-user').delete();
  });

  group('BusinessSubscriptionService Integration Tests', () {
    test('validatePromoCode() returns valid promo code for active code',
        () async {
      // Arrange: seed a valid promo code
      now = DateTime.now();
      await fakeFs.collection('promoCodes').doc('FREE30').set({
        'id': 'FREE30',
        'code': 'FREE30',
        'description': 'Free trial',
        'type': 'freeTrial',
        'value': 1,
        'validFrom': now.subtract(const Duration(days: 1)).toIso8601String(),
        'validUntil': now.add(const Duration(days: 7)).toIso8601String(),
        'maxUses': 100,
        'currentUses': 0,
        'isActive': true,
        'createdAt': now.toIso8601String(),
        'updatedAt': now.toIso8601String(),
      });

      // Act
      result = await service.validatePromoCode('FREE30');

      // Assert
      expect(result, isNotNull);
      expect(result!.code, 'FREE30');
    });

    test('validatePromoCode() returns null for expired promo code', () async {
      // Arrange: expired code
      now = DateTime.now();
      await fakeFs.collection('promoCodes').doc('OLD').set({
        'id': 'OLD',
        'code': 'OLD',
        'description': 'Expired code',
        'type': 'freeTrial',
        'value': 1,
        'validFrom': now.subtract(const Duration(days: 10)).toIso8601String(),
        'validUntil': now.subtract(const Duration(days: 1)).toIso8601String(),
        'maxUses': 100,
        'currentUses': 0,
        'isActive': true,
        'createdAt': now.toIso8601String(),
        'updatedAt': now.toIso8601String(),
      });

      // Act
      result = await service.validatePromoCode('OLD');

      // Assert
      expect(result, isNull);
    });

    test('applyPromoCode() updates Firestore with promo code', () async {
      // Arrange: seed a valid promo code
      now = DateTime.now();
      await fakeFs.collection('promoCodes').doc('FREE30').set({
        'id': 'FREE30',
        'code': 'FREE30',
        'description': 'Free trial',
        'type': 'freeTrial',
        'value': 1,
        'validFrom': now.subtract(const Duration(days: 1)).toIso8601String(),
        'validUntil': now.add(const Duration(days: 7)).toIso8601String(),
        'maxUses': 100,
        'currentUses': 0,
        'isActive': true,
        'createdAt': now.toIso8601String(),
        'updatedAt': now.toIso8601String(),
      });

      // Act
      await service.applyPromoCode('FREE30');

      // Assert: Check that a subscription document was created
      final subscriptionDocs =
          await fakeFs.collection('business_subscriptions').get();
      expect(subscriptionDocs.docs.length, 1);

      subscriptionData = subscriptionDocs.docs.first.data();
      expect(subscriptionData['businessId'], 'test-user');
      expect(subscriptionData['promoCodeId'], 'FREE30');

      // Assert: Check that promo code usage was incremented
      final promoCodeDoc =
          await fakeFs.collection('promoCodes').doc('FREE30').get();
      promoCodeData = promoCodeDoc.data();
      expect(promoCodeData!['currentUses'], 1);
    });

    test('getCurrentSubscription() returns null when no subscription exists',
        () async {
      // Act
      result = await service.getCurrentSubscription();

      // Assert
      expect(result, isNull);
    });

    test('getCurrentSubscription() returns subscription when it exists',
        () async {
      // Arrange: seed Firestore with subscription data
      await fakeFs.collection('business_subscriptions').doc('test-user').set({
        'businessId': 'test-user',
        'plan': 'basic',
        'status': 'active',
        'currentPeriodStart':
            DateTime.now().subtract(const Duration(days: 10)).toIso8601String(),
        'currentPeriodEnd':
            DateTime.now().add(const Duration(days: 20)).toIso8601String(),
        'customerId': 'cus_123',
        'createdAt':
            DateTime.now().subtract(const Duration(days: 10)).toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      });

      // Act
      result = await service.getCurrentSubscription();

      // Assert
      expect(result, isNotNull);
      expect(result!.plan, SubscriptionPlan.basic);
      expect(result.status.name, 'active');
    });

    test('hasActiveSubscription() returns false when no subscription exists',
        () async {
      // Act
      result = await service.hasActiveSubscription();

      // Assert
      expect(result, false);
    });

    test('hasActiveSubscription() returns true when active subscription exists',
        () async {
      // Arrange: seed Firestore with active subscription
      await fakeFs.collection('business_subscriptions').doc('test-user').set({
        'businessId': 'test-user',
        'plan': 'pro',
        'status': 'active',
        'currentPeriodStart':
            DateTime.now().subtract(const Duration(days: 10)).toIso8601String(),
        'currentPeriodEnd':
            DateTime.now().add(const Duration(days: 20)).toIso8601String(),
        'customerId': 'cus_123',
        'createdAt':
            DateTime.now().subtract(const Duration(days: 10)).toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      });

      // Act
      result = await service.hasActiveSubscription();

      // Assert
      expect(result, true);
    });
  });
}
