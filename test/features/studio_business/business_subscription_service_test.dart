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

  setUpAll(() async {
    await setupFirebaseMocks();
  });

  setUp(() {
    fakeFs = FakeFirebaseFirestore();
    mockAuth = MockFirebaseAuth(mockUser: MockUser(uid: 'test-user'));
    mockFunctions = MockFirebaseFunctions();
    service = BusinessSubscriptionService(
      firestore: fakeFs,
      auth: mockAuth,
      functions: mockFunctions,
    );
  });

  group('validatePromoCode', () {
    test('returns valid promo code for active code', () async {
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

    test('returns null for expired promo code', () async {
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

    test('returns null for code with exceeded usage limit', () async {
      // Arrange: code with exceeded usage
      now = DateTime.now();
      await fakeFs.collection('promoCodes').doc('USED').set({
        'id': 'USED',
        'code': 'USED',
        'description': 'Used code',
        'type': 'freeTrial',
        'value': 1,
        'validFrom': now.subtract(const Duration(days: 1)).toIso8601String(),
        'validUntil': now.add(const Duration(days: 7)).toIso8601String(),
        'maxUses': 10,
        'currentUses': 10, // Maxed out
        'isActive': true,
        'createdAt': now.toIso8601String(),
        'updatedAt': now.toIso8601String(),
      });

      // Act
      result = await service.validatePromoCode('USED');

      // Assert
      expect(result, isNull);
    });
  });
}
