import 'package:appoint/providers/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A widget that only shows its child if the user has admin privileges.
/// Shows an access denied screen for non-admin users.
class AdminGuard extends ConsumerWidget {

  const AdminGuard({
    required this.child, super.key,
    this.customMessage,
    this.customAccessDeniedWidget,
  });
  final Widget child;
  final String? customMessage;
  final Widget? customAccessDeniedWidget;

  @override
  Widget build(BuildContext context, final WidgetRef ref) {
    final isAdmin = ref.watch(isAdminProvider);

    return isAdmin.when(
      data: (hasAdminAccess) {
        if (!hasAdminAccess) {
          return customAccessDeniedWidget ?? _buildDefaultAccessDeniedScreen();
        }
        return child;
      },
      loading: () => const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Checking permissions...'),
            ],
          ),
        ),
      ),
      error: (error, final stack) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              const Text(
                'Error Checking Permissions',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Error: $error',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultAccessDeniedScreen() => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.admin_panel_settings,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'Access Denied',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              customMessage ??
                  'You do not have permission to access this feature.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Please contact your administrator if you believe this is an error.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
}

/// A mixin that provides admin role checking functionality
mixin AdminRoleMixin {
  /// Checks if the current user has admin privileges
  Future<bool> checkAdminRole(WidgetRef ref) async {
    try {
      return await ref.read(isAdminProvider.future);
    } catch (e) {
      return false;
    }
  }

  /// Shows an access denied snackbar
  void showAccessDeniedSnackBar(final BuildContext context,
      {String? message,}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            message ?? 'You do not have permission to perform this action.',),
        backgroundColor: Colors.red,
      ),
    );
  }
}
