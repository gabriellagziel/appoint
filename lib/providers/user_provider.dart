import 'package:appoint/features/studio_business/providers/business_mode_provider.dart';
import 'package:appoint/models/user_type.dart';
import 'package:appoint/providers/user_profile_provider.dart';
import 'package:appoint/providers/user_subscription_provider.dart';
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
    this.businessMode = false,
    this.businessProfileId,
  });
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? photoUrl;
  final UserType userType;
  final bool isAdminFreeAccess;
  final bool businessMode;
  final String? businessProfileId;

  // Convenience getters
  bool get isStudio => userType == UserType.studio;
  bool get isAdmin => userType == UserType.admin;
  bool get isPersonal => userType == UserType.personal;
  bool get isChild => userType == UserType.child;
}

// Provider that checks if user is in business mode
final isBusinessProvider = Provider<bool>((ref) {
  final user = ref.watch(userProvider);
  return user?.businessMode ?? false;
});

// Provider that combines user profile and business mode
final userProvider = Provider<User?>((ref) {
  final profileAsync = ref.watch(currentUserProfileProvider);
  final userType = ref.watch(businessModeProvider);

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
        businessMode: profile.businessMode,
        businessProfileId: profile.businessProfileId,
      );
    },
    loading: () => null,
    error: (_, final __) => null,
  );
});

// Provider that determines if ads should be shown
final shouldShowAdsProvider = Provider<bool>((ref) {
  final user = ref.watch(userProvider);
  final subscriptionAsync = ref.watch(userSubscriptionProvider);
  
  // If user has admin free access, don't show ads
  if (user?.isAdminFreeAccess == true) return false;
  
  // Check subscription status
  return subscriptionAsync.maybeWhen(
    data: (isPremium) => !isPremium,
    orElse: () => true, // Show ads by default if subscription status is unknown
  );
});
