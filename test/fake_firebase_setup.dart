import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';

/// Initializes Firebase for widget tests.
Future<void> initializeTestFirebase() async {
  try {
    await Firebase.initializeApp();
  } catch (e) {
    // If already initialized, continue
  }
}
