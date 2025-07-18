import 'package:appoint/l10n/app_localizations.dart';
import 'package:appoint/providers/permission_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PermissionsOnboardingScreen extends ConsumerStatefulWidget {
  const PermissionsOnboardingScreen({super.key});

  @override
  ConsumerState<PermissionsOnboardingScreen> createState() => REDACTED_TOKEN();
}

class REDACTED_TOKEN extends ConsumerState<PermissionsOnboardingScreen> {
  int _step = 0; // 0 notif, 1 calendar, 2 location
  bool _isLoading = false;

  Future<void> _requestNext() async {
    setState(() => _isLoading = true);
    final perm = ref.read(permissionServiceProvider);
    switch (_step) {
      case 0:
        await perm.requestNotificationPermission();
        break;
      case 1:
        await perm.requestCalendarPermission();
        break;
      case 2:
        await perm.requestLocationPermission();
        break;
    }
    setState(() {
      _isLoading = false;
      _step++;
    });
    if (_step > 2) {
      context.go('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final titles = [
      'Enable Notifications', // TODO: Localize
      'Calendar Access', // TODO: Localize
      'Location Access', // TODO: Localize
    ];
    final descriptions = [
      'Stay up to date with important alerts', // TODO: Localize
      'Sync appointments with your calendar', // TODO: Localize
      'Enhance features with location data', // TODO: Localize
    ];
    final icons = [Icons.notifications_active, Icons.calendar_month, Icons.location_on];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icons[_step], size: 80, color: Theme.of(context).primaryColor),
              const SizedBox(height: 24),
              Text(
                titles[_step],
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                descriptions[_step],
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _requestNext,
                  child: _isLoading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(_step < 2 ? l10n.continue1 : l10n.getStarted),
                ),
              ),
              if (_step < 2)
                TextButton(
                  onPressed: () {
                    setState(() => _step++);
                    if (_step > 2) context.go('/dashboard');
                  },
                  child: Text(l10n.skip),
                ),
            ],
          ),
        ),
      ),
    );
  }
}