import 'dart:io';

import 'package:appoint/features/admin/ui/admin_dashboard_screen.dart';
import 'package:appoint/features/auth/home_screen.dart';
import 'package:appoint/features/auth/login_screen.dart';
import 'package:appoint/features/family/screens/family_dashboard_screen.dart';
import 'package:appoint/features/studio_business/entry/business_entry_screen.dart';
import 'package:appoint/features/studio_profile/studio_profile_screen.dart';
import 'package:appoint/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, final WidgetRef ref) {
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
      error: (error, final stack) {
        if (error is SocketException) {
          return NetworkErrorRetry(
            onRetry: () => ref.refresh(authStateProvider),
          );
        }
        return const Scaffold(
          body: Center(child: Text('Error')),
        );
      },
    );
  }
}

class NetworkErrorRetry extends StatelessWidget {
  const NetworkErrorRetry({required this.onRetry, super.key});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Network error. Please check your connection and try again.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                onPressed: onRetry,
              ),
            ],
          ),
        ),
      );
}
