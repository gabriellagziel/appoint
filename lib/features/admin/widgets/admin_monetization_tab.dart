import 'package:appoint/models/admin_dashboard_stats.dart';
import 'package:appoint/providers/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminMonetizationTab extends ConsumerWidget {
  const AdminMonetizationTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monetizationSettings = ref.watch(monetizationSettingsProvider);
    final adRevenueStats = ref.watch(adRevenueStatsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          monetizationSettings.when(
            data: (settings) =>
                _buildMonetizationSettings(context, ref, settings),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, final stack) => Center(child: Text('Error: $error')),
          ),
          const SizedBox(height: 24),
          adRevenueStats.when(
            data: _buildAdRevenueStats,
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, final stack) => Center(child: Text('Error: $error')),
          ),
        ],
      ),
    );
  }

  Widget _buildMonetizationSettings(
    BuildContext context,
    WidgetRef ref,
    MonetizationSettings settings,
  ) =>
      Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ad Settings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildSettingSwitch(
                'Ads for Free Users',
                settings.adsEnabledForFreeUsers,
                (value) =>
                    _updateAdSetting(ref, 'adsEnabledForFreeUsers', value),
              ),
              _buildSettingSwitch(
                'Ads for Children',
                settings.adsEnabledForChildren,
                (value) =>
                    _updateAdSetting(ref, 'adsEnabledForChildren', value),
              ),
              _buildSettingSwitch(
                'Ads for Studio Users',
                settings.adsEnabledForStudioUsers,
                (value) =>
                    _updateAdSetting(ref, 'adsEnabledForStudioUsers', value),
              ),
              _buildSettingSwitch(
                'Ads for Premium Users',
                settings.adsEnabledForPremiumUsers,
                (value) =>
                    _updateAdSetting(ref, 'adsEnabledForPremiumUsers', value),
              ),
            ],
          ),
        ),
      );

  Widget _buildSettingSwitch(
    final String title,
    final bool value,
    ValueChanged<bool> onChanged,
  ) =>
      SwitchListTile(
        title: Text(title),
        value: value,
        onChanged: onChanged,
      );

  Widget _buildAdRevenueStats(AdRevenueStats stats) => Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ad Revenue Statistics',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildStatRow(
                'Total Revenue',
                '\$${stats.totalRevenue.toStringAsFixed(2)}',
              ),
              _buildStatRow(
                'Monthly Revenue',
                '\$${stats.monthlyRevenue.toStringAsFixed(2)}',
              ),
              _buildStatRow(
                'Weekly Revenue',
                '\$${stats.weeklyRevenue.toStringAsFixed(2)}',
              ),
              _buildStatRow(
                'Daily Revenue',
                '\$${stats.dailyRevenue.toStringAsFixed(2)}',
              ),
              _buildStatRow(
                'Total Impressions',
                stats.totalImpressions.toString(),
              ),
              _buildStatRow('Total Clicks', stats.totalClicks.toString()),
              _buildStatRow(
                'Click Through Rate',
                '${(stats.clickThroughRate * 100).toStringAsFixed(2)}%',
              ),
            ],
          ),
        ),
      );

  Widget _buildStatRow(String label, final String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );

  void _updateAdSetting(WidgetRef ref, String setting, final bool value) {
    final currentSettings = ref.read(monetizationSettingsProvider).value;
    if (currentSettings != null) {
      final updatedSettings = currentSettings.copyWith(
        adsEnabledForFreeUsers: setting == 'adsEnabledForFreeUsers'
            ? value
            : currentSettings.adsEnabledForFreeUsers,
        adsEnabledForChildren: setting == 'adsEnabledForChildren'
            ? value
            : currentSettings.adsEnabledForChildren,
        adsEnabledForStudioUsers: setting == 'adsEnabledForStudioUsers'
            ? value
            : currentSettings.adsEnabledForStudioUsers,
        adsEnabledForPremiumUsers: setting == 'adsEnabledForPremiumUsers'
            ? value
            : currentSettings.adsEnabledForPremiumUsers,
      );
      ref
          .read(adminActionsProvider)
          .updateMonetizationSettings(updatedSettings);
    }
  }
}
