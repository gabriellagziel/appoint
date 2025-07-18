import 'package:appoint/models/app_user.dart';
import 'package:appoint/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for the authentication service
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

/// Provider for Firebase Auth instance
final authProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

/// Provider that watches the authentication state changes
final authStateProvider = StreamProvider<AppUser?>(
  (ref) => ref.read(authServiceProvider).authStateChanges(),
);

/// Provider for the current authenticated user
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (appUser) => appUser?.firebaseUser,
    loading: () => null,
    error: (_, __) => null,
  );
});

/// Provider to check if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user != null;
});

/// Provider for user ID
final userIdProvider = Provider<String?>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.uid;
});
