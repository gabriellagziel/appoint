import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/features/personal_app/ui/settings_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SettingsScreen', () {
    testWidgets('toggles switch and taps sign out', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsScreen(),
        ),
      );

      expect(find.byType(SwitchListTile), findsNWidgets(2));
      expect(find.text('Sign Out'), findsOneWidget);

      await tester.tap(find.byType(SwitchListTile).first);
      await tester.pump();

      final firstSwitch =
          tester.widget<SwitchListTile>(find.byType(SwitchListTile).first);
      expect(firstSwitch.value, isTrue);

      await tester.tap(find.text('Sign Out'));
      await tester.pump();
    });
  });
}
