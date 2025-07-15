import 'package:appoint/config/theme.dart';
import 'package:appoint/features/playtime/playtime_admin_notifier.dart';
import 'package:appoint/l10n/app_localizations.dart';
import 'package:appoint/utils/admin_localizations.dart';
import 'package:appoint/models/playtime_background.dart';
import 'package:appoint/models/playtime_game.dart';
import 'package:appoint/providers/playtime_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AdminPlaytimeGamesScreen extends ConsumerWidget {
  const AdminPlaytimeGamesScreen({super.key});

  @override
  Widget build(BuildContext context, final WidgetRef ref) => DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Playtime Management'),
          backgroundColor: AppTheme.accentColor,
          foregroundColor: Colors.white,
          elevation: 0,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Games'),
              Tab(text: 'Backgrounds'),
              Tab(text: 'Sessions'),
            ],
            indicatorColor: Colors.white,
          ),
        ),
        body: TabBarView(
          children: [
            _GamesTab(),
            _BackgroundsTab(),
            _SessionsTab(),
          ],
        ),
      ),
    );
}

class _GamesTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, final WidgetRef ref) {
    return Consumer(
      builder: (context, final ref, final child) {
        final gamesAsync = ref.watch(allGamesProvider);

        return gamesAsync.when(
          data: (games) {
            final pendingGames =
                games.where((g) => g.status == 'pending').toList();
            final approvedGames =
                games.where((g) => g.status == 'approved').toList();
            final rejectedGames =
                games.where((g) => g.status == 'rejected').toList();

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pending Games
                  if (pendingGames.isNotEmpty) ...[
                    _buildSectionHeader(
                        'Pending Approval (${pendingGames.length})',
                        Colors.orange,),
                    const SizedBox(height: 12),
                    ...pendingGames.map(
                        (game) => _buildGameCard(context, game, ref),),
                    const SizedBox(height: 24),
                  ],

                  // Approved Games
                  if (approvedGames.isNotEmpty) ...[
                    _buildSectionHeader(
                        'Approved (${approvedGames.length})', Colors.green,),
                    const SizedBox(height: 12),
                    ...approvedGames.map(
                        (game) => _buildGameCard(context, game, ref),),
                    const SizedBox(height: 24),
                  ],

                  // Rejected Games
                  if (rejectedGames.isNotEmpty) ...[
                    _buildSectionHeader(
                        'Rejected (${rejectedGames.length})', Colors.red,),
                    const SizedBox(height: 12),
                    ...rejectedGames.map(
                        (game) => _buildGameCard(context, game, ref),),
                  ],

                  // Empty State
                  if (games.isEmpty) ...[
                    _buildEmptyState('No games found'),
                  ],
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, final stack) =>
              Center(child: Text('Error: $error')),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, final Color color) => Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );

  Widget _buildGameCard(final BuildContext context, final PlaytimeGame game,
      WidgetRef ref,) => Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  onBackgroundImageError: (_, final __) {},
                  child: const Icon(Icons.games, size: 25),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        game.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Status: ${game.status}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.person, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            'Created by: ${game.createdBy}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(Icons.access_time,
                              size: 16, color: Colors.grey[600],),
                          const SizedBox(width: 4),
                          Text(
                            '${game.createdAt?.day}/${game.createdAt?.month}/${game.createdAt?.year}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Game Details
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Created by:',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                      Text(
                        game.createdBy,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Status:',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                      Text(
                        game.status,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Action Buttons
            if (game.status == 'pending') ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _approveGame(context, game.id, ref),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Approve'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _rejectGame(context, game.id, ref),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Reject'),
                    ),
                  ),
                ],
              ),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _viewGameDetails(context, game),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('View Details'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _deleteGame(context, game.id, ref),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Delete'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );

  void _approveGame(
      BuildContext context, final String gameId, final WidgetRef ref,) {
    PlaytimeAdminNotifier.approveGame(gameId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Game approved successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _rejectGame(
      BuildContext context, final String gameId, final WidgetRef ref,) {
    PlaytimeAdminNotifier.rejectGame(gameId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Game rejected'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _deleteGame(
      BuildContext context, final String gameId, final WidgetRef ref,) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Game'),
        content: const Text(
            'Are you sure you want to delete this game? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              PlaytimeAdminNotifier.deleteGame(gameId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Game deleted successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _viewGameDetails(BuildContext context, final PlaytimeGame game) {
    // Navigate to game details screen
    context.push('/admin/playtime/game/${game.id}');
  }

  Widget _buildEmptyState(final String message) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.games,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
}

class _BackgroundsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, final WidgetRef ref) {
    final l10n = AdminLocalizations.of(context);

    return Consumer(
      builder: (context, final ref, final child) {
        final backgroundsAsync = ref.watch(allBackgroundsProvider);

        return backgroundsAsync.when(
          data: (backgrounds) {
            // Since simplified model doesn't have status, show all backgrounds
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // All Backgrounds
                  if (backgrounds.isNotEmpty) ...[
                    _buildSectionHeader(
                        'All Backgrounds (${backgrounds.length})', Colors.blue,),
                    const SizedBox(height: 12),
                    ...backgrounds.map(
                        (bg) => _buildBackgroundCard(context, bg, ref),),
                  ],

                  // Empty State
                  if (backgrounds.isEmpty) ...[
                    _buildEmptyState(l10n, 'No backgrounds found'),
                  ],
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, final stack) =>
              Center(child: Text('Error: $error')),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, final Color color) => Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );

  Widget _buildBackgroundCard(final BuildContext context,
      PlaytimeBackground background, final WidgetRef ref,) => Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[200],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      background.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, final error, final stackTrace) => const Icon(Icons.image,
                            color: Colors.grey, size: 40,),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Background ${background.id}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Created by: ${background.createdBy}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        _viewBackgroundDetails(context, background),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('View Details'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        _deleteBackground(context, background.id, ref),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Delete'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

  void _viewBackgroundDetails(
      BuildContext context, final PlaytimeBackground background,) {
    // Navigate to background details screen
    context.push('/admin/playtime/background/${background.id}');
  }

  void _deleteBackground(final BuildContext context, final String backgroundId,
      WidgetRef ref,) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Background'),
        content: const Text(
            'Are you sure you want to delete this background? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              PlaytimeAdminNotifier.deleteGame(
                  backgroundId); // Reuse deleteGame for now
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Background deleted successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n, final String message) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
}

class _SessionsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, final WidgetRef ref) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.schedule,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Sessions management coming soon',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
}
