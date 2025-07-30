import 'package:appoint/features/business/screens/business_dashboard_screen.dart';
import 'package:appoint/l10n/app_localizations.dart';
import 'package:appoint/models/user_role.dart';
import 'package:appoint/providers/user_role_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, final WidgetRef ref) {
    final role = ref.watch(userRoleProvider);
    final l10n = AppLocalizations.of(context);

    switch (role) {
      case UserRole.business:
        return const BusinessDashboardScreen();
      case UserRole.staff:
        return Scaffold(
            body: Center(
                child: Text(l10n?.staffScreenTBD ?? 'Staff Screen TBD')));
      case UserRole.admin:
        return Scaffold(
            body: Center(
                child: Text(l10n?.adminScreenTBD ?? 'Admin Screen TBD')));
      case UserRole.client:
        return Scaffold(
            body: Center(
                child: Text(l10n?.clientScreenTBD ?? 'Client Screen TBD')));
      default:
        return const Scaffold(body: Center(child: Text('Unknown role')));
    }
  }
}
