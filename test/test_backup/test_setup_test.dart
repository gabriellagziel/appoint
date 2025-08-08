import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'fake_firebase_setup.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Firebase initializes with mocks', () async {
    final app = await initializeTestFirebase();
    expect(Firebase.apps.isNotEmpty, isTrue);
    expect(app, isA<FirebaseApp>());
  });
}
