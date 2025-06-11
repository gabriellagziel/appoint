class AdminUser {
  final String uid;
  final String email;
  final String displayName;
  final String role;

  AdminUser({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.role,
  });

  factory AdminUser.fromMap(Map<String, dynamic> map, String uid) {
    return AdminUser(
      uid: uid,
      email: map['email'] as String? ?? '',
      displayName: map['displayName'] as String? ?? '',
      role: map['role'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'role': role,
    };
  }
}
