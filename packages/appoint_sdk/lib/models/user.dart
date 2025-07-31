/// User model representing a user in the App-Oint system
/// 
/// Contains user profile information including ID, email, name, role, and creation date
class User {
  /// Unique user identifier
  final String id;
  
  /// User's email address
  final String email;
  
  /// User's display name
  final String name;
  
  /// User's role in the system
  final UserRole role;
  
  /// When the user account was created
  final DateTime createdAt;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.createdAt,
  });

  /// Create User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      role: UserRole.values.firstWhere(
        (role) => role.name == json['role'],
        orElse: () => UserRole.user,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, name: $name, role: $role, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.id == id &&
        other.email == email &&
        other.name == name &&
        other.role == role &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return Object.hash(id, email, name, role, createdAt);
  }
}

/// User roles in the App-Oint system
enum UserRole {
  /// Regular user
  user,
  
  /// Business owner/manager
  business,
  
  /// System administrator
  admin,
} 