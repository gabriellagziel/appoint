import 'package:flutter/material.dart';

/// Simple stub settings screen for the personal app.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: const [
          ListTile(
            title: Text('Notification Preferences'),
          ),
        ],
      ),
    );
  }
}
