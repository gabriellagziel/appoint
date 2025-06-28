import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/rewards_provider.dart';

class RewardsScreen extends ConsumerWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pointsAsync = ref.watch(userPointsProvider);
    final tiers = ref.watch(rewardTiersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Rewards')),
      body: pointsAsync.when(
        data: (points) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: ListTile(
                  title: const Text('Points Earned'),
                  trailing: Text('$points'),
                ),
              ),
              const SizedBox(height: 24),
              Text('Reward Tiers',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              ...tiers.map(
                (tier) => ListTile(
                  title: Text(tier.name),
                  trailing: Text('${tier.pointsRequired} pts'),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Error loading points')),
      ),
    );
  }
}
