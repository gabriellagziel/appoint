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

    testWidgets(
        'should return true when "Keep Mine" is tapped and false when "Keep Server" is tapped',
        (WidgetTester tester) async {
      // Setup: Variables to capture the boolean results
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
                      // "Keep Mine" should return true (keepLocal)
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
                      // "Keep Server" should return false (not keepLocal)
                      keepServerResult = result != ConflictResolution.keepLocal;
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

      // Verify dialog is shown
      expect(find.text('Booking Conflict'), findsOneWidget);
      expect(find.text('Keep My Version'), findsOneWidget);
      expect(find.text('Keep Server Version'), findsOneWidget);

      // Tap "Keep My Version" button
      await tester.tap(find.text('Keep My Version'));
      await tester.pumpAndSettle();

      // Assert that keepMineResult is true
      expect(keepMineResult, isTrue, reason: '"Keep Mine" should return true');

      // Test "Keep Server" returns false
      await tester.tap(find.text('Test Keep Server'));
      await tester.pumpAndSettle();

      // Verify dialog is shown again
      expect(find.text('Booking Conflict'), findsOneWidget);

      // Tap "Keep Server Version" button
      await tester.tap(find.text('Keep Server Version'));
      await tester.pumpAndSettle();

      // Assert that keepServerResult is true (which means it's not keepLocal, so it's false for keepLocal)
      expect(
        keepServerResult,
        isTrue,
        reason: '"Keep Server" should return false (not keepLocal)',
      );
    });

    testWidgets('should return correct boolean values for all dialog options',
        (WidgetTester tester) async {
      // Setup: Variables to capture results
      bool? keepMineResult;
      bool? keepServerResult;
      bool? mergeResult;

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
                        onMerge: () {},
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
                        onMerge: () {},
                      );
                      keepServerResult =
                          result == ConflictResolution.keepRemote;
                    },
                    child: const Text('Test Keep Server'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final result = await showBookingConflictDialog(
                        context,
                        testConflict,
                        onMerge: () {},
                      );
                      mergeResult = result == ConflictResolution.merge;
                    },
                    child: const Text('Test Merge'),
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

      // Test "Keep Server" returns false (when checking for keepLocal)
      await tester.tap(find.text('Test Keep Server'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Keep Server Version'));
      await tester.pumpAndSettle();
      expect(
        keepServerResult,
        isTrue,
        reason: '"Keep Server" should return true for keepRemote',
      );

      // Test "Merge" returns false (when checking for keepLocal)
      await tester.tap(find.text('Test Merge'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Merge Changes'));
      await tester.pumpAndSettle();
      expect(
        mergeResult,
        isTrue,
        reason: '"Merge" should return true for merge',
      );
    });
  });
}
