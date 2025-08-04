import 'package:flutter/material.dart';
import 'package:appoint/features/invite/guest_meeting_view.dart';
import 'package:appoint/models/invite.dart';

/// Test widget to verify guest meeting flow
class TestGuestFlow extends StatelessWidget {
  const TestGuestFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Guest Flow'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'WhatsApp Group Share - Guest Flow Test',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(
              'This tests the guest meeting view that appears when users without the app click on WhatsApp shared links.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => GuestMeetingView(
                      appointmentId: 'test-appointment-123',
                      creatorId: 'test-creator-456',
                      shareId: 'test-share-789',
                      source: InviteSource.whatsapp_group,
                    ),
                  ),
                );
              },
              child: const Text('Open Guest Meeting View'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Simulate deep link
                final testUrl = Uri.parse(
                  'https://app-oint.com/invite/test-appointment-123?'
                  'creatorId=test-creator-456&'
                  'shareId=test-share-789&'
                  'source=whatsapp_group&'
                  'group_share=1',
                );
                // This would normally be handled by the deep link service
                print('Test deep link: $testUrl');
              },
              child: const Text('Test Deep Link URL'),
            ),
            const SizedBox(height: 24),
            const Text(
              'Expected Flow:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('1. User clicks WhatsApp shared link'),
            const Text('2. Opens in browser (no app installed)'),
            const Text('3. Shows guest meeting view'),
            const Text('4. User can accept invitation'),
            const Text('5. Shows download prompt with QR code'),
            const Text('6. After app install, completes RSVP'),
          ],
        ),
      ),
    );
  }
} 