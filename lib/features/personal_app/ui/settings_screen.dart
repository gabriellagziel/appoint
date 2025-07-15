import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const ListTile(
            title: Text('Account'),
            subtitle: Text('gabriel@app-oint.com'), // placeholder
            leading: Icon(Icons.person),
          ),
          SwitchListTile(
            value: false,
            onChanged: (_) {}, // TODO: Connect to settings provider
            title: const Text('Dark Mode'),
            secondary: const Icon(Icons.dark_mode),
          ),
          const Divider(),
          ListTile(
            title: const Text('Privacy Policy'),
            leading: const Icon(Icons.privacy_tip),
            onTap: () {
              // TODO: Open webview or browser
            },
          ),
          ListTile(
            title: const Text('Terms of Service'),
            leading: const Icon(Icons.article),
            onTap: () {
              // TODO: Open webview or browser
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Sign Out'),
            leading: const Icon(Icons.logout),
            onTap: () {
              // TODO: Sign out logic
            },
          ),
        ],
      ),
    );
  }
}
