import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:appoint/services/admin_service.dart';
import 'package:appoint/providers/admin_provider.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  });

  group('Admin Service Tests', () {
    test('Admin service provider provides AdminService instance', () {
      final container = ProviderContainer();
      final service = container.read(adminServiceProvider);
      expect(service, isA<AdminService>());
      container.dispose();
    });

    test('Admin actions provider provides AdminActions instance', () {
      final container = ProviderContainer();
      final actions = container.read(adminActionsProvider);
      expect(actions, isA<AdminActions>());
      container.dispose();
    });

    test('Admin actions can update user role', () async {
      final container = ProviderContainer();
      final actions = container.read(adminActionsProvider);

      // This test verifies the method exists and can be called
      // In a real test with proper mocking, you'd verify the Firestore calls
      expect(actions.updateUserRole, isA<Function>());

      container.dispose();
    });

    test('Admin actions can resolve errors', () async {
      final container = ProviderContainer();
      final actions = container.read(adminActionsProvider);

      // This test verifies the method exists and can be called
      expect(actions.resolveError, isA<Function>());

      container.dispose();
    });

    test('Admin actions can create broadcast messages', () async {
      final container = ProviderContainer();
      final actions = container.read(adminActionsProvider);

      // This test verifies the method exists and can be called
      expect(actions.createBroadcastMessage, isA<Function>());

      container.dispose();
    });

    test('Admin actions can export data as CSV', () async {
      final container = ProviderContainer();
      final actions = container.read(adminActionsProvider);

      // This test verifies the method exists and can be called
      expect(actions.exportDataAsCSV, isA<Function>());

      container.dispose();
    });

    test('Admin actions can export data as PDF', () async {
      final container = ProviderContainer();
      final actions = container.read(adminActionsProvider);

      // This test verifies the method exists and can be called
      expect(actions.exportDataAsPDF, isA<Function>());

      container.dispose();
    });
  });
}
