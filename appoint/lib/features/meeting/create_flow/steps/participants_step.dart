import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';
import 'package:appoint/services/auth/auth_providers.dart';

class ParticipantsStep extends ConsumerWidget {
  const ParticipantsStep({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(REDACTED_TOKEN);
    final ctrl = ref.read(REDACTED_TOKEN.notifier);
    final candidates = const [
      'alice@x.com',
      'bob@x.com',
      'carol@x.com',
      'dave@x.com'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Who\'s joining?'),
        const SizedBox(height: 8),
        Row(children: [
          OutlinedButton.icon(
            onPressed: () async {
              // Request a real invite code from Functions (use a basic personal group id placeholder if none)
              final uid = ref.read(currentUserIdProvider) ?? 'anonymous';
              final uri = Uri.parse('/api/groups/invite/create');
              final resp = await http.post(uri,
                  headers: {'Content-Type': 'application/json'},
                  body: jsonEncode({'groupId': 'personal-$uid'}));
              String invite = 'https://app.app-oint.com/join';
              if (resp.statusCode == 200) {
                final m = jsonDecode(resp.body) as Map<String, dynamic>;
                invite = m['url']?.toString() ?? invite;
              }
              await Clipboard.setData(ClipboardData(text: invite));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invite link copied')),
                );
              }
            },
            icon: const Icon(Icons.link),
            label: const Text('Share Invite Link'),
          ),
          const SizedBox(width: 8),
          OutlinedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Group Invite'),
                  content: const SelectableText(
                      'https://app.app-oint.com/join?code=GROUP_INVITE_DEMO'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('Close')),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.qr_code),
            label: const Text('Show Link'),
          ),
        ]),
        const SizedBox(height: 8),
        ...candidates.map((p) {
          final on = state.participantIds.contains(p);
          return CheckboxListTile(
            value: on,
            title: Text(p),
            onChanged: (_) {
              final set = state.participantIds.toList();
              if (on) {
                set.remove(p);
              } else {
                set.add(p);
              }
              ctrl.setParticipants(set);
            },
          );
        }),
      ],
    );
  }
}
