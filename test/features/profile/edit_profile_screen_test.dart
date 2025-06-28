import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/features/profile/ui/edit_profile_screen.dart';
import '../../fake_firebase_setup.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await initializeTestFirebase();
  group('EditProfileScreen', () {
    testWidgets('shows app bar and form fields', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: EditProfileScreen()));

      expect(find.text('Edit Profile'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(3));
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Bio'), findsOneWidget);
      expect(find.text('Location'), findsOneWidget);
      expect(find.text('Save Changes'), findsOneWidget);
    });
  });
}
