import 'user.dart';

/// Response from authentication endpoint
/// 
/// Contains the JWT token and user information after successful login
class AuthResponse {
  /// JWT authentication token
  final String token;
  
  /// User information
  final User user;

  const AuthResponse({
    required this.token,
    required this.user,
  });

  /// Create AuthResponse from JSON
  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user': user.toJson(),
    };
  }

  @override
  String toString() {
    return 'AuthResponse(token: $token, user: $user)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthResponse &&
        other.token == token &&
        other.user == user;
  }

  @override
  int get hashCode => token.hashCode ^ user.hashCode;
} 