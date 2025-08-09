import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((_) => FirebaseAuth.instance);

final currentUserIdProvider = Provider<String?>((ref) {
  return ref.watch(firebaseAuthProvider).currentUser?.uid;
});


