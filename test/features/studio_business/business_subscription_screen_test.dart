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
  late FakeFirebaseFirestore fakeFs;
  late MockFirebaseAuth mockAuth;
  late MockFirebaseFunctions mockFunctions;

  setUpAll(() async {
    await setupFirebaseMocks();
  });

  setUp(() {
    fakeFs = FakeFirebaseFirestore();
    mockAuth = MockFirebaseAuth(mockUser: MockUser(uid: 'test-user'));
    mockFunctions = MockFirebaseFunctions();
  });

  testWidgets('business subscription screen shows basic UI elements',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          firestoreProvider.overrideWithValue(fakeFs),
          firebaseAuthProvider.overrideWithValue(mockAuth),
          firebaseFunctionsProvider.overrideWithValue(mockFunctions),
        ],
        child: const MaterialApp(home: BusinessSubscriptionScreen()),
      ),
    );

    // Ensure UI is loaded
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

  testWidgets('promo code text field is present and functional',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          firestoreProvider.overrideWithValue(fakeFs),
          firebaseAuthProvider.overrideWithValue(mockAuth),
          firebaseFunctionsProvider.overrideWithValue(mockFunctions),
        ],
        child: const MaterialApp(home: BusinessSubscriptionScreen()),
      ),
    );

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
}
