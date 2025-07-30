import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'firebase_test_helper.dart';

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  group('BottomSheet', () {
    testWidgets('opens and closes correctly', (tester) async {
      // Create a simple widget with a button that shows a bottom sheet
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => Container(
                      height: 200,
                      child: const Center(
                        child: Text('Bottom Sheet Content'),
                      ),
                    ),
                  );
                },
                child: const Text('Show Bottom Sheet'),
              ),
            ),
          ),
        ),
      );

      // Tap the button to show the bottom sheet
      await tester.tap(find.text('Show Bottom Sheet'));
      await tester.pumpAndSettle();

      // Verify the bottom sheet is shown
      expect(find.text('Bottom Sheet Content'), findsOneWidget);

      // Tap outside to dismiss
      await tester.tapAt(const Offset(100, 100));
      await tester.pumpAndSettle();

      // Verify the bottom sheet is dismissed
      expect(find.text('Bottom Sheet Content'), findsNothing);
    });
  });
}
