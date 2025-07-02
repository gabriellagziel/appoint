import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appoint/providers/auth_provider.dart';
import 'package:appoint/features/studio_business/entry/business_entry_screen.dart';
import 'package:appoint/features/studio_profile/studio_profile_screen.dart';
import 'package:appoint/features/admin/ui/admin_dashboard_screen.dart';
import 'package:appoint/features/family/screens/family_dashboard_screen.dart';
import 'package:appoint/features/auth/home_screen.dart';
import 'package:appoint/features/auth/login_screen.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (final user) {
        if (user == null) {
          return const LoginScreen();
        }

        switch (user.role) {
          case 'business':
          case 'studio':
            return user.studioId != null
                ? StudioProfileScreen(studioId: user.studioId!)
                : const BusinessEntryScreen();
          case 'admin':
            return const AdminDashboardScreen();
          case 'child':
            return const FamilyDashboardScreen();
          case 'personal':
          default:
            return const HomeScreen();
        }
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (final _, final __) => const Scaffold(
        body: Center(child: Text('Error')),
      ),
    );
  }
}
