import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_role_provider.dart';
import '../models/user_role.dart';
import '../features/business/screens/business_dashboard_screen.dart';
import '../l10n/app_localizations.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(userRoleProvider);
    final l10n = AppLocalizations.of(context)!;

    switch (role) {
      case UserRole.business:
        return const BusinessDashboardScreen();
      case UserRole.staff:
        return Scaffold(body: Center(child: Text(l10n.staffScreenTBD)));
      case UserRole.admin:
        return Scaffold(body: Center(child: Text(l10n.adminScreenTBD)));
      case UserRole.client:
        return Scaffold(body: Center(child: Text(l10n.clientScreenTBD)));
    }
  }
}
