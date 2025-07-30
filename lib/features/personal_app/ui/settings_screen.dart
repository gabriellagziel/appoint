import 'package:flutter/material.dart';
import 'package:appoint/widgets/app_logo.dart';
import 'package:appoint/constants/app_branding.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const AppLogo(size: 28, logoOnly: true),
            const SizedBox(width: 8),
            const Text('Settings'),
          ],
        ),
      ),
      body: ListView(
        children: [
          // App branding section
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const AppLogo(size: 64, showText: false),
                const SizedBox(height: 8),
                Text(
                  'APP-OINT',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppBranding.fullSlogan,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),

          // Settings options
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              // Navigate to profile
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            onTap: () {
              // Navigate to notifications
            },
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Privacy & Security'),
            onTap: () {
              // Navigate to privacy settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help & Support'),
            onTap: () {
              // Navigate to help
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () {
              // Navigate to about
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              // Handle logout
            },
          ),
        ],
      ),
    );
  }
}
