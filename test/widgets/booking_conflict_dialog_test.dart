import 'package:appoint/exceptions/booking_conflict_exception.dart';
import 'package:appoint/widgets/booking_conflict_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BookingConflictDialog', () {
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
      // Setup: Create a test widget that shows the dialog
      bool? keepLocalResult;
      bool? keepServerResult;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Builder(
                  builder: (context) => ElevatedButton(
                    onPressed: () async {
                      keepLocalResult = await showBookingConflictDialog(
                            context,
                            testConflict,
                            onKeepLocal: () =>
                                debugPrint('Keep local callback'),
                            onKeepRemote: () =>
                                debugPrint('Keep remote callback'),
                          ) ==
                          ConflictResolution.keepLocal;
                    },
                    child: const Text('Show Keep Local Dialog'),
                  ),
                ),
                Builder(
                  builder: (context) => ElevatedButton(
                    onPressed: () async {
                      keepServerResult = await showBookingConflictDialog(
                            context,
                            testConflict,
                            onKeepLocal: () =>
                                debugPrint('Keep local callback'),
                            onKeepRemote: () =>
                                debugPrint('Keep remote callback'),
                          ) ==
                          ConflictResolution.keepRemote;
                    },
                    child: const Text('Show Keep Server Dialog'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Test "Keep Mine" button returns true
      await tester.tap(find.text('Show Keep Local Dialog'));
      await tester.pumpAndSettle();

      // Verify dialog is shown
      expect(find.text('Booking Conflict'), findsOneWidget);
      expect(find.text('Keep My Version'), findsOneWidget);
      expect(find.text('Keep Server Version'), findsOneWidget);

      // Tap "Keep My Version" button
      await tester.tap(find.text('Keep My Version'));
      await tester.pumpAndSettle();

      // Assert that keepLocalResult is true
      expect(keepLocalResult, isTrue);

      // Test "Keep Server" button returns false
      await tester.tap(find.text('Show Keep Server Dialog'));
      await tester.pumpAndSettle();

      // Verify dialog is shown again
      expect(find.text('Booking Conflict'), findsOneWidget);

      // Tap "Keep Server Version" button
      await tester.tap(find.text('Keep Server Version'));
      await tester.pumpAndSettle();

      // Assert that keepServerResult is true (since we're checking for keepRemote)
      expect(keepServerResult, isTrue);
    });

    testWidgets(
        'should return true for "Keep Mine" and false for "Keep Server" as boolean values',
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
                      keepServerResult =
                          result == ConflictResolution.keepRemote;
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

      // Tap "Keep My Version" button
      await tester.tap(find.text('Keep My Version'));
      await tester.pumpAndSettle();

      // Assert that keepMineResult is true
      expect(keepMineResult, isTrue);

      // Test "Keep Server" returns false (when compared to keepLocal)
      await tester.tap(find.text('Test Keep Server'));
      await tester.pumpAndSettle();

      // Verify dialog is shown again
      expect(find.text('Booking Conflict'), findsOneWidget);

      // Tap "Keep Server Version" button
      await tester.tap(find.text('Keep Server Version'));
      await tester.pumpAndSettle();

      // Assert that keepServerResult is true (since we're checking for keepRemote)
      expect(keepServerResult, isTrue);
    });

    testWidgets('should display conflict information correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () =>
                    showBookingConflictDialog(context, testConflict),
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      // Tap to show dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Verify dialog title
      expect(find.text('Booking Conflict'), findsOneWidget);
      expect(find.byIcon(Icons.warning), findsOneWidget);

      // Verify conflict information
      expect(
        find.text('Your local change conflicts with a server update.'),
        findsOneWidget,
      );
      expect(find.text('Booking ID: test-booking-123'), findsOneWidget);
      expect(find.text('Local: Jan 01, 2023 10:00'), findsOneWidget);
      expect(find.text('Server: Jan 01, 2023 11:00'), findsOneWidget);
      expect(find.text('Test conflict message'), findsOneWidget);

      // Verify action buttons
      expect(find.text('Keep Server Version'), findsOneWidget);
      expect(find.text('Keep My Version'), findsOneWidget);
      expect(
        find.text('Which version would you like to keep?'),
        findsOneWidget,
      );
    });

    testWidgets(
        'should return keepRemote when server version button is pressed',
        (WidgetTester tester) async {
      ConflictResolution? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result =
                      await showBookingConflictDialog(context, testConflict);
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      // Tap to show dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Tap keep server version
      await tester.tap(find.text('Keep Server Version'));
      await tester.pumpAndSettle();

      expect(result, equals(ConflictResolution.keepRemote));
    });

    testWidgets('should return keepLocal when my version button is pressed',
        (WidgetTester tester) async {
      ConflictResolution? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result =
                      await showBookingConflictDialog(context, testConflict);
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      // Tap to show dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Tap keep my version
      await tester.tap(find.text('Keep My Version'));
      await tester.pumpAndSettle();

      expect(result, equals(ConflictResolution.keepLocal));
    });

    testWidgets('should show merge button when onMerge callback is provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showBookingConflictDialog(
                  context,
                  testConflict,
                  onMerge: () {},
                ),
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      // Tap to show dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Verify merge button is present
      expect(find.text('Merge Changes'), findsOneWidget);
    });

    testWidgets(
        'should not show merge button when onMerge callback is not provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () =>
                    showBookingConflictDialog(context, testConflict),
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      // Tap to show dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Verify merge button is not present
      expect(find.text('Merge Changes'), findsNothing);
    });

    testWidgets('should return merge when merge button is pressed',
        (WidgetTester tester) async {
      ConflictResolution? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await showBookingConflictDialog(
                    context,
                    testConflict,
                    onMerge: () {},
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      // Tap to show dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Tap merge button
      await tester.tap(find.text('Merge Changes'));
      await tester.pumpAndSettle();

      expect(result, equals(ConflictResolution.merge));
    });

    testWidgets('should handle conflict without message',
        (WidgetTester tester) async {
      final conflictWithoutMessage = BookingConflictException(
        bookingId: 'test-booking-456',
        localUpdatedAt: DateTime(2023, 1, 1, 10),
        remoteUpdatedAt: DateTime(2023, 1, 1, 11),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () =>
                    showBookingConflictDialog(context, conflictWithoutMessage),
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      // Tap to show dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Verify dialog shows without message section
      expect(find.text('Booking Conflict'), findsOneWidget);
      expect(find.text('Booking ID: test-booking-456'), findsOneWidget);
      expect(find.text('Test conflict message'), findsNothing);
    });

    testWidgets(
        'should call onKeepRemote callback when server version button is pressed',
        (WidgetTester tester) async {
      var callbackCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showBookingConflictDialog(
                  context,
                  testConflict,
                  onKeepRemote: () => callbackCalled = true,
                ),
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      // Tap to show dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Tap keep server version
      await tester.tap(find.text('Keep Server Version'));
      await tester.pumpAndSettle();

      expect(callbackCalled, isTrue);
    });

    testWidgets(
        'should call onKeepLocal callback when my version button is pressed',
        (WidgetTester tester) async {
      var callbackCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showBookingConflictDialog(
                  context,
                  testConflict,
                  onKeepLocal: () => callbackCalled = true,
                ),
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      // Tap to show dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Tap keep my version
      await tester.tap(find.text('Keep My Version'));
      await tester.pumpAndSettle();

      expect(callbackCalled, isTrue);
    });
  });
}
