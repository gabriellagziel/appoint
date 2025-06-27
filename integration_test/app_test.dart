import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import '../test/fake_firebase_setup.dart';

Future<void> main() async {
  await initializeTestFirebase();
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  test('sample test', () async {
    expect(1 + 1, 2);
  });
}
