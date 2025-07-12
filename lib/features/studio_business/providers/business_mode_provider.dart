import 'package:appoint/models/user_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider to manage the current business mode
businessModeProvider = StateProvider<UserType>((final ref) {
  // Default to personal mode
  return UserType.personal;
});

// Provider to check if user is in business mode
isBusinessModeProvider = Provider<bool>((final ref) {
  mode = ref.watch(businessModeProvider);
  return mode == UserType.business;
});

// Provider to check if user is in studio mode
isStudioModeProvider = Provider<bool>((final ref) {
  mode = ref.watch(businessModeProvider);
  return mode == UserType.studio;
});

// Provider to get the current mode as a string for display
businessModeStringProvider = Provider<String>((final ref) {
  mode = ref.watch(businessModeProvider);
  switch (mode) {
    case UserType.business:
      return 'Business';
    case UserType.studio:
      return 'Studio';
    case UserType.admin:
      return 'Admin';
    case UserType.child:
      return 'Child';
    case UserType.personal:
      return 'Personal';
  }
});
