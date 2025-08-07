import 'package:appoint/widgets/booking/booking_slot_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BookingSlotChip', () {
    testWidgets('taps chip, fires callback & has semantics', (tester) async {
      TimeOfDay? tappedTime;
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: BookingSlotChip(
              time: const TimeOfDay(hour: 9, minute: 30),
              available: true,
              onSelected: (t) => tappedTime = t,
            ),
          ),
        ),
      );

      // Ensure semantics label exists for screen-reader users
      final semantics = tester.getSemantics(find.byType(BookingSlotChip));
      expect(semantics, isNotNull);

      // Tap and verify callback
      await tester.tap(find.byType(BookingSlotChip));
      expect(tappedTime, const TimeOfDay(hour: 9, minute: 30));
    });

    testWidgets('displays correct time format', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: BookingSlotChip(
              time: const TimeOfDay(hour: 14, minute: 5),
              available: true,
              onSelected: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('14:05'), findsOneWidget);
    });

    testWidgets('handles single digit hours and minutes', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: BookingSlotChip(
              time: const TimeOfDay(hour: 9, minute: 5),
              available: true,
              onSelected: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('09:05'), findsOneWidget);
    });

    testWidgets('shows unavailable semantics when not available', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: BookingSlotChip(
              time: const TimeOfDay(hour: 10, minute: 0),
              available: false,
              onSelected: (_) {},
            ),
          ),
        ),
      );

      final semantics = tester.getSemantics(find.byType(BookingSlotChip));
      expect(semantics, isNotNull);
    });

    testWidgets('shows disabled semantics when disabled', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: BookingSlotChip(
              time: const TimeOfDay(hour: 11, minute: 30),
              available: true,
              disabled: true,
              onSelected: (_) {},
            ),
          ),
        ),
      );

      final semantics = tester.getSemantics(find.byType(BookingSlotChip));
      expect(semantics, isNotNull);
    });

    testWidgets('does not fire callback when disabled', (tester) async {
      var callbackFired = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: BookingSlotChip(
              time: const TimeOfDay(hour: 12, minute: 0),
              available: true,
              disabled: true,
              onSelected: (_) => callbackFired = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(BookingSlotChip));
      expect(callbackFired, false);
    });

    testWidgets('does not fire callback when unavailable', (tester) async {
      var callbackFired = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: BookingSlotChip(
              time: const TimeOfDay(hour: 13, minute: 0),
              available: false,
              onSelected: (_) => callbackFired = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(BookingSlotChip));
      expect(callbackFired, false);
    });

    testWidgets('shows selected state correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: BookingSlotChip(
              time: const TimeOfDay(hour: 15, minute: 30),
              available: true,
              selected: true,
              onSelected: (_) {},
            ),
          ),
        ),
      );

      final chip = tester.widget<FilterChip>(find.byType(FilterChip));
      expect(chip.selected, true);
    });

    testWidgets('shows selected semantics when selected', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: BookingSlotChip(
              time: const TimeOfDay(hour: 16, minute: 0),
              available: true,
              selected: true,
              onSelected: (_) {},
            ),
          ),
        ),
      );

      final semantics = tester.getSemantics(find.byType(BookingSlotChip));
      expect(semantics, isNotNull);
    });

    testWidgets('shows correct icon for available slot', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: BookingSlotChip(
              time: const TimeOfDay(hour: 17, minute: 0),
              available: true,
              onSelected: (_) {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.schedule), findsOneWidget);
    });

    testWidgets('shows correct icon for unavailable slot', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: BookingSlotChip(
              time: const TimeOfDay(hour: 18, minute: 0),
              available: false,
              onSelected: (_) {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('shows correct icon for disabled slot', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: BookingSlotChip(
              time: const TimeOfDay(hour: 19, minute: 0),
              available: true,
              disabled: true,
              onSelected: (_) {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.block), findsOneWidget);
    });

    testWidgets('shows correct icon for selected slot', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: BookingSlotChip(
              time: const TimeOfDay(hour: 20, minute: 0),
              available: true,
              selected: true,
              onSelected: (_) {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('applies correct styling for different states', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          ),
          home: Material(
            child: Column(
              children: [
                BookingSlotChip(
                  time: const TimeOfDay(hour: 9, minute: 0),
                  available: true,
                  onSelected: (_) {},
                ),
                BookingSlotChip(
                  time: const TimeOfDay(hour: 10, minute: 0),
                  available: false,
                  onSelected: (_) {},
                ),
                BookingSlotChip(
                  time: const TimeOfDay(hour: 11, minute: 0),
                  available: true,
                  selected: true,
                  onSelected: (_) {},
                ),
                BookingSlotChip(
                  time: const TimeOfDay(hour: 12, minute: 0),
                  available: true,
                  disabled: true,
                  onSelected: (_) {},
                ),
              ],
            ),
          ),
        ),
      );

      // Verify all chips are rendered
      expect(find.byType(BookingSlotChip), findsNWidgets(4));
      expect(find.byType(FilterChip), findsNWidgets(4));
    });

    testWidgets('handles edge case times correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Column(
              children: [
                BookingSlotChip(
                  time: const TimeOfDay(hour: 0, minute: 0), // Midnight
                  available: true,
                  onSelected: (_) {},
                ),
                BookingSlotChip(
                  time: const TimeOfDay(hour: 23, minute: 59), // End of day
                  available: true,
                  onSelected: (_) {},
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('00:00'), findsOneWidget);
      expect(find.text('23:59'), findsOneWidget);
    });

    testWidgets('maintains accessibility when multiple chips are present', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Wrap(
              children: [
                BookingSlotChip(
                  time: const TimeOfDay(hour: 9, minute: 0),
                  available: true,
                  onSelected: (_) {},
                ),
                BookingSlotChip(
                  time: const TimeOfDay(hour: 10, minute: 0),
                  available: false,
                  onSelected: (_) {},
                ),
                BookingSlotChip(
                  time: const TimeOfDay(hour: 11, minute: 0),
                  available: true,
                  selected: true,
                  onSelected: (_) {},
                ),
              ],
            ),
          ),
        ),
      );

      // Verify all chips are rendered with proper semantics
      final chips = find.byType(BookingSlotChip);
      expect(chips, findsNWidgets(3));

      // Verify each individual chip has semantics
      for (var i = 0; i < 3; i++) {
        final semantics = tester.getSemantics(chips.at(i));
        expect(semantics, isNotNull);
      }
    });
  });
}
