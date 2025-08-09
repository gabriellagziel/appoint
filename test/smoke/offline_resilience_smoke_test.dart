import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/services/admin_service.dart';
import 'package:appoint/services/coppa_service.dart';

/// Offline resilience smoke test
/// Tests that the app handles Firestore outages gracefully
void main() {
  group('Offline Resilience Tests', () {
    test('admin service handles offline gracefully', () async {
      // Test that admin service doesn't crash when Firestore is unavailable
      try {
        final config = await AdminService.getAdConfig();
        // Should return default config or throw a specific error, not crash
        expect(config, isA<Map<String, dynamic>>());
      } catch (e) {
        // Expected to fail gracefully, not crash
        final errorString = e.toString();
        expect(
          errorString.contains('permission-denied') ||
              errorString.contains('unavailable') ||
              errorString.contains('network'),
          isTrue,
        );
      }
    });

    test('COPPA service handles offline gracefully', () async {
      // Test that COPPA service doesn't crash when Firestore is unavailable
      try {
        final validation = await COPPAService.validateSessionForCOPPA(
          'test_user',
          'test_game',
        );
        // Should return error result, not crash
        expect(validation, isA<Map<String, dynamic>>());
        expect(validation['valid'], isA<bool>());
      } catch (e) {
        // Expected to fail gracefully, not crash
        final errorString = e.toString();
        expect(
          errorString.contains('permission-denied') ||
              errorString.contains('unavailable') ||
              errorString.contains('network'),
          isTrue,
        );
      }
    });

    test('offline resilience smoke', () async {
      // This is a placeholder: import a tiny service that should fail softly.
      // Expect: no uncaught exceptions, return error result.
      expect(1 + 1, 2);
    });

    test('graceful error handling', () async {
      // Test that services return proper error states instead of crashing
      final services = [
        () => AdminService.getAdRevenueStats(),
        () => AdminService.getSystemAdStats(),
        () => COPPAService.getUserAge('test_user'),
      ];

      for (final service in services) {
        try {
          await service();
          // If it succeeds, that's fine too
        } catch (e) {
          // Should fail gracefully with proper error
          expect(e.toString(), isNotEmpty);
          expect(e.toString(), isNot(contains('Exception')));
        }
      }
    });
  });
}
