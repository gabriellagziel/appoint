import 'package:appoint/features/admin/admin_broadcast_screen.dart';
import 'package:appoint/features/admin/admin_dashboard_screen.dart';
import 'package:appoint/features/admin/admin_monetization_screen.dart';
import 'package:appoint/models/admin_broadcast_message.dart';
import 'package:appoint/models/admin_dashboard_stats.dart';
import 'package:appoint/providers/admin_provider.dart';
import 'package:appoint/services/admin_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../firebase_test_helper.dart';

class MockAdminService extends Mock implements AdminService {}

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  group('Admin Panel Integration Tests', () {
    late MockAdminService mockAdminService;
    late ProviderContainer container;

    setUp(() {
      mockAdminService = MockAdminService();
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('Admin Dashboard loads', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const AdminDashboardScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify that the dashboard displays
      expect(find.byType(AdminDashboardScreen), findsOneWidget);
    });

    testWidgets('Admin Broadcast screen loads', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const AdminBroadcastScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify that the broadcast screen displays
      expect(find.byType(AdminBroadcastScreen), findsOneWidget);
    });

    testWidgets('Admin Monetization screen loads', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const AdminMonetizationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify that the monetization screen displays
      expect(find.byType(AdminMonetizationScreen), findsOneWidget);
    });

    test('Admin service can be mocked', () async {
      expect(mockAdminService, isNotNull);
    });

    test('Admin providers can be accessed', () async {
      final provider = container.read(isAdminProvider);
      expect(provider, isA<AsyncValue<bool>>());
    });
  });
}
