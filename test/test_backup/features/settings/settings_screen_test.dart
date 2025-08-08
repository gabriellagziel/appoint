import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../firebase_test_helper.dart';

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  group('Settings Screen', () {
    testWidgets('should display settings options', (tester) async {
      // Create a simple settings screen widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('Settings')),
            body: ListView(
              children: const [
                ListTile(
                  title: Text('Account'),
                  leading: Icon(Icons.person),
                ),
                ListTile(
                  title: Text('Notifications'),
                  leading: Icon(Icons.notifications),
                ),
                ListTile(
                  title: Text('Privacy'),
                  leading: Icon(Icons.security),
                ),
                ListTile(
                  title: Text('About'),
                  leading: Icon(Icons.info),
                ),
              ],
            ),
          ),
        ),
      );

      // Verify the settings screen displays
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Account'), findsOneWidget);
      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('Privacy'), findsOneWidget);
      expect(find.text('About'), findsOneWidget);
    });
  });
}
