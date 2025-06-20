import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth_provider.dart';
import '../../models/user_type.dart';
import '../studio_business/entry/business_entry_screen.dart';
import '../studio_profile/studio_profile_screen.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return const LoginScreen();
        }

        // TODO: Replace this with actual user type detection from Firebase
        // For now, we'll use a simple approach based on user claims or profile
        final userType = _getUserType(user);

        switch (userType) {
          case UserType.business:
            return const BusinessEntryScreen();
          case UserType.studio:
            // TODO: Replace 'studioId' with actual studioId from user profile
            return const StudioProfileScreen(studioId: 'studioId');
          case UserType.admin:
            // TODO: Add admin routing when admin screens are ready
            return const HomeScreen();
          case UserType.child:
            // TODO: Add child routing when child screens are ready
            return const HomeScreen();
          case UserType.personal:
            return const HomeScreen();
        }
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const Scaffold(
        body: Center(child: Text('Error')),
      ),
    );
  }

  /// Temporary method to determine user type
  /// TODO: Replace with actual Firebase user claims or profile data
  UserType _getUserType(dynamic user) {
    // For now, return personal as default
    // This should be replaced with actual user type detection logic
    return UserType.personal;
  }
}
