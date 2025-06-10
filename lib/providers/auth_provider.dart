import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authStateProvider = FutureProvider<User?>(
  (ref) => ref.read(authServiceProvider).currentUser(),
);
