import 'package:appoint/config/theme.dart';
import 'package:appoint/features/child/providers/child_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Simple dashboard for child users showing avatar, nickname and playtime status.
class ChildDashboardScreen extends ConsumerWidget {
  const ChildDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, final WidgetRef ref) {
    final info = ref.watch(childInfoProvider);
    final settings = ref.watch(childSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Child Dashboard'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(info.avatarUrl),
            ),
            const SizedBox(height: 20),
            Text(
              info.nickname,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: settings.playtimeEnabled
                    ? Colors.green.shade100
                    : Colors.red.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    settings.playtimeEnabled ? Icons.check : Icons.block,
                    color: settings.playtimeEnabled ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    settings.playtimeEnabled
                        ? 'Playtime Enabled'
                        : 'Playtime Blocked',
                    style: TextStyle(
                      color: settings.playtimeEnabled
                          ? Colors.green.shade800
                          : Colors.red.shade800,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
