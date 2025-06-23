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
}
