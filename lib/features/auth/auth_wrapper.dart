import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth_provider.dart';
import '../studio_business/entry/business_entry_screen.dart';
import '../studio_profile/studio_profile_screen.dart';
import '../admin/ui/admin_dashboard_screen.dart';
import '../family/screens/family_dashboard_screen.dart';
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
      error: (_, __) => const Scaffold(
        body: Center(child: Text('Error')),
      ),
    );
  }
}
