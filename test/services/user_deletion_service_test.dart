import 'package:appoint/services/user_deletion_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../firebase_test_helper.dart';
import '../test_service_factory.dart';

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  group('UserDeletionService', () {
    late UserDeletionService service;

    test('should be instantiable with mocked dependencies', () {
      // Test that the service can be instantiated with mocked dependencies
      service = TestServiceFactory.createUserDeletionService();
      expect(service, isA<UserDeletionService>());
    });

    test('should have deleteCurrentUser method', () {
      service = TestServiceFactory.createUserDeletionService();
      expect(service.deleteCurrentUser, isA<Function>());
    });

    test('should be instantiable', () {
      expect(
        TestServiceFactory.createUserDeletionService,
        returnsNormally,
      );
    });

    test('should have proper class structure', () {
      service = TestServiceFactory.createUserDeletionService();
      expect(service.runtimeType, UserDeletionService);
    });
  });
}
