import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/main_bottom_nav.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Section
            Text(
              'Account',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),

            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Profile'),
                    subtitle: const Text('Manage your account'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Navigate to profile
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Navigate to profile')),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.security),
                    title: const Text('Privacy & Security'),
                    subtitle: const Text('Manage your privacy settings'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Navigate to privacy settings
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Navigate to privacy settings')),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.notifications),
                    title: const Text('Notifications'),
                    subtitle: const Text('Configure notification preferences'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Navigate to notifications
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Navigate to notifications')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Family Section
            Text(
              'Family',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),

            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.family_restroom),
                    title: const Text('Family Management'),
                    subtitle: const Text('Manage family members'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Navigate to family management
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Navigate to family management')),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.shield),
                    title: const Text('Parental Controls'),
                    subtitle: const Text('Manage child account settings'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Navigate to parental controls
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Navigate to parental controls')),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.share),
                    title: const Text('Sharing Preferences'),
                    subtitle: const Text('Control what you share with family'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Navigate to sharing preferences
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Navigate to sharing preferences')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // App Section
            Text(
              'App',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),

            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.palette),
                    title: const Text('Appearance'),
                    subtitle: const Text('Theme and display settings'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Navigate to appearance
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Navigate to appearance')),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: const Text('Language'),
                    subtitle: const Text('Change app language'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Navigate to language
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Navigate to language')),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.storage),
                    title: const Text('Storage & Data'),
                    subtitle: const Text('Manage app data and cache'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Navigate to storage
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Navigate to storage')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Support Section
            Text(
              'Support',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),

            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.help),
                    title: const Text('Help & Support'),
                    subtitle: const Text('Get help and contact support'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Navigate to help
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Navigate to help')),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: const Text('About'),
                    subtitle: const Text('App version and information'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Navigate to about
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Navigate to about')),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip),
                    title: const Text('Privacy Policy'),
                    subtitle: const Text('Read our privacy policy'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Navigate to privacy policy
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Navigate to privacy policy')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const Spacer(),

            // Sign Out Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  // TODO: Sign out
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sign out')),
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text('Sign Out'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const MainBottomNav(),
    );
  }
}






