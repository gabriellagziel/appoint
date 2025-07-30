import 'package:flutter/material.dart';

/// TODO: implement per spec §2.1
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _notifications = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: _darkMode,
            onChanged: (value) => setState(() => _darkMode = value),
          ),
          SwitchListTile(
            title: const Text('Notifications'),
            value: _notifications,
            onChanged: (value) => setState(() => _notifications = value),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
