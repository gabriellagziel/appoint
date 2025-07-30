import 'package:appoint/config/theme.dart';
import 'package:appoint/l10n/app_localizations.dart';
import 'package:appoint/services/playtime_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for the playtime service
final playtimeServiceProvider =
    Provider<PlaytimeService>((ref) => PlaytimeService());

class PlaytimeScreen extends ConsumerStatefulWidget {
  const PlaytimeScreen({super.key});

  @override
  ConsumerState<PlaytimeScreen> createState() => _PlaytimeScreenState();
}

class _PlaytimeScreenState extends ConsumerState<PlaytimeScreen> {
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final playtimeService = ref.read(playtimeServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Playtime'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
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

                // Ticket Counter
                _buildTicketCounter(context, l10n, playtimeService),
                const SizedBox(height: 24),

                // Play Button
                _buildPlayButton(context, l10n, playtimeService),
                const SizedBox(height: 24),

                // Daily Progress
                _buildDailyProgress(context, l10n, playtimeService),

                // Error Message
                if (_errorMessage != null) ...[
                  const SizedBox(height: 16),
                  _buildErrorMessage(context, _errorMessage!),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context, AppLocalizations l10n) =>
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
                        l10n.welcomeToPlaytime ?? 'Welcome to Playtime!',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.playtimeDescription ??
                            'Tap the play button to earn tickets and unlock rewards!',
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

  Widget _buildTicketCounter(BuildContext context, AppLocalizations l10n,
          PlaytimeService playtimeService) =>
      StreamBuilder<int>(
        stream: playtimeService.getCurrentTicketCount(),
        builder: (context, snapshot) {
          final ticketCount = snapshot.data ?? 0;

          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha((255 * 0.2).round()),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.confirmation_number,
                      color: Colors.orange,
                      size: 32,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Tickets',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '$ticketCount',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                Text(
                  'Tickets Earned',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        },
      );

  Widget _buildPlayButton(BuildContext context, AppLocalizations l10n,
          PlaytimeService playtimeService) =>
      FutureBuilder<bool>(
        future: playtimeService.canEarnMoreToday(),
        builder: (context, snapshot) {
          final canEarn = snapshot.data ?? false;

          return Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha((255 * 0.2).round()),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: canEarn
                          ? () => _handlePlayButtonTap(playtimeService)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            canEarn ? AppTheme.primaryColor : Colors.grey,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 48, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: canEarn ? 4 : 0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            canEarn ? Icons.play_arrow : Icons.block,
                            size: 32,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            canEarn ? 'Play Now' : 'Daily Limit Reached',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          );
        },
      );

  Widget _buildDailyProgress(BuildContext context, AppLocalizations l10n,
          PlaytimeService playtimeService) =>
      FutureBuilder<bool>(
        future: playtimeService.canEarnMoreToday(),
        builder: (context, snapshot) {
          final canEarn = snapshot.data ?? false;
          // Calculate progress (max 10 tickets per day)
          const maxTickets = 10;
          final earnedToday =
              canEarn ? (maxTickets - 1) : maxTickets; // Simplified calculation

          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha((255 * 0.2).round()),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.today,
                      color: AppTheme.primaryColor,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Daily Progress',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: earnedToday / maxTickets,
                  backgroundColor: Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      AppTheme.primaryColor),
                ),
                const SizedBox(height: 8),
                Text(
                  '$earnedToday/$maxTickets tickets earned today',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        },
      );

  Widget _buildErrorMessage(BuildContext context, String message) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red[200]!),
        ),
        child: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red[700],
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: Colors.red[700],
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      );

  Future<void> _handlePlayButtonTap(PlaytimeService playtimeService) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      const errorMessage = null;
    });

    try {
      // Check if user is authenticated
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Grant ticket
      await playtimeService.grantTicket();

      // Show success feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Ticket earned! 🎉',
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'An error occurred: $e',
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
