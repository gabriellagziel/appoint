import 'package:appoint/providers/theme_provider.dart';
import 'package:appoint/services/analytics_service.dart';
import 'package:appoint/theme/app_spacing.dart';
import 'package:appoint/theme/sample_palettes.dart';
import 'package:appoint/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  void initState() {
    super.initState();
    // Track screen view
    AnalyticsService.logScreenView('SettingsScreen');
  }

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
              onChanged: (value) {
                AnalyticsService.logEvent('setting_changed', params: {
                  'setting_type': 'notifications',
                  'setting_value': value,
                  'screen': 'settings',
                });
                setState(() => _notifications = value);
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            SwitchListTile(
              title: const Text('Enable Vibration'),
              value: _vibration,
              onChanged: (value) {
                AnalyticsService.logEvent('setting_changed', params: {
                  'setting_type': 'vibration',
                  'setting_value': value,
                  'screen': 'settings',
                });
                setState(() => _vibration = value);
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: darkMode,
              onChanged: (value) {
                AnalyticsService.logEvent('setting_changed', params: {
                  'setting_type': 'dark_mode',
                  'setting_value': value,
                  'screen': 'settings',
                });
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
                  AnalyticsService.logEvent('setting_changed', params: {
                    'setting_type': 'theme_palette',
                    'setting_value': value.name,
                    'screen': 'settings',
                  });
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
