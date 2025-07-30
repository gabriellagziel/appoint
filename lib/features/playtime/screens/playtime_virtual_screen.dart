import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../l10n/app_localizations.dart';
import '../../../config/theme.dart';
import '../../../providers/playtime_provider.dart';
import '../../../models/playtime_game.dart';
import '../../../models/playtime_session.dart';

class PlaytimeVirtualScreen extends ConsumerStatefulWidget {
  final PlaytimeGame? game;

  const PlaytimeVirtualScreen({super.key, this.game});

  @override
  ConsumerState<PlaytimeVirtualScreen> createState() =>
      _PlaytimeVirtualScreenState();
}

class _PlaytimeVirtualScreenState extends ConsumerState<PlaytimeVirtualScreen> {
  PlaytimeGame? _selectedGame;
  String _sessionTitle = '';
  List<String> _invitedUsers = [];

  @override
  void initState() {
    super.initState();
    _selectedGame = widget.game;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Virtual Playtime'),
        backgroundColor: AppTheme.secondaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.secondaryColor.withValues(alpha: 0.1),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Game Selection
                _buildGameSelection(l10n),
                const SizedBox(height: 24),

                // Session Details
                _buildSessionDetails(l10n),
                const SizedBox(height: 24),

                // Invite Friends
                _buildInviteFriends(l10n),
                const Spacer(),

                // Action Buttons
                _buildActionButtons(l10n),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameSelection(AppLocalizations l10n) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Game',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            if (_selectedGame != null) ...[
              _buildSelectedGameCard(_selectedGame!),
            ] else ...[
              Consumer(
                builder: (context, ref, child) {
                  final gamesAsync = ref.watch(systemGamesProvider);

                  return gamesAsync.when(
                    data: (games) {
                      if (games.isEmpty) {
                        return _buildEmptyGamesState(l10n);
                      }

                      return SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: games.length,
                          itemBuilder: (context, index) {
                            final game = games[index];
                            return _buildGameOptionCard(game);
                          },
                        ),
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => Text('Error: $error'),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedGameCard(PlaytimeGame game) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: AppTheme.secondaryColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: null,
            onBackgroundImageError: (_, __) {},
            child: const Icon(Icons.games, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  game.name,
                  style: const TextStyle(
                    fontSize: 16,
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
                    Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
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
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              setState(() {
                _selectedGame = null;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGameOptionCard(PlaytimeGame game) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedGame = game;
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: null,
                  onBackgroundImageError: (_, __) {},
                  child: const Icon(Icons.games, size: 25),
                ),
                const SizedBox(height: 8),
                Text(
                  game.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Status: ${game.status}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyGamesState(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(
            Icons.games,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 12),
          Text(
            'No games available',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create a new game to get started',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => context.push('/playtime/create-game'),
            icon: const Icon(Icons.add),
            label: const Text('Create Game'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.secondaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionDetails(AppLocalizations l10n) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Session Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Session Title',
                hintText: 'Enter a fun title for your session',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.title),
              ),
              onChanged: (value) {
                setState(() {
                  _sessionTitle = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInviteFriends(AppLocalizations l10n) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Invite Friends',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                TextButton.icon(
                  onPressed: _invitedUsers.isEmpty
                      ? null
                      : () {
                          setState(() {
                            _invitedUsers.clear();
                          });
                        },
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear All'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_invitedUsers.isEmpty) ...[
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No friends invited yet',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap the button below to invite friends',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ] else ...[
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _invitedUsers.length,
                itemBuilder: (context, index) {
                  final userId = _invitedUsers[index];
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(userId.substring(0, 2).toUpperCase()),
                    ),
                    title: Text('User $userId'),
                    subtitle: Text('Invited'),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        setState(() {
                          _invitedUsers.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showInviteDialog(),
                icon: const Icon(Icons.person_add),
                label: const Text('Invite Friends'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.secondaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(AppLocalizations l10n) {
    return Column(
      children: [
        Consumer(
          builder: (context, ref, child) {
            final createSessionState =
                ref.watch(playtimeSessionNotifierProvider);

            return SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _canCreateSession() && !createSessionState.isLoading
                    ? _createVirtualSession
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.secondaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: createSessionState.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Start Virtual Session',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            onPressed: () => context.pop(),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.secondaryColor,
              side: BorderSide(color: AppTheme.secondaryColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool _canCreateSession() {
    return _selectedGame != null && _sessionTitle.isNotEmpty;
  }

  void _showInviteDialog() {
    // This would typically show a friend picker
    // For now, we'll add a mock user
    setState(() {
      _invitedUsers.add('friend_${_invitedUsers.length + 1}');
    });
  }

  Future<void> _createVirtualSession() async {
    if (!_canCreateSession()) return;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please sign in to create a session'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final session = PlaytimeSession(
        id: '',
        gameId: _selectedGame!.id,
        participants: [user.uid, ..._invitedUsers],
        scheduledTime: DateTime.now(), // Virtual sessions start immediately
        mode: 'virtual',
        backgroundId: '',
      );

      await ref
          .read(playtimeSessionNotifierProvider.notifier)
          .createSession(session);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Virtual session created! Inviting friends...'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to the session
        context.push('/playtime/session/${session.id}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create session: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
