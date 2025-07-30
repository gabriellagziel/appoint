import 'package:appoint/features/ambassador_dashboard_screen.dart';
import 'package:appoint/services/branch_service.dart';
import 'package:appoint/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'firebase_test_helper.dart';

class MockNotificationService extends Mock implements NotificationService {}

class MockBranchService extends Mock implements BranchService {}

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  group('Ambassador Dashboard Tests', () {
    late MockNotificationService mockNotificationService;
    late MockBranchService mockBranchService;

    setUp(() {
      mockNotificationService = MockNotificationService();
      mockBranchService = MockBranchService();
    });

    testWidgets('should display ambassador dashboard',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AmbassadorDashboardScreen(
            notificationService: mockNotificationService,
            branchService: mockBranchService,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify the dashboard displays
      expect(find.byType(AmbassadorDashboardScreen), findsOneWidget);
    });

    test('services can be mocked', () async {
      expect(mockNotificationService, isNotNull);
      expect(mockBranchService, isNotNull);
    });
  });
}
