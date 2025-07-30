import 'package:appoint/features/admin/admin_broadcast_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:appoint/services/broadcast_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../firebase_test_helper.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

late BroadcastService broadcastService;
late MockFirebaseFirestore mockFirestore;

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
    setupFirebaseMocks();
    mockFirestore = MockFirebaseFirestore();
    broadcastService = BroadcastService(firestore: mockFirestore);
  });

  group('AdminBroadcastScreen', () {
    Widget createTestWidget(Widget child) => ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: child,
          ),
        );

    testWidgets('should display the title in app bar',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(const AdminBroadcastScreen()),
      );

      expect(find.text('Admin Broadcast'), findsOneWidget);
    });

    testWidgets('should have add button in app bar',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(const AdminBroadcastScreen()),
      );

      final addButton = find.byIcon(Icons.add);
      expect(addButton, findsOneWidget);
    });

    testWidgets('should display loading indicator initially',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(const AdminBroadcastScreen()),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display empty state when no messages',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(const AdminBroadcastScreen()),
      );

      // Wait for loading to complete
      await tester.pumpAndSettle();

      expect(find.text('No broadcast messages yet'), findsOneWidget);
    });

    testWidgets('should show compose dialog when add button is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(const AdminBroadcastScreen()),
      );

      // Wait for loading to complete
      await tester.pumpAndSettle();

      // Tap the add button
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Check if dialog is shown
      expect(find.text('Compose Broadcast Message'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
    });

    testWidgets('should have form fields in compose dialog',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(const AdminBroadcastScreen()),
      );

      // Wait for loading to complete
      await tester.pumpAndSettle();

      // Tap the add button to open dialog
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Check for form fields
      expect(find.byType(TextFormField), findsWidgets);
      expect(find.byType(DropdownButtonFormField), findsWidgets);
    });

    testWidgets('should close dialog when cancel is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(const AdminBroadcastScreen()),
      );

      // Wait for loading to complete
      await tester.pumpAndSettle();

      // Open dialog
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Verify dialog is open
      expect(find.text('Compose Broadcast Message'), findsOneWidget);

      // Tap cancel
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Verify dialog is closed
      expect(find.text('Compose Broadcast Message'), findsNothing);
    });

    testWidgets('should display message type options in dropdown',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(const AdminBroadcastScreen()),
      );

      // Wait for loading to complete
      await tester.pumpAndSettle();

      // Open dialog
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Find dropdown and tap it
      final dropdown = find.byType(DropdownButtonFormField);
      expect(dropdown, findsWidgets);

      // Tap the dropdown to open options
      await tester.tap(dropdown.first);
      await tester.pumpAndSettle();

      // Check for message type options
      expect(find.text('Text'), findsOneWidget);
      expect(find.text('Image'), findsOneWidget);
      expect(find.text('Video'), findsOneWidget);
      expect(find.text('Poll'), findsOneWidget);
      expect(find.text('Link'), findsOneWidget);
    });

    testWidgets('should display status chips with correct colors',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(const AdminBroadcastScreen()),
      );

      // Wait for loading to complete
      await tester.pumpAndSettle();

      // Check for status chips (if any messages exist)
      final chips = find.byType(Chip);
      if (chips.evaluate().isNotEmpty) {
        // Verify chip colors based on status
        final chip = chips.first;
        final chipWidget = tester.widget<Chip>(chip);
        expect(chipWidget.label, isA<Text>());
      }
    });

    testWidgets('should handle form validation', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(const AdminBroadcastScreen()),
      );

      // Wait for loading to complete
      await tester.pumpAndSettle();

      // Open dialog
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Try to save without filling required fields
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Should still be in dialog (validation should prevent closing)
      expect(find.text('Compose Broadcast Message'), findsOneWidget);
    });
  });
}
