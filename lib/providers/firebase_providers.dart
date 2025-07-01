import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';

// Firebase providers that can be overridden in tests
final firestoreProvider = Provider<FirebaseFirestore>(
  (final ref) => FirebaseFirestore.instance,
);

final firebaseAuthProvider = Provider<FirebaseAuth>(
  (final ref) => FirebaseAuth.instance,
);

final firebaseFunctionsProvider = Provider<FirebaseFunctions>(
  (final ref) => FirebaseFunctions.instance,
);
