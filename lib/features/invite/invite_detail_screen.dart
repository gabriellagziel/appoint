import 'package:appoint/l10n/app_localizations.dart';
import 'package:appoint/models/invite.dart';
import 'package:appoint/providers/invite_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InviteDetailScreen extends ConsumerWidget {
  const InviteDetailScreen({required this.invite, super.key});
  final Invite invite;

  @override
  Widget build(BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.inviteDetail)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.appointmentAppointmentid(invite.appointmentId)),
            Text(l10n.fromName(invite.inviteeContact?.displayName ?? l10n.unknown)),
            Text(l10n.phoneLabel(invite.inviteeContact?.phoneNumber ?? l10n.noPhone)),
            Text(l10n.statusInvitestatusname(invite.status.name, invite.status.name)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: invite.status == InviteStatus.pending
                        ? () async {
                            await ref
                                .read(inviteServiceProvider)
                                .respondToInvite(
                                  invite.appointmentId,
                                  invite.inviteeId,
                                  InviteStatus.accepted,
                                );
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          }
                        : null,
                    child: Text(l10n.accept),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: invite.status == InviteStatus.pending
                        ? () async {
                            await ref
                                .read(inviteServiceProvider)
                                .respondToInvite(
                                  invite.appointmentId,
                                  invite.inviteeId,
                                  InviteStatus.declined,
                                );
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          }
                        : null,
                    child: Text(l10n.decline),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
