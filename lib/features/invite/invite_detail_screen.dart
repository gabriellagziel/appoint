import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/invite.dart';
import '../../providers/invite_provider.dart';

class InviteDetailScreen extends ConsumerWidget {
  const InviteDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invite = ModalRoute.of(context)!.settings.arguments as Invite;
    return Scaffold(
      appBar: AppBar(title: const Text('Invite Detail')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Appointment: ${invite.appointmentId}'),
            Text('From: ${invite.inviteeContact.displayName}'),
            Text('Phone: ${invite.inviteeContact.phone}'),
            Text('Status: ${invite.status.name}'),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: invite.status == InviteStatus.pending
                        ? () async {
                            await ref.read(inviteServiceProvider).respondToInvite(
                                  invite.appointmentId,
                                  invite.inviteeId,
                                  InviteStatus.accepted,
                                );
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          }
                        : null,
                    child: const Text('Accept'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: invite.status == InviteStatus.pending
                        ? () async {
                            await ref.read(inviteServiceProvider).respondToInvite(
                                  invite.appointmentId,
                                  invite.inviteeId,
                                  InviteStatus.declined,
                                );
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          }
                        : null,
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Decline'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
