import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';
import '../../widgets/app_scaffold.dart';

/// Static settings screen with dummy toggles.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = false;
  bool _vibration = false;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Settings',
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: ListView(
          children: [
            SwitchListTile(
              title: const Text('Enable Notifications'),
              value: _notifications,
              onChanged: (value) => setState(() => _notifications = value),
            ),
            const SizedBox(height: AppSpacing.sm),
            SwitchListTile(
              title: const Text('Enable Vibration'),
              value: _vibration,
              onChanged: (value) => setState(() => _vibration = value),
            ),
            const SizedBox(height: AppSpacing.sm),
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: _darkMode,
              onChanged: (value) => setState(() => _darkMode = value),
            ),
          ],
        ),
      ),
    );
  }
}
