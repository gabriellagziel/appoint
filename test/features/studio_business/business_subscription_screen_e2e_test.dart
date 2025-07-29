import 'package:appoint/features/studio_business/models/business_subscription.dart';
import 'package:appoint/features/studio_business/models/promo_code.dart';
import 'package:appoint/features/studio_business/providers/business_subscription_provider.dart';
import 'package:appoint/features/studio_business/screens/business_subscription_screen.dart';
import 'package:appoint/providers/firebase_providers.dart';
import 'package:appoint/services/business_subscription_service.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../firebase_test_setup.dart';

class MockFirebaseFunctions extends Fake implements FirebaseFunctions {}

class MockBusinessSubscriptionService extends Fake
    implements BusinessSubscriptionService {
  bool basicCalled = false;
  bool proCalled = false;
  bool portalCalled = false;
  String? lastPromoCode;
  bool shouldThrowError = false;
  BusinessSubscription? mockSubscription;

  @override
  Future<void> subscribeBasic() async {
    if (shouldThrowError) throw Exception('Mock error');
    await Future.delayed(const Duration(milliseconds: 100));
    basicCalled = true;
  }

  @override
  Future<void> subscribePro() async {
    if (shouldThrowError) throw Exception('Mock error');
    await Future.delayed(const Duration(milliseconds: 100));
    proCalled = true;
  }

  @override
  Future<void> openCustomerPortal() async {
    if (shouldThrowError) throw Exception('Mock error');
    portalCalled = true;
  }

  @override
  Future<void> applyPromoCode(String code) async {
    if (shouldThrowError) throw Exception('Invalid promo code');
    lastPromoCode = code;
  }

  @override
  Stream<BusinessSubscription?> watchSubscription() =>
      Stream.value(mockSubscription);

  @override
  Future<BusinessSubscription?> getCurrentSubscription() async =>
      mockSubscription;

  @override
  Future<bool> hasActiveSubscription() async =>
      mockSubscription != null &&
      mockSubscription!.status == SubscriptionStatus.active;

  @override
  Future<PromoCode?> validatePromoCode(String code) async {
    if (shouldThrowError) return null;
    return PromoCode(
      id: code,
      code: code,
      description: 'Test promo',
      type: PromoCodeType.freeTrial,
      value: 1,
      validFrom: DateTime.now().subtract(const Duration(days: 1)),
      validUntil: DateTime.now().add(const Duration(days: 7)),
      maxUses: 100,
      currentUses: 0,
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}

void main() {
  late FakeFirebaseFirestore fakeFs;
  late MockFirebaseAuth mockAuth;
  late MockBusinessSubscriptionService mockService;
  late MockUser user;

  setUpAll(() async {
    await setupFirebaseMocks();
    user = MockUser(uid: 'uid1', email: 'user@e2e.com');
    mockAuth = MockFirebaseAuth(mockUser: user);
    await mockAuth.signInWithEmailAndPassword(
      email: user.email!,
      password: 'any',
    );
  });

  setUp(() async {
    fakeFs = FakeFirebaseFirestore();
    mockService = MockBusinessSubscriptionService();

    // Seed Firestore with subscription data for uid1
    await fakeFs.collection('business_subscriptions').doc('uid1').set({
      'businessId': 'uid1',
      'plan': 'pro',
      'status': 'active',
      'currentPeriodStart':
          DateTime.now().subtract(const Duration(days: 5)).toIso8601String(),
      'currentPeriodEnd':
          DateTime.now().add(const Duration(days: 25)).toIso8601String(),
      'customerId': 'cus_abc',
      'createdAt':
          DateTime.now().subtract(const Duration(days: 5)).toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    });

    // Set up mock subscription data for the service
    mockService.mockSubscription = BusinessSubscription(
      id: 'uid1',
      businessId: 'uid1',
      customerId: 'cus_abc',
      plan: SubscriptionPlan.pro,
      status: SubscriptionStatus.active,
      currentPeriodStart: DateTime.now().subtract(const Duration(days: 5)),
      currentPeriodEnd: DateTime.now().add(const Duration(days: 25)),
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now(),
    );
  });

  Widget createTestWidget() => ProviderScope(
        overrides: [
          firestoreProvider.overrideWithValue(fakeFs),
          firebaseAuthProvider.overrideWithValue(mockAuth),
          firebaseFunctionsProvider.overrideWithValue(MockFirebaseFunctions()),
          REDACTED_TOKEN.overrideWithValue(mockService),
        ],
        child: const MaterialApp(
          home: BusinessSubscriptionScreen(),
        ),
      );

  group('BusinessSubscriptionScreen E2E Tests', () {
    testWidgets('shows basic UI elements', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check for basic UI elements
      expect(find.text('Business Subscription'), findsOneWidget);
      expect(find.text('Choose Your Plan'), findsOneWidget);
      expect(find.text('Subscribe to Basic (€4.99/mo)'), findsOneWidget);
      expect(find.text('Subscribe to Pro (€14.99/mo)'), findsOneWidget);
      expect(find.text('Promo Code'), findsOneWidget);
      expect(find.text('Apply'), findsOneWidget);
      expect(find.text('Plan Comparison'), findsOneWidget);
    });

    testWidgets('Subscribe to Basic button calls service method',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap the Basic subscription button
      await tester.tap(find.text('Subscribe to Basic (€4.99/mo)'));
      await tester.pumpAndSettle();

      // Verify the service method was called
      expect(mockService.basicCalled, true);
      expect(mockService.proCalled, false);
    });

    testWidgets('Subscribe to Pro button calls service method', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap the Pro subscription button
      await tester.tap(find.text('Subscribe to Pro (€14.99/mo)'));
      await tester.pumpAndSettle();

      // Verify the service method was called
      expect(mockService.proCalled, true);
      expect(mockService.basicCalled, false);
    });

    testWidgets('Change Plan button calls customer portal', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert Change Plan button is present
      expect(find.text('Change Plan'), findsOneWidget);
      await tester.tap(find.text('Change Plan'));
      await tester.pumpAndSettle();

      // Verify the service method was called
      expect(mockService.portalCalled, true);
    });

    testWidgets('promo code text field is present and functional',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find the promo code text field
      textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      // Enter text in the promo code field
      await tester.enterText(textField, 'TESTCODE');
      await tester.pump();

      // Verify the text was entered
      expect(find.text('TESTCODE'), findsOneWidget);
    });

    testWidgets('Apply promo code button calls service method', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Enter promo code
      await tester.enterText(find.byType(TextField), 'TESTCODE');
      await tester.pump();

      // Tap the Apply button
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();

      // Verify the service method was called with correct code
      expect(mockService.lastPromoCode, 'TESTCODE');
    });

    testWidgets('shows error snackbar for invalid promo code', (tester) async {
      // Set up the mock to throw an error
      mockService.shouldThrowError = true;

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Enter promo code
      await tester.enterText(find.byType(TextField), 'INVALID');
      await tester.pump();

      // Tap the Apply button
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();

      // Verify error snackbar appears
      expect(find.textContaining('Failed to apply promo code'), findsOneWidget);
    });

    testWidgets('shows success snackbar for valid promo code', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Enter promo code
      await tester.enterText(find.byType(TextField), 'VALID');
      await tester.pump();

      // Tap the Apply button
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();

      // Verify success snackbar appears
      expect(
        find.text('Promo applied! Your next bill is free.'),
        findsOneWidget,
      );
    });

    testWidgets('shows loading spinner during subscription process',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap the Basic subscription button
      await tester.tap(find.text('Subscribe to Basic (€4.99/mo)'));
      await tester.pump();

      // Verify loading spinner appears
      expect(find.byType(CircularProgressIndicator), findsAtLeastNWidgets(1));
      await tester.pumpAndSettle();
    });

    testWidgets('shows error snackbar for subscription failure',
        (tester) async {
      // Set up the mock to throw an error
      mockService.shouldThrowError = true;

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap the Basic subscription button
      await tester.tap(find.text('Subscribe to Basic (€4.99/mo)'));
      await tester.pumpAndSettle();

      // Verify error snackbar appears
      expect(
        find.textContaining('Failed to start Basic subscription'),
        findsOneWidget,
      );
    });

    testWidgets('shows success snackbar for subscription success',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap the Basic subscription button
      await tester.tap(find.text('Subscribe to Basic (€4.99/mo)'));
      await tester.pumpAndSettle();

      // Verify success snackbar appears
      expect(
        find.text('Redirecting to Stripe checkout for Basic plan...'),
        findsOneWidget,
      );
    });
  });
}
