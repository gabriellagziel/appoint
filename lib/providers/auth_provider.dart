import 'package:appoint/models/app_user.dart';
import 'package:appoint/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

authServiceProvider = Provider<AuthService>((final ref) => AuthService());

final authStateProvider = StreamProvider<AppUser?>(
  (ref) => ref.read(authServiceProvider).authStateChanges(),
);

authProvider = Provider<FirebaseAuth>((final ref) => FirebaseAuth.instance);
