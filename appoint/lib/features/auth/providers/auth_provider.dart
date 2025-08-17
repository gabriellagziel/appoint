import 'package:flutter_riverpod/flutter_riverpod.dart';

// Simple user model for demo purposes
class User {
  final String uid;
  final String email;
  final String? displayName;

  const User({
    required this.uid,
    required this.email,
    this.displayName,
  });
}

// Simple auth state for demo purposes
class AuthState {
  final User? user;
  final bool isLoading;

  const AuthState({
    this.user,
    this.isLoading = false,
  });

  AuthState copyWith({
    User? user,
    bool? isLoading,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// Demo auth provider - in real app, this would connect to Firebase Auth
final authStateProvider = StateProvider<AuthState?>((ref) {
  // For demo purposes, return a mock user
  return const AuthState(
    user: User(
      uid: 'demo-user-123',
      email: 'demo@example.com',
      displayName: 'Demo User',
    ),
  );
});
