import 'package:flutter_test/flutter_test.dart';
import 'test_setup.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('setup loads without error', () async {
    await registerFirebaseMock();
    expect(true, isTrue);
  });
}
