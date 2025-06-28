import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import '../../../providers/user_profile_provider.dart';
import '../../../providers/user_subscription_provider.dart';

/// Displays the current user's profile information.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentUserProfileProvider);
    final subscriptionAsync = ref.watch(userSubscriptionProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: profileAsync.when(
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('No profile found'));
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 40,
                  child: Icon(Icons.person, size: 40),
                ),
                const SizedBox(height: 16),
                Text(
                  profile.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                if (profile.email != null) ...[
                  const SizedBox(height: 8),
                  Text(profile.email!),
                ],
                const SizedBox(height: 8),
                subscriptionAsync.when(
                  data: (isSub) => Text(
                    isSub ? 'Premium Subscriber' : 'Free User',
                  ),
                  loading: () => const Text('Checking subscription...'),
                  error: (_, __) => const Text('Subscription unavailable'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    FirebaseAnalytics.instance
                        .logEvent(name: 'edit_profile_tap');
                    await Navigator.pushNamed(context, '/profile/edit');
                  },
                  child: const Text('Edit Profile'),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Error loading profile')),
      ),
    );
  }
}
