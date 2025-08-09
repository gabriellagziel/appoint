import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/invite_controller.dart';
import '../widgets/guest_invite_view.dart';
import '../../../services/analytics/analytics_service.dart';

class JoinRoute extends ConsumerWidget {
  const JoinRoute({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inviteState = ref.watch(inviteControllerProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Meeting'),
        automaticallyImplyLeading: false,
      ),
      body: inviteState.when(
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading invite...'),
            ],
          ),
        ),
        valid: (invite, src) {
          // Track invite opened
          AnalyticsService.track("invite_opened", {
            "token": invite.token,
            "src": src ?? "unknown",
            "meetingId": invite.meetingId,
          });
          
          return GuestInviteView(invite: invite, src: src);
        },
        invalid: (reason) => _buildErrorView(context, reason),
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String reason) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              'Invalid Invite',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              reason,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to home
                Navigator.of(context).pushReplacementNamed('/');
              },
              icon: const Icon(Icons.home),
              label: const Text('Go Home'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Request new link (no-op for now)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Contact the meeting organizer for a new link'),
                  ),
                );
              },
              child: const Text('Request New Link'),
            ),
          ],
        ),
      ),
    );
  }
}



