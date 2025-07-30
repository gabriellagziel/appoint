import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/features/personal_app/ui/settings_screen.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('SettingsScreen', () {
    testWidgets('toggles switches and taps sign out', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsScreen(),
        ),
      );

      final switches = find.byType(SwitchListTile);
      expect(switches, findsNWidgets(2));

      await tester.tap(switches.at(0));
      await tester.pump();
      await tester.tap(switches.at(1));
      await tester.pump();

      await tester.tap(find.text('Sign Out'));
      await tester.pump();
    });
  });
}
