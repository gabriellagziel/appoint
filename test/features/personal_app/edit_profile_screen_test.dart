import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/features/personal_app/ui/edit_profile_screen.dart';
import '../../fake_firebase_setup.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await initializeTestFirebase();
  group('EditProfileScreen', () {
    testWidgets('renders form fields and save button', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: EditProfileScreen()));

      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text('Username'), findsOneWidget);
      expect(find.text('Bio'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
    });
  });
}
