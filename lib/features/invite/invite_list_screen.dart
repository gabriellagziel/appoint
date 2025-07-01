import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/providers/invite_provider.dart';
import 'package:appoint/l10n/app_localizations.dart';

class InviteListScreen extends ConsumerWidget {
  const InviteListScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final invitesAsync = ref.watch(myInvitesStreamProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.myInvites)),
      body: invitesAsync.when(
        data: (final invites) {
          if (invites.isEmpty) {
            return Center(child: Text(l10n.noInvites));
          }
          return ListView.builder(
            itemCount: invites.length,
            itemBuilder: (final context, final index) {
              final invite = invites[index];
              return ListTile(
                title: Text(invite.inviteeContact.displayName),
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
        error: (final _, final __) => Center(child: Text(l10n.errorLoadingInvites)),
      ),
    );
  }
}
