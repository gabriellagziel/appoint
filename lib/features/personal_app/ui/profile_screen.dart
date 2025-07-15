import 'package:appoint/providers/user_profile_provider.dart';
import 'package:appoint/providers/user_subscription_provider.dart';
import 'package:appoint/theme/app_spacing.dart';
import 'package:appoint/widgets/app_scaffold.dart';
import 'package:appoint/widgets/error_state.dart';
import 'package:appoint/widgets/loading_state.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Displays the current user's profile information.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, final WidgetRef ref) {
    final profileAsync = ref.watch(currentUserProfileProvider);
    final subscriptionAsync = ref.watch(userSubscriptionProvider);

    return AppScaffold(
      title: 'Profile',
      body: profileAsync.when(
        data: (profile) {
          if (profile == null) {
            return const ErrorState(
              title: 'Profile',
              description: 'No profile found',
            );
          }
          return Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  child: Icon(Icons.person,
                      size: 40, semanticLabel: 'profile icon',),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  profile.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                if (profile.email != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(profile.email!),
                ],
                const SizedBox(height: AppSpacing.xs),
                subscriptionAsync.when(
                  data: (isSub) => Text(
                    isSub ? 'Premium Subscriber' : 'Free User'),
                  loading: () => const Text('Checking subscription...'),
                  error: (_, final __) =>
                      const Text('Subscription unavailable'),
                ),
                const SizedBox(height: AppSpacing.md),
                ElevatedButton(
                  onPressed: () async {
                    FirebaseAnalytics.instance
                        .logEvent(name: 'edit_profile_tap');
                    context.push('/profile/edit');
                  },
                  child: const Text('Edit Profile'),
                ),
              ],
            ),
          );
        },
        loading: () => const LoadingState(),
        error: (_, final __) => const ErrorState(
          title: 'Profile',
          description: 'Error loading profile',
        ),
      ),
    );
  }
}
