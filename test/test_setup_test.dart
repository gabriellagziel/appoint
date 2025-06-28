import 'package:flutter_test/flutter_test.dart';
import 'package:REDACTED_TOKEN/REDACTED_TOKEN.dart';
import 'test_setup.dart';

void main() {
  setupFirebaseMocks();

  test('setup loads without error', () {
    expect(() => FirebaseAuthPlatform.instance, returnsNormally);
  });
}
