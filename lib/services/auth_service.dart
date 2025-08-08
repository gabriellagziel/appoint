import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Mock user for web development
class MockAuthUser {
  final String uid;
  final String email;
  final String displayName;
  final bool emailVerified;

  const MockAuthUser({
    required this.uid,
    required this.email,
    required this.displayName,
    this.emailVerified = true,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
        'displayName': displayName,
        'emailVerified': emailVerified,
      };
}

// Web-safe auth service
class AuthService {
  static final firebase_auth.FirebaseAuth _auth =
      firebase_auth.FirebaseAuth.instance;

  // Mock user for web development
  static const MockAuthUser _mockUser = MockAuthUser(
    uid: 'mock-user-123',
    email: 'mock@example.com',
    displayName: 'Mock User',
    emailVerified: true,
  );

  // Get current user with web fallback
  static firebase_auth.User? get currentUser {
    if (kIsWeb) {
      try {
        return _auth.currentUser;
      } catch (e) {
        // Return null for web if Firebase Auth fails
        return null;
      }
    } else {
      return _auth.currentUser;
    }
  }

  // Get current user or mock for web development
  static dynamic get currentUserOrMock {
    if (kIsWeb) {
      try {
        final user = _auth.currentUser;
        return user ?? _mockUser;
      } catch (e) {
        return _mockUser;
      }
    } else {
      return _auth.currentUser;
    }
  }

  // Check if user is authenticated
  static bool get isAuthenticated {
    if (kIsWeb) {
      try {
        return _auth.currentUser != null;
      } catch (e) {
        return false;
      }
    } else {
      return _auth.currentUser != null;
    }
  }

  // Sign in with email and password
  static Future<firebase_auth.UserCredential?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    if (kIsWeb) {
      try {
        return await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } catch (e) {
        // For web development, return null on error
        return null;
      }
    } else {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    }
  }

  // Sign out
  static Future<void> signOut() async {
    if (kIsWeb) {
      try {
        await _auth.signOut();
      } catch (e) {
        // Ignore errors on web for development
      }
    } else {
      await _auth.signOut();
    }
  }

  // Auth state changes with web fallback
  static Stream<firebase_auth.User?> get authStateChanges {
    if (kIsWeb) {
      try {
        return _auth.authStateChanges();
      } catch (e) {
        // Return a stream that emits null for web development
        return Stream.value(null);
      }
    } else {
      return _auth.authStateChanges();
    }
  }

  // Check if running in mock mode (for development)
  static bool get isMockMode {
    return kIsWeb && currentUser == null;
  }
}

// Riverpod providers for auth state
final authStateProvider = StreamProvider<firebase_auth.User?>((ref) {
  return AuthService.authStateChanges;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return AuthService.isAuthenticated;
});

final currentUserProvider = Provider<dynamic>((ref) {
  return AuthService.currentUserOrMock;
});

final isMockModeProvider = Provider<bool>((ref) {
  return AuthService.isMockMode;
});
