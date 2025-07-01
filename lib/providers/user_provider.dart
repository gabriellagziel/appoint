import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/models/user_type.dart';
import 'package:appoint/features/studio_business/providers/business_mode_provider.dart';
import 'package:appoint/providers/user_profile_provider.dart';

// Combined user data class
class User {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? photoUrl;
  final UserType userType;
  final bool isAdminFreeAccess;

  const User({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.photoUrl,
    required this.userType,
    this.isAdminFreeAccess = false,
  });

  // Convenience getters
  bool get businessMode => userType == UserType.business;
  bool get isStudio => userType == UserType.studio;
  bool get isAdmin => userType == UserType.admin;
  bool get isPersonal => userType == UserType.personal;
  bool get isChild => userType == UserType.child;
}

// Provider that combines user profile and business mode
final userProvider = Provider<User?>((final ref) {
  final profileAsync = ref.watch(currentUserProfileProvider);
  final userType = ref.watch(businessModeProvider);

  return profileAsync.when(
    data: (final profile) {
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
    error: (final _, final __) => null,
  );
});
