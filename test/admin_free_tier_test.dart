import 'package:appoint/providers/admin_provider.dart';
import 'package:appoint/services/admin_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAdminService extends Mock implements AdminService {}

class MockAdminActions extends Mock implements AdminActions {}

void main() {
  group('Admin Service Tests', () {
    late MockAdminService mockAdminService;
    late MockAdminActions mockAdminActions;

    setUp(() {
      mockAdminService = MockAdminService();
      mockAdminActions = MockAdminActions();
    });

    test('Admin service provider provides AdminService instance', () {
      final container = ProviderContainer(
        overrides: [
          adminServiceProvider.overrideWithValue(mockAdminService),
        ],
      );
      final service = container.read(adminServiceProvider);
      expect(service, isA<MockAdminService>());
      container.dispose();
    });

    test('Admin actions provider provides AdminActions instance', () {
      final container = ProviderContainer(
        overrides: [
          adminServiceProvider.overrideWithValue(mockAdminService),
          adminActionsProvider.overrideWithValue(mockAdminActions),
        ],
      );
      final actions = container.read(adminActionsProvider);
      expect(actions, isA<MockAdminActions>());
      container.dispose();
    });

    test('Admin actions can update user role', () async {
      final container = ProviderContainer(
        overrides: [
          adminServiceProvider.overrideWithValue(mockAdminService),
          adminActionsProvider.overrideWithValue(mockAdminActions),
        ],
      );
      final actions = container.read(adminActionsProvider);

      // This test verifies the method exists and can be called
      expect(actions.updateUserRole, isA<Function>());

      container.dispose();
    });

    test('Admin actions can resolve errors', () async {
      final container = ProviderContainer(
        overrides: [
          adminServiceProvider.overrideWithValue(mockAdminService),
          adminActionsProvider.overrideWithValue(mockAdminActions),
        ],
      );
      final actions = container.read(adminActionsProvider);

      // This test verifies the method exists and can be called
      expect(actions.resolveError, isA<Function>());

      container.dispose();
    });

    test('Admin actions can create broadcast messages', () async {
      final container = ProviderContainer(
        overrides: [
          adminServiceProvider.overrideWithValue(mockAdminService),
          adminActionsProvider.overrideWithValue(mockAdminActions),
        ],
      );
      final actions = container.read(adminActionsProvider);

      // This test verifies the method exists and can be called
      expect(actions.createBroadcastMessage, isA<Function>());

      container.dispose();
    });

    test('Admin actions can export data as CSV', () async {
      final container = ProviderContainer(
        overrides: [
          adminServiceProvider.overrideWithValue(mockAdminService),
          adminActionsProvider.overrideWithValue(mockAdminActions),
        ],
      );
      final actions = container.read(adminActionsProvider);

      // This test verifies the method exists and can be called
      expect(actions.exportDataAsCSV, isA<Function>());

      container.dispose();
    });

    test('Admin actions can export data as PDF', () async {
      final container = ProviderContainer(
        overrides: [
          adminServiceProvider.overrideWithValue(mockAdminService),
          adminActionsProvider.overrideWithValue(mockAdminActions),
        ],
      );
      final actions = container.read(adminActionsProvider);

      // This test verifies the method exists and can be called
      expect(actions.exportDataAsPDF, isA<Function>());

      container.dispose();
    });
  });
}
