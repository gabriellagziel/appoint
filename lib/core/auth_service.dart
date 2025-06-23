import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static const redirectUri = 'http://localhost:8080/__/auth/handler';

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> currentUser() async {
    return _firebaseAuth.currentUser;
  }

  Future<void> signIn(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  /// Sign in using Google identity services popup on web
  Future<UserCredential> signInWithGooglePopup() async {
    final googleProvider = GoogleAuthProvider();
    googleProvider.setCustomParameters({'redirectUri': redirectUri});
    return _firebaseAuth.signInWithPopup(googleProvider);
  }
}
