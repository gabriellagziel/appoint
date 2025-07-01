import 'package:firebase_core/firebase_core.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:appoint/providers/firebase_providers.dart';

/// Initialize mock Firebase for widget tests
Future<void> setupFirebaseMocks() async {
  // Initialize Firebase if needed
  try {
    await Firebase.initializeApp();
  } catch (_) {}

  // Override your app's Firestore and Auth providers here, e.g.:
  // Note: You'll need to override specific providers in your test files
  // since we can't directly override Firebase.instance here
}

/// Create a ProviderContainer with overridden Firebase providers for testing
Future<ProviderContainer> createTestContainer() async {
  // Ensure Firebase is initialized first
  try {
    await Firebase.initializeApp();
  } catch (_) {}

  final firestore = FakeFirebaseFirestore();
  final auth = MockFirebaseAuth();

  return ProviderContainer(
    overrides: [
      // Override Firebase providers here
      firestoreProvider.overrideWithValue(firestore),
      firebaseAuthProvider.overrideWithValue(auth),
      // Note: FirebaseFunctions is complex to mock, so we'll use the real one for now
      // In a real app, you might want to create a more sophisticated mock
      firebaseFunctionsProvider.overrideWithValue(FirebaseFunctions.instance),
    ],
  );
}
