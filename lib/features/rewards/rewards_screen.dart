import 'package:appoint/providers/rewards_provider.dart';
import 'package:appoint/services/rewards_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final rewardsServiceProvider =
    Provider<RewardsService>((ref) => RewardsService());

class RewardsScreen extends ConsumerWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context, final WidgetRef ref) {
    final pointsAsync = ref.watch(userPointsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Rewards')),
      body: pointsAsync.when(
        data: (points) {
          final tier = ref.read(rewardsServiceProvider).tierForPoints(points);
          final nextTier =
              _nextTierInfo(points, ref.read(rewardsServiceProvider));
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Points: $points',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text('Current Tier: ${tier.toUpperCase()}'),
                if (nextTier != null) ...[
                  const SizedBox(height: 8),
                  Text(
                      'Next Tier (${nextTier['tier']}) at ${nextTier['points']} points',),
                ],
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, final __) =>
            const Center(child: Text('Error loading rewards')),
      ),
    );
  }

  Map<String, dynamic>? _nextTierInfo(
      int points, final RewardsService rewardsService,) {
    if (points < RewardsService.rewardTiers['silver']!) {
      return {
        'tier': 'silver',
        'points': RewardsService.rewardTiers['silver'],
      };
    }
    if (points < RewardsService.rewardTiers['gold']!) {
      return {
        'tier': 'gold',
        'points': RewardsService.rewardTiers['gold'],
      };
    }
    return null;
  }
}
