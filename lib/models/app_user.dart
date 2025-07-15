import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

/// User model that combines Firebase user data with custom app data
@freezed
class AppUser with _$AppUser {
  const factory AppUser({
    required String uid,
    required String role,
    String? email,
    String? displayName,
    String? photoURL,
    String? studioId,
    String? businessProfileId,
    bool? emailVerified,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    Map<String, dynamic>? customClaims,
    @JsonKey(includeFromJson: false, includeToJson: false) User? firebaseUser,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);

  factory AppUser.fromFirebaseUser(User firebaseUser, {Map<String, dynamic>? customClaims}) {
    return AppUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: firebaseUser.displayName,
      photoURL: firebaseUser.photoURL,
      emailVerified: firebaseUser.emailVerified,
      role: customClaims?['role'] ?? 'user',
      studioId: customClaims?['studioId'],
      businessProfileId: customClaims?['businessProfileId'],
      customClaims: customClaims,
      firebaseUser: firebaseUser,
    );
  }
}

/// User roles enum
enum UserRole {
  user,
  ambassador,
  business,
  admin,
  superAdmin;

  String get value => name;
  
  static UserRole fromString(String role) {
    return UserRole.values.firstWhere(
      (r) => r.value == role,
      orElse: () => UserRole.user,
    );
  }
}
