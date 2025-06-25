import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  test('sample test', () async {
    expect(1 + 1, 2);
  });
}
