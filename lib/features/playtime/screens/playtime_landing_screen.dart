import 'package:appoint/config/theme.dart';
import 'package:appoint/l10n/app_localizations.dart';
import 'package:appoint/services/analytics/analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PlaytimeLandingScreen extends ConsumerWidget {
  const PlaytimeLandingScreen({super.key});

  @override
  Widget build(BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    // Track screen view
    AnalyticsService.instance
        .trackScreenView(screenName: 'PlaytimeLandingScreen');

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryColor.withValues(alpha: 0.1),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Header Section
                _buildHeader(context, l10n),
                const SizedBox(height: 60),

                // Main Options
                _buildMainOptions(context, l10n),
                const SizedBox(height: 40),

                // Quick Actions
                _buildQuickActions(context, l10n),
                const Spacer(),

                // Footer
                _buildFooter(context, l10n),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, final AppLocalizations l10n) =>
      Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.games,
              size: 48,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Welcome to Playtime!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Choose how you want to play with friends',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );

  Widget _buildMainOptions(
    BuildContext context,
    final AppLocalizations l10n,
  ) =>
      Column(
        children: [
          // Virtual Playtime Option
          _buildOptionCard(
            context,
            title: 'Virtual Playtime',
            subtitle: 'Play games online with friends',
            icon: Icons.computer,
            color: AppTheme.secondaryColor,
            onTap: () {
              AnalyticsService.instance.trackUserAction(
                action: 'playtime_option_selected',
                parameters: {
                  'option_type': 'virtual',
                  'location': 'landing_screen',
                },
              );
              context.push('/playtime/virtual');
            },
          ),
          const SizedBox(height: 20),

          // Live Playtime Option
          _buildOptionCard(
            context,
            title: 'Live Playtime',
            subtitle: 'Meet friends in person to play',
            icon: Icons.people,
            color: AppTheme.accentColor,
            onTap: () {
              AnalyticsService.instance.trackUserAction(
                action: 'playtime_option_selected',
                parameters: {
                  'option_type': 'live',
                  'location': 'landing_screen',
                },
              );
              context.push('/playtime/live');
            },
          ),
        ],
      );

  Widget _buildOptionCard(
    final BuildContext context, {
    required final String title,
    required final String subtitle,
    required final IconData icon,
    required final Color color,
    required final VoidCallback onTap,
  }) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: color.withValues(alpha: 0.2),
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: color,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: color,
                size: 20,
              ),
            ],
          ),
        ),
      );

  Widget _buildQuickActions(
    BuildContext context,
    final AppLocalizations l10n,
  ) =>
      Column(
        children: [
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildQuickActionButton(
                context,
                icon: Icons.games,
                label: 'Browse Games',
                onTap: () => context.push('/playtime/games'),
              ),
              _buildQuickActionButton(
                context,
                icon: Icons.add,
                label: 'Create Game',
                onTap: () => context.push('/playtime/create-game'),
              ),
              _buildQuickActionButton(
                context,
                icon: Icons.schedule,
                label: 'My Sessions',
                onTap: () => context.push('/playtime/sessions'),
              ),
            ],
          ),
        ],
      );

  Widget _buildQuickActionButton(
    final BuildContext context, {
    required final IconData icon,
    required final String label,
    required final VoidCallback onTap,
  }) =>
      GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: AppTheme.primaryColor,
                size: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );

  Widget _buildFooter(BuildContext context, final AppLocalizations l10n) =>
      Column(
        children: [
          Text(
            'Safe & Fun Gaming Environment',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.security,
                size: 16,
                color: Colors.grey[500],
              ),
              const SizedBox(width: 4),
              Text(
                'Parent-approved content',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.family_restroom,
                size: 16,
                color: Colors.grey[500],
              ),
              const SizedBox(width: 4),
              Text(
                'Family-friendly',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ],
      );
}
