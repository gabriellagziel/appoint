import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> setupFirebaseMocks() async {
  // Initialize Flutter binding first
  TestWidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
  } catch (e) {
    // Firebase might already be initialized, which is fine
  }
}

final mockAuth = MockFirebaseAuth();
