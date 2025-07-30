import 'package:appoint/providers/ambassador_record_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, final WidgetRef ref) {
    ambassadorAsync = ref.watch(ambassadorRecordProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ambassadorAsync.when(
        data: (ambassador) {
          if (ambassador == null) {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/ambassador-onboarding');
                },
                child: const Text('Become an Ambassador'),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ambassador Status: ${ambassador.status}'),
                const SizedBox(height: 8),
                Text('Referrals: ${ambassador.referrals}'),
                const SizedBox(height: 8),
                SelectableText(ambassador.shareLink),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    SharePlus.instance.share(
                      ShareParams(
                        text:
                            'Join me on Appoint! Use my ambassador link: ${ambassador.shareLink}',
                        subject: 'Appoint - Ambassador Link',
                      ),
                    );
                  },
                  label: const Text('Share Link'),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, final _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
