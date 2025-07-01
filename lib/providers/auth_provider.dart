import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:appoint/models/app_user.dart';

final authServiceProvider = Provider<AuthService>((final ref) => AuthService());

final authStateProvider = StreamProvider<AppUser?>(
  (final ref) => ref.read(authServiceProvider).authStateChanges(),
);

final authProvider = Provider<FirebaseAuth>((final ref) {
  return FirebaseAuth.instance;
});
