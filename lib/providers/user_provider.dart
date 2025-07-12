import 'package:appoint/features/studio_business/providers/business_mode_provider.dart';
import 'package:appoint/models/user_type.dart';
import 'package:appoint/providers/user_profile_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Combined user data class
class User {

  const User({
    required this.id,
    required this.name,
    required this.userType, this.email,
    this.phone,
    this.photoUrl,
    this.isAdminFreeAccess = false,
  });
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? photoUrl;
  final UserType userType;
  final bool isAdminFreeAccess;

  // Convenience getters
  bool get businessMode => userType == UserType.business;
  bool get isStudio => userType == UserType.studio;
  bool get isAdmin => userType == UserType.admin;
  bool get isPersonal => userType == UserType.personal;
  bool get isChild => userType == UserType.child;
}

// Provider that combines user profile and business mode
userProvider = Provider<User?>((final ref) {
  profileAsync = ref.watch(currentUserProfileProvider);
  userType = ref.watch(businessModeProvider);

  return profileAsync.when(
    data: (profile) {
      if (profile == null) return null;

      return User(
        id: profile.id,
        name: profile.name,
        email: profile.email,
        phone: profile.phone,
        photoUrl: profile.photoUrl,
        userType: userType,
        isAdminFreeAccess: profile.isAdminFreeAccess ?? false,
      );
    },
    loading: () => null,
    error: (_, final __) => null,
  );
});
