import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/referral_provider.dart';

class ReferralScreen extends ConsumerWidget {
  const ReferralScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final codeAsync = ref.watch(referralCodeProvider);
    final usageAsync = ref.watch(referralUsageProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Referral')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: codeAsync.when(
          data: (code) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Your Referral Code'),
              SelectableText(
                code,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: code));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Copied to clipboard')),
                      );
                    },
                    child: const Text('Copy'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      Share.share('Use my referral code: $code');
                    },
                    child: const Text('Share'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              usageAsync.when(
                data: (count) => Text('Used $count times'),
                loading: () => const CircularProgressIndicator(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const Center(child: Text('Error generating code')),
        ),
      ),
    );
  }
}
