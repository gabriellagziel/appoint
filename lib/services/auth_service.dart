import 'package:firebase_auth/firebase_auth.dart';

import 'package:appoint/models/app_user.dart';

class AuthService {
  static const redirectUri = 'http://localhost:8080/__/auth/handler';

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> currentUser() async {
    return _firebaseAuth.currentUser;
  }

  Stream<AppUser?> authStateChanges() {
    return _firebaseAuth.authStateChanges().asyncMap((final user) async {
      if (user == null) return null;
      final token = await user.getIdTokenResult(true);
      final claims = token.claims ?? <String, dynamic>{};
      final role = claims['role'] as String? ?? 'personal';
      return AppUser(
        uid: user.uid,
        email: user.email,
        role: role,
        studioId: claims['studioId'] as String?,
        businessProfileId: claims['businessProfileId'] as String?,
      );
    });
  }

  Future<void> signIn(final String email, final String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<UserCredential> signInWithGooglePopup() async {
    final googleProvider = GoogleAuthProvider();
    googleProvider.setCustomParameters({'redirectUri': redirectUri});
    return _firebaseAuth.signInWithPopup(googleProvider);
  }
}

