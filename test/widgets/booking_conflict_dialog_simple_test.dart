import 'package:appoint/exceptions/booking_conflict_exception.dart';
import 'package:appoint/widgets/booking_conflict_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BookingConflictDialog Boolean Return Values', () {
    late BookingConflictException testConflict;

    setUp(() {
      testConflict = BookingConflictException(
        bookingId: 'test-booking-123',
        localUpdatedAt: DateTime(2023, 1, 1, 10),
        remoteUpdatedAt: DateTime(2023, 1, 1, 11),
        message: 'Test conflict message',
      );
    });

    testWidgets('"Keep Mine" should return true', (WidgetTester tester) async {
      // Setup
      bool? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  final dialogResult =
                      await showBookingConflictDialog(context, testConflict);
                  // Convert to boolean: keepLocal = true, others = false
                  result = dialogResult == ConflictResolution.keepLocal;
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      // Show dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Verify dialog is shown
      expect(find.text('Booking Conflict'), findsOneWidget);

      // Tap "Keep My Version" button
      await tester.tap(find.text('Keep My Version'));
      await tester.pumpAndSettle();

      // Assert result is true
      expect(result, isTrue, reason: '"Keep Mine" should return true');
    });

    testWidgets('"Keep Server" should return false',
        (WidgetTester tester) async {
      // Setup
      bool? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  final dialogResult =
                      await showBookingConflictDialog(context, testConflict);
                  // Convert to boolean: keepLocal = true, others = false
                  result = dialogResult == ConflictResolution.keepLocal;
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      // Show dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Verify dialog is shown
      expect(find.text('Booking Conflict'), findsOneWidget);

      // Tap "Keep Server Version" button
      await tester.tap(find.text('Keep Server Version'));
      await tester.pumpAndSettle();

      // Assert result is false
      expect(result, isFalse, reason: '"Keep Server" should return false');
    });

    testWidgets('both options should return correct boolean values',
        (WidgetTester tester) async {
      // Setup
      bool? keepMineResult;
      bool? keepServerResult;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final result = await showBookingConflictDialog(
                        context,
                        testConflict,
                      );
                      keepMineResult = result == ConflictResolution.keepLocal;
                    },
                    child: const Text('Test Keep Mine'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final result = await showBookingConflictDialog(
                        context,
                        testConflict,
                      );
                      keepServerResult = result == ConflictResolution.keepLocal;
                    },
                    child: const Text('Test Keep Server'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Test "Keep Mine" returns true
      await tester.tap(find.text('Test Keep Mine'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Keep My Version'));
      await tester.pumpAndSettle();
      expect(keepMineResult, isTrue, reason: '"Keep Mine" should return true');

      // Test "Keep Server" returns false
      await tester.tap(find.text('Test Keep Server'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Keep Server Version'));
      await tester.pumpAndSettle();
      expect(
        keepServerResult,
        isFalse,
        reason: '"Keep Server" should return false',
      );
    });
  });
}
