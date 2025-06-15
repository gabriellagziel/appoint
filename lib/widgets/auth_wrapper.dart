import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_role_provider.dart';
import '../models/user_role.dart';
import '../features/business/screens/business_dashboard_screen.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(userRoleProvider);

    switch (role) {
      case UserRole.business:
        return const BusinessDashboardScreen();
      case UserRole.staff:
        return const Scaffold(body: Center(child: Text('Staff screen TBD')));
      case UserRole.admin:
        return const Scaffold(body: Center(child: Text('Admin screen TBD')));
      case UserRole.client:
        return const Scaffold(body: Center(child: Text('Client screen TBD')));
    }
  }
}
