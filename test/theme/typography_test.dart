import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/config/theme.dart';
import 'package:appoint/theme/typography.dart';
import '../fake_firebase_setup.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await initializeTestFirebase();

  test('AppTheme includes typography', () {
    // ignore: prefer_const_declarations
    final themeTextTheme = AppTheme.lightTheme.textTheme;
    // ignore: prefer_const_declarations
    final customTextTheme = AppTypography.textTheme;

    // Check that the theme includes our custom typography properties
    expect(themeTextTheme.headlineLarge?.fontSize,
        customTextTheme.headlineLarge?.fontSize);
    expect(themeTextTheme.headlineMedium?.fontSize,
        customTextTheme.headlineMedium?.fontSize);
    expect(themeTextTheme.bodyMedium?.fontSize,
        customTextTheme.bodyMedium?.fontSize);
    expect(themeTextTheme.bodySmall?.fontSize,
        customTextTheme.bodySmall?.fontSize);
    expect(themeTextTheme.bodySmall?.color, customTextTheme.bodySmall?.color);
  });
}
