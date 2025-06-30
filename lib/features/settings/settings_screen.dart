import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/theme_provider.dart';
import '../../theme/app_spacing.dart';
import '../../theme/sample_palettes.dart';
import '../../widgets/app_scaffold.dart';

/// Static settings screen with dummy toggles.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notifications = false;
  bool _vibration = false;

  @override
  Widget build(BuildContext context) {
    final palette = ref.watch(themeNotifierProvider).palette;
    final darkMode = ref.watch(themeModeProvider) == ThemeMode.dark;

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
              value: darkMode,
              onChanged: (value) {
                ref
                    .read(themeNotifierProvider.notifier)
                    .setMode(value ? ThemeMode.dark : ThemeMode.light);
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            DropdownButton<AppPalette>(
              value: palette,
              onChanged: (value) {
                if (value != null) {
                  ref.read(themeNotifierProvider.notifier).setPalette(value);
                }
              },
              items: AppPalette.values
                  .map(
                    (p) => DropdownMenuItem(
                      value: p,
                      child: Text(p.name),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
