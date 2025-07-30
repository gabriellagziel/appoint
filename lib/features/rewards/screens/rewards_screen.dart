import 'package:appoint/features/rewards/models/reward.dart';
import 'package:appoint/features/rewards/services/rewards_service.dart';
import 'package:appoint/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final rewardsServiceProvider = Provider<RewardsService>((ref) => RewardsService());

final availableRewardsProvider = FutureProvider<List<Reward>>((ref) async {
  final service = ref.read(rewardsServiceProvider);
  return service.getAvailableRewards();
});

final userProgressProvider = FutureProvider<RewardProgress>((ref) async {
  final service = ref.read(rewardsServiceProvider);
  return service.getUserProgress();
});

final userAchievementsProvider = FutureProvider<List<Achievement>>((ref) async {
  final service = ref.read(rewardsServiceProvider);
  return service.getUserAchievements();
});

final userRedeemedRewardsProvider = FutureProvider<List<RedeemedReward>>((ref) async {
  final service = ref.read(rewardsServiceProvider);
  return service.getUserRedeemedRewards();
});

class RewardsScreen extends ConsumerWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final progressAsync = ref.watch(userProgressProvider);
    final rewardsAsync = ref.watch(availableRewardsProvider);
    final achievementsAsync = ref.watch(userAchievementsProvider);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Rewards & Achievements'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Progress'),
              Tab(text: 'Rewards'),
              Tab(text: 'Achievements'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildProgressTab(context, ref, progressAsync, l10n),
            _buildRewardsTab(context, ref, rewardsAsync, progressAsync, l10n),
            _buildAchievementsTab(context, ref, achievementsAsync, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressTab(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<RewardProgress> progressAsync,
    AppLocalizations l10n,
  ) {
    return progressAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text('Failed to load progress'),
            const SizedBox(height: 8),
            Text(error.toString()),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.invalidate(userProgressProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (progress) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Level and points card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Level ${progress.level}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${progress.points} points',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${progress.level}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: progress.levelProgress,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${progress.pointsToNextLevel} points to next level',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Stats grid
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Achievements',
                    '${progress.achievementsUnlocked}/${progress.totalAchievements}',
                    Icons.emoji_events,
                    progress.achievementProgress,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'Rewards Redeemed',
                    '${progress.rewardsRedeemed}',
                    Icons.card_giftcard,
                    1.0,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Next reward
            if (progress.nextReward != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Next Reward',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          if (progress.nextReward!.imageUrl != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                progress.nextReward!.imageUrl!,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            )
                          else
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.card_giftcard, size: 30),
                            ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  progress.nextReward!.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  progress.nextReward!.description,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${progress.nextReward!.pointsCost} points',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardsTab(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<Reward>> rewardsAsync,
    AsyncValue<RewardProgress> progressAsync,
    AppLocalizations l10n,
  ) {
    return rewardsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text('Failed to load rewards'),
            const SizedBox(height: 8),
            Text(error.toString()),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.invalidate(availableRewardsProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (rewards) => progressAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (progress) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: rewards.length,
          itemBuilder: (context, index) {
            final reward = rewards[index];
            final canAfford = progress.points >= reward.pointsCost;
            
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Reward image
                    if (reward.imageUrl != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          reward.imageUrl!,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.card_giftcard, size: 40),
                      ),
                    
                    const SizedBox(width: 16),
                    
                    // Reward details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            reward.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            reward.description,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.stars,
                                size: 16,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${reward.pointsCost} points',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Redeem button
                    ElevatedButton(
                      onPressed: reward.canRedeem && canAfford
                          ? () => _redeemReward(context, ref, reward)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: reward.canRedeem && canAfford
                            ? Theme.of(context).primaryColor
                            : Colors.grey[300],
                        foregroundColor: reward.canRedeem && canAfford
                            ? Colors.white
                            : Colors.grey[600],
                      ),
                      child: Text(
                        reward.canRedeem && canAfford ? 'Redeem' : 'Unavailable'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAchievementsTab(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<Achievement>> achievementsAsync,
    AppLocalizations l10n,
  ) {
    return achievementsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text('Failed to load achievements'),
            const SizedBox(height: 8),
            Text(error.toString()),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.invalidate(userAchievementsProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (achievements) => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: achievements.length,
        itemBuilder: (context, index) {
          final achievement = achievements[index];
          
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Achievement icon
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: achievement.isUnlocked
                          ? Colors.green[100]
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Icon(
                      _getAchievementIcon(achievement.type),
                      color: achievement.isUnlocked
                          ? Colors.green[600]
                          : Colors.grey[400],
                      size: 30,
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Achievement details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          achievement.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: achievement.isUnlocked
                                ? Colors.black
                                : Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          achievement.description,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.stars,
                              size: 16,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '+${achievement.pointsReward} points',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (achievement.unlockedAt != null) ...[
                              const SizedBox(width: 16),
                              Text(
                                'Unlocked ${_formatDate(achievement.unlockedAt!)}',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (achievement.progress != null && achievement.maxProgress != null) ...[
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: achievement.progressPercentage,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              achievement.isUnlocked
                                  ? Colors.green
                                  : Theme.of(context).primaryColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${achievement.progress}/${achievement.maxProgress}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, double progress) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Colors.blue),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getAchievementIcon(AchievementType type) {
    switch (type) {
      case AchievementType.booking:
        return Icons.calendar_today;
      case AchievementType.referral:
        return Icons.people;
      case AchievementType.streak:
        return Icons.local_fire_department;
      case AchievementType.social:
        return Icons.share;
      case AchievementType.milestone:
        return Icons.emoji_events;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  void _redeemReward(BuildContext context, WidgetRef ref, Reward reward) async {
    try {
      final service = ref.read(rewardsServiceProvider);
      await service.redeemReward(reward.id);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Successfully redeemed ${reward.name}!')),
        );
        ref.invalidate(userProgressProvider);
        ref.invalidate(userRedeemedRewardsProvider);
      }
    } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to redeem reward: $e')),
        );
    }
  }
} 