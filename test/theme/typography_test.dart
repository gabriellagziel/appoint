import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/config/theme.dart';
import 'package:appoint/theme/typography.dart';
import '../fake_firebase_setup.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await initializeTestFirebase();

  test('AppTheme includes typography', () {
    expect(AppTheme.lightTheme.textTheme, AppTypography.textTheme);
  });
}
