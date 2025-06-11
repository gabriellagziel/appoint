import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/invite_provider.dart';

class InviteListScreen extends ConsumerWidget {
  const InviteListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invites = ref.watch(myInvitesStreamProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('My Invites')),
      body: invites.when(
        data: (list) {
          if (list.isEmpty) {
            return const Center(child: Text('No invites'));
          }
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final invite = list[index];
              return ListTile(
                title: Text(invite.inviteeContact.displayName),
                subtitle: Text(invite.status.name),
                onTap: () {
                  Navigator.pushNamed(context, '/invite/detail',
                      arguments: invite);
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Error loading invites')),
      ),
    );
  }
}
