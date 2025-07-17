import 'package:appoint/models/user_role.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Provides the current signed-in user's role derived from Firebase custom
/// claims. Falls back to [UserRole.client] when unauthenticated or when the
/// claim is missing / malformed.
final userRoleProvider = FutureProvider<UserRole>((ref) async {
  final auth = FirebaseAuth.instance;
  final user = auth.currentUser;

  // Default role when no authenticated user.
  if (user == null) return UserRole.client;

  // Force refresh to ensure latest custom claims.
  final idToken = await user.getIdTokenResult(true);
  final roleClaim = (idToken.claims ?? {})['role'] as String?;

  return UserRole.values.firstWhere(
    (e) => describeEnum(e) == roleClaim,
    orElse: () => UserRole.client,
  );
});
