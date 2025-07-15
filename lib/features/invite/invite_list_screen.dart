import 'package:appoint/l10n/app_localizations.dart';
import 'package:appoint/providers/invite_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InviteListScreen extends ConsumerWidget {
  const InviteListScreen({super.key});

  @override
  Widget build(BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final invitesAsync = ref.watch(myInvitesStreamProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.myInvites)),
      body: invitesAsync.when(
        data: (invites) {
          if (invites.isEmpty) {
            return Center(child: Text(l10n.noInvites));
          }
          return ListView.builder(
            itemCount: invites.length,
            itemBuilder: (context, final index) {
              final invite = invites[index];
              return ListTile(
                title: Text(invite.inviteeContact?.displayName ?? 'Unknown'),
                subtitle: Text(invite.status.name),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/invite-detail',
                    arguments: invite,
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, final __) =>
            Center(child: Text(l10n.errorLoadingInvites)),
      ),
    );
  }
}
