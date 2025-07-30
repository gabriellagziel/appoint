import 'package:appoint/l10n/app_localizations.dart';
import 'package:appoint/providers/auth_provider.dart';
import 'package:appoint/providers/user_profile_provider.dart';
import 'package:appoint/services/user_deletion_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen({super.key});

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone and will permanently remove all your data including:\n\n'
            '• Your profile information\n'
            '• All bookings and appointments\n'
            '• Chat messages\n'
            '• Payment history\n'
            '• Settings and preferences\n\n'
            'This action is irreversible.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteAccount(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red),
              child: const Text('Delete Account'),
            ),
          ],
        ),
    );
  }

  Future<void> _deleteAccount(BuildContext context) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => const AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text('Deleting account...'),
              ],
            ),
          ),
      );

      // Delete the account
      final deletionService = UserDeletionService();
      await deletionService.deleteCurrentUser();

      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Navigate to login/onboarding
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/',
          (route) => false,
        );
      }
    } catch (e) {
        Navigator.of(context).pop();
        
        // Show error message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete account: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
    }
  }

  @override
  Widget build(BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.myProfile)),
      body: authState.when(
        data: (user) {
          if (user == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Please log in to view your profile.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/');
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            );
          }
          final profileAsync = ref.watch(currentUserProfileProvider);
          return profileAsync.when(
            data: (profile) {
              if (profile == null) {
                return Center(child: Text(l10n.noProfileFound));
              }
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name: ${profile.name}'),
                    Text('Email: ${profile.email}'),
                    const SizedBox(height: 32),
                    const Divider(),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _showDeleteAccountDialog(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Delete My Account'),
                      ),
                    ),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, final __) =>
                Center(child: Text(l10n.errorLoadingProfile)),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, final __) =>
            Center(child: Text(l10n.errorLoadingProfile)),
      ),
    );
  }
}
