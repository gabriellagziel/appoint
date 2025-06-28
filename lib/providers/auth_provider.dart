import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/app_user.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authStateProvider = StreamProvider<AppUser?>(
  (ref) => ref.read(authServiceProvider).authStateChanges(),
);

final authProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});
