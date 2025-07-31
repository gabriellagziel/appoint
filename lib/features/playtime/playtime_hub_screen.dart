import 'package:appoint/config/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:appoint/models/playtime_game.dart';
import 'package:appoint/models/playtime_session.dart';
import 'package:appoint/providers/playtime_provider.dart';
import 'package:appoint/widgets/bottom_sheet_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PlaytimeHubScreen extends ConsumerWidget {
  const PlaytimeHubScreen({super.key});

  @override
  Widget build(BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.playtimeHub),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to Playtime settings
              context.push('/playtime/settings');
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryColor.withAlpha((255 * 0.1).round()),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Welcome Section
                _buildWelcomeSection(context, l10n),
                const SizedBox(height: 24),

                // Quick Actions
                _buildQuickActions(context, l10n),
                const SizedBox(height: 24),

                // Recent Games
                _buildRecentGames(context, l10n),
                const SizedBox(height: 24),

                // Upcoming Sessions
                _buildUpcomingSessions(context, l10n),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showCreateOptions(context, l10n);
        },
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text(l10n.createNew),
      ),
    );
  }

  Widget _buildWelcomeSection(
    BuildContext context,
    final AppLocalizations l10n,
  ) =>
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withAlpha((255 * 0.3).round()),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha((255 * 0.2).round()),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.games,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.welcomeToPlaytime,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.playtimeDescription,
                        style: TextStyle(
                          color: Colors.white.withAlpha((255 * 0.9).round()),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  Widget _buildQuickActions(
    BuildContext context,
    final AppLocalizations l10n,
  ) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.quickActions,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  context,
                  l10n.playtimeVirtual,
                  Icons.computer,
                  AppTheme.secondaryColor,
                  () => context.push('/playtime/virtual'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionCard(
                  context,
                  l10n.playtimeLive,
                  Icons.people,
                  AppTheme.accentColor,
                  () => context.push('/playtime/live'),
                ),
              ),
            ],
          ),
        ],
      );

  Widget _buildActionCard(
    final BuildContext context,
    final String title,
    final IconData icon,
    final Color color,
    final VoidCallback onTap,
  ) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color.withAlpha((255 * 0.1).round()),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withAlpha((255 * 0.3).round())),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );

  Widget _buildRecentGames(
    BuildContext context,
    final AppLocalizations l10n,
  ) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.recentGames,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () => context.push('/playtime/games'),
                child: Text(l10n.viewAll),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Consumer(
            builder: (context, final ref, final child) {
              final gamesAsync = ref.watch(systemGamesProvider);

              return gamesAsync.when(
                data: (games) {
                  if (games.isEmpty) {
                    return _buildEmptyState(
                      context,
                      l10n.noGamesYet,
                      l10n.createYourFirstGame,
                      Icons.games,
                    );
                  }

                  return SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: games.take(5).length,
                      itemBuilder: (context, final index) {
                        final game = games[index];
                        return _buildGameCard(context, game, l10n);
                      },
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, final stack) => Text('Error: $error'),
              );
            },
          ),
        ],
      );

  Widget _buildGameCard(
    final BuildContext context,
    final PlaytimeGame game,
    AppLocalizations l10n,
  ) =>
      Container(
        width: 120,
        margin: const EdgeInsets.only(right: 12),
        child: Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            onTap: () => context.push('/playtime/game/${game.id}'),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        onBackgroundImageError: (_, final __) {},
                        child: const Icon(Icons.games, size: 20),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          game.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    game.status,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Created by: ${game.createdBy}',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _buildUpcomingSessions(
    BuildContext context,
    final AppLocalizations l10n,
  ) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.upcomingSessions,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () => context.push('/playtime/sessions'),
                child: Text(l10n.viewAll),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Consumer(
            builder: (context, final ref, final child) {
              final sessionsAsync = ref.watch(confirmedSessionsProvider);

              return sessionsAsync.when(
                data: (sessions) {
                  if (sessions.isEmpty) {
                    return _buildEmptyState(
                      context,
                      l10n.noSessionsYet,
                      l10n.createYourFirstSession,
                      Icons.event,
                    );
                  }

                  return Column(
                    children: sessions
                        .take(3)
                        .map((session) =>
                            _buildSessionCard(context, session, l10n))
                        .toList(),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, final stack) => Text('Error: $error'),
              );
            },
          ),
        ],
      );

  Widget _buildSessionCard(
    final BuildContext context,
    PlaytimeSession session,
    final AppLocalizations l10n,
  ) =>
      Card(
        margin: const EdgeInsets.only(bottom: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: CircleAvatar(
            backgroundColor: session.mode == 'virtual'
                ? AppTheme.secondaryColor
                : AppTheme.accentColor,
            child: Icon(
              session.mode == 'virtual' ? Icons.computer : Icons.people,
              color: Colors.white,
            ),
          ),
          title: Text(
            'Session ${session.id}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                '${l10n.scheduledFor}: ${_formatDateTime(session.scheduledTime)}',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 2),
              Text(
                '${session.participants.length} ${l10n.participants}',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: () => context.push('/playtime/session/${session.id}'),
          ),
        ),
      );

  Widget _buildEmptyState(
    final BuildContext context,
    final String title,
    String subtitle,
    final IconData icon,
  ) =>
      Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              icon,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );

  void _showCreateOptions(
    BuildContext context,
    final AppLocalizations l10n,
  ) {
    BottomSheetManager.show(
      context: context,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.createNew,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildCreateOption(
              context,
              l10n.createGame,
              Icons.games,
              AppTheme.primaryColor,
              () {
                Navigator.pop(context);
                context.push('/playtime/create-game');
              },
            ),
            const SizedBox(height: 12),
            _buildCreateOption(
              context,
              l10n.createVirtualSession,
              Icons.computer,
              AppTheme.secondaryColor,
              () {
                Navigator.pop(context);
                context.push('/playtime/create-virtual');
              },
            ),
            const SizedBox(height: 12),
            _buildCreateOption(
              context,
              l10n.createLiveSession,
              Icons.people,
              AppTheme.accentColor,
              () {
                Navigator.pop(context);
                context.push('/playtime/create-live');
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateOption(
    final BuildContext context,
    final String title,
    final IconData icon,
    final Color color,
    final VoidCallback onTap,
  ) =>
      InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withAlpha((255 * 0.1).round()),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withAlpha((255 * 0.3).round())),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
              const Spacer(),
              Icon(Icons.arrow_forward_ios, color: color, size: 16),
            ],
          ),
        ),
      );

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);

    if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'}';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'}';
    } else {
      return 'Now';
    }
  }
}
