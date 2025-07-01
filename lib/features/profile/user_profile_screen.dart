import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/providers/auth_provider.dart';
import 'package:appoint/providers/user_profile_provider.dart';
import 'package:appoint/l10n/app_localizations.dart';

class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.myProfile)),
      body: authState.when(
        data: (final user) {
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
            data: (final profile) {
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
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (final _, final __) => Center(child: Text(l10n.errorLoadingProfile)),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (final _, final __) => Center(child: Text(l10n.errorLoadingProfile)),
      ),
    );
  }
}
