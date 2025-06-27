import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/extensions/fl_chart_color_shim.dart';
import './fake_firebase_setup.dart';

// Flutter widgets & material controls

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await initializeTestFirebase();

  testWidgets('OTP flow: send and verify code', (tester) async {}, skip: true);
}
