import 'package:appoint/config/theme.dart';
import 'package:appoint/l10n/app_localizations.dart';
import 'package:appoint/models/playtime_game.dart';
import 'package:appoint/models/playtime_session.dart';
import 'package:appoint/providers/playtime_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PlaytimeLiveScreen extends ConsumerStatefulWidget {

  const PlaytimeLiveScreen({super.key, this.game});
  final PlaytimeGame? game;

  @override
  ConsumerState<PlaytimeLiveScreen> createState() => _PlaytimeLiveScreenState();
}

class _PlaytimeLiveScreenState extends ConsumerState<PlaytimeLiveScreen> {
  PlaytimeGame? _selectedGame;
  String _sessionTitle = '';
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 15, minute: 0);
  String _location = '';
  final List<String> _invitedUsers = [];

  @override
  void initState() {
    super.initState();
    final _selectedGame = widget.game;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Playtime'),
        backgroundColor: AppTheme.accentColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.accentColor.withValues(alpha: 0.1),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Game Selection
                _buildGameSelection(l10n),
                const SizedBox(height: 24),

                // Session Details
                _buildSessionDetails(l10n),
                const SizedBox(height: 24),

                // Date & Time Selection
                _buildDateTimeSelection(l10n),
                const SizedBox(height: 24),

                // Location
                _buildLocationSelection(l10n),
                const SizedBox(height: 24),

                // Invite Friends
                _buildInviteFriends(l10n),
                const SizedBox(height: 32),

                // Action Buttons
                _buildActionButtons(l10n),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameSelection(AppLocalizations l10n) => Card(
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
                builder: (context, final ref, final child) {
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
                          itemBuilder: (context, final index) {
                            final game = games[index];
                            return _buildGameOptionCard(game);
                          },
                        ),
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, final stack) => Text('Error: $error'),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );

  Widget _buildSelectedGameCard(PlaytimeGame game) => Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.accentColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            onBackgroundImageError: (_, final __) {},
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

  Widget _buildGameOptionCard(PlaytimeGame game) => Container(
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
                  onBackgroundImageError: (_, final __) {},
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

  Widget _buildEmptyGamesState(AppLocalizations l10n) => Container(
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
              backgroundColor: AppTheme.accentColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );

  Widget _buildSessionDetails(AppLocalizations l10n) => Card(
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

  Widget _buildDateTimeSelection(AppLocalizations l10n) => Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date & Time',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),

            // Date Selection
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Date'),
              subtitle: Text(
                '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _selectDate(context),
            ),

            const Divider(),

            // Time Selection
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('Time'),
              subtitle: Text(
                _selectedTime.format(context),
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _selectTime(context),
            ),
          ],
        ),
      ),
    );

  Widget _buildLocationSelection(AppLocalizations l10n) => Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Location',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Meeting Location',
                hintText: 'Enter the meeting location (park, home, etc.)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.location_on),
              ),
              onChanged: (value) {
                setState(() {
                  _location = value;
                });
              },
            ),
          ],
        ),
      ),
    );

  Widget _buildInviteFriends(AppLocalizations l10n) => Card(
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
                          setState(_invitedUsers.clear);
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
                itemBuilder: (context, final index) {
                  final userId = _invitedUsers[index];
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(userId.substring(0, 2).toUpperCase()),
                    ),
                    title: Text('User $userId'),
                    subtitle: const Text('Invited'),
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
                onPressed: _showInviteDialog,
                icon: const Icon(Icons.person_add),
                label: const Text('Invite Friends'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );

  Widget _buildActionButtons(AppLocalizations l10n) => Column(
      children: [
        Consumer(
          builder: (context, final ref, final child) {
            final createSessionState =
                ref.watch(playtimeSessionNotifierProvider);

            return SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _canCreateSession() && !createSessionState.isLoading
                    ? _createLiveSession
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: createSessionState.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Schedule Live Session',
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
              foregroundColor: AppTheme.accentColor,
              side: const BorderSide(color: AppTheme.accentColor),
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

  bool _canCreateSession() => _selectedGame != null &&
        _sessionTitle.isNotEmpty &&
        _location.isNotEmpty;

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _showInviteDialog() {
    // TODO(username): Implement friend picker dialog
    // For now, we'll add a placeholder user
    setState(() {
      _invitedUsers.add('friend_${_invitedUsers.length + 1}');
    });
  }

  Future<void> _createLiveSession() async {
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

      // Combine date and time
      final scheduledDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      final session = PlaytimeSession(
        id: '',
        gameId: _selectedGame!.id,
        participants: [user.uid, ..._invitedUsers],
        scheduledTime: scheduledDateTime,
        mode: 'live',
        backgroundId: '',
      );

      await ref
          .read(playtimeSessionNotifierProvider.notifier)
          .createSession(session);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Live session scheduled! Waiting for parent approval...'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate back to hub
        context.pop();
      }
    } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create session: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
