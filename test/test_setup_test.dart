import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'test_setup.dart';

void main() {
  setupFirebaseMocks();

  test('setup loads without error', () {
    expect(() => FirebaseAuthPlatform.instance, returnsNormally);
  });
}
