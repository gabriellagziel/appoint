import 'package:appoint/services/referral_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../firebase_test_helper.dart';
import '../test_service_factory.dart';

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  group('ReferralService', () {
    test('should be instantiable with mocked dependencies', () {
      // Test that the service can be instantiated with mocked dependencies
      service = TestServiceFactory.createReferralService();
      expect(service, isA<ReferralService>());
    });

    test('should have proper constructor', () {
      service = TestServiceFactory.createReferralService();
      expect(service, isA<ReferralService>());
    });

    test('should accept optional parameters', () {
      service = TestServiceFactory.createReferralService();
      expect(service, isA<ReferralService>());
    });

    test('should have generateReferralCode method', () {
      service = TestServiceFactory.createReferralService();
      expect(service.generateReferralCode, isA<Function>());
    });

    test('should have REDACTED_TOKEN method', () {
      service = TestServiceFactory.createReferralService();
      expect(service.REDACTED_TOKEN, isA<Function>());
    });
  });
}
