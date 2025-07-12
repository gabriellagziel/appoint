import 'package:appoint/services/admin_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../firebase_test_helper.dart';
import '../test_service_factory.dart';

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  group('AdminService', () {
    test('should have required method signatures', () {
      // Test that the service can be instantiated with mocked dependencies
      service = TestServiceFactory.createAdminService();
      expect(service, isA<AdminService>());
    });

    test('should have fetchAllUsers method', () {
      service = TestServiceFactory.createAdminService();
      expect(service.fetchAllUsers, isA<Function>());
    });

    test('should have fetchOrganizations method', () {
      service = TestServiceFactory.createAdminService();
      expect(service.fetchOrganizations, isA<Function>());
    });

    test('should have fetchAnalytics method', () {
      service = TestServiceFactory.createAdminService();
      expect(service.fetchAnalytics, isA<Function>());
    });

    test('should have updateUserRole method', () {
      service = TestServiceFactory.createAdminService();
      expect(service.updateUserRole, isA<Function>());
    });

    test('should be a concrete class', () {
      service = TestServiceFactory.createAdminService();
      expect(service.runtimeType, AdminService);
    });

    test('should have proper constructor', () {
      service = TestServiceFactory.createAdminService();
      expect(service, isA<AdminService>());
    });
  });
}
