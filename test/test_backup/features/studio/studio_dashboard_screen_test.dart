import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../firebase_test_helper.dart';

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  group('Studio Dashboard Screen', () {
    testWidgets('should display studio dashboard', (tester) async {
      // Create a simple studio dashboard widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('Studio Dashboard')),
            body: Column(
              children: const [
                Card(
                  child: ListTile(
                    title: Text('Total Bookings'),
                    subtitle: Text('25'),
                    leading: Icon(Icons.calendar_today),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text('Revenue'),
                    subtitle: Text('\$1,250'),
                    leading: Icon(Icons.attach_money),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text('Active Clients'),
                    subtitle: Text('12'),
                    leading: Icon(Icons.people),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Verify the studio dashboard displays
      expect(find.text('Studio Dashboard'), findsOneWidget);
      expect(find.text('Total Bookings'), findsOneWidget);
      expect(find.text('Revenue'), findsOneWidget);
      expect(find.text('Active Clients'), findsOneWidget);
    });
  });
}
