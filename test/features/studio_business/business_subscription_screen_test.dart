import 'package:appoint/features/studio_business/screens/business_subscription_screen.dart';
import 'package:appoint/providers/firebase_providers.dart';
import 'package:appoint/services/business_subscription_service.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../firebase_test_setup.dart';
import 'package:appoint/services/business_subscription_service.dart';
import 'package:appoint/features/studio_business/providers/business_subscription_provider.dart';
import 'package:appoint/providers/firebase_providers.dart';

class MockFirebaseFunctions extends Fake implements FirebaseFunctions {}

class MockBusinessSubscriptionService extends Fake
    implements BusinessSubscriptionService {
  @override
  Future<void> subscribeBasic() async {
    // Mock implementation
  }

  @override
  Future<void> subscribePro() async {
    // Mock implementation
  }

  @override
  Future<void> applyPromoCode(String code) async {
    // Mock implementation
  }

  @override
  Future<void> openCustomerPortal() async {
    // Mock implementation
  }
}

void main() {
  late ProviderContainer container;

  setUpAll(() async {
    await setupFirebaseMocks();
  });

  setUp(() async {
    container = await createTestContainer();
  });

  testWidgets('business subscription screen shows basic UI elements', (
    tester,
  ) async {
    final testContainer = ProviderContainer(
      overrides: [
        firestoreProvider.overrideWithValue(firestore),
        firebaseAuthProvider.overrideWithValue(auth),
        firebaseFunctionsProvider.overrideWithValue(mockFunctions),
        REDACTED_TOKEN.overrideWithValue(
          BusinessSubscriptionService(
            firestore: firestore,
            auth: auth,
            functions: mockFunctions,
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: testContainer,
        child: const MaterialApp(home: BusinessSubscriptionScreen()),
      ),
    );

    // Ensure UI is loaded
    await tester.pumpAndSettle();

    // Check for basic UI elements
    expect(find.text('Business Subscription'), findsOneWidget);
    expect(find.text('Choose Your Plan'), findsOneWidget);
    expect(find.text('Starter'), findsAtLeastNWidgets(1));
    expect(find.text('Professional'), findsAtLeastNWidgets(1));
    expect(find.text('Business Plus'), findsAtLeastNWidgets(1));
    expect(find.text('Promo Code'), findsOneWidget);
    expect(find.text('Apply'), findsOneWidget);
    expect(find.text('Plan Comparison'), findsOneWidget);
  });

  testWidgets('promo code text field is present and functional', (
    tester,
  ) async {
    final testContainer = ProviderContainer(
      overrides: [
        firestoreProvider.overrideWithValue(firestore),
        firebaseAuthProvider.overrideWithValue(auth),
        firebaseFunctionsProvider.overrideWithValue(mockFunctions),
        REDACTED_TOKEN.overrideWithValue(
          BusinessSubscriptionService(
            firestore: firestore,
            auth: auth,
            functions: mockFunctions,
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: testContainer,
        child: const MaterialApp(home: BusinessSubscriptionScreen()),
      ),
    );

    await tester.pumpAndSettle();

    // Find the promo code text field
    final textField = find.byType(TextField);
    expect(textField, findsOneWidget);

    // Enter text in the promo code field
    await tester.enterText(textField, 'TESTCODE');
    await tester.pump();

    // Verify the text was entered
    expect(find.text('TESTCODE'), findsOneWidget);
  });
}
