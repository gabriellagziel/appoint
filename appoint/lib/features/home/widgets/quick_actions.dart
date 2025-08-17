import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/services/analytics_service.dart' as analytics;
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../services/api_client.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../services/auth/auth_providers.dart';

class QuickActions extends ConsumerWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    Widget qa(
        {required String keyVal,
        required IconData icon,
        required String label,
        required String route,
        required String event}) {
      return Semantics(
        label: label,
        button: true,
        child: FilledButton.tonalIcon(
          key: Key(keyVal),
          icon: Icon(icon),
          label: Text(label),
          style: FilledButton.styleFrom(
            foregroundColor: cs.onSecondaryContainer,
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          onPressed: () async {
            debugPrint('QA tap → $route');
            await analytics.Analytics.log('quick_action', {'event': event});
            if (!context.mounted) return;
            context.push(route);
          },
        ),
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          qa(
              keyVal: 'qa_action_new_meeting',
              icon: Icons.add_circle,
              label: 'New Meeting v3',
              route: '/meeting/create',
              event: 'new_meeting'),
          qa(
              keyVal: 'qa_action_add_reminder',
              icon: Icons.alarm_add,
              label: 'Add Reminder v3',
              route: '/reminders/create',
              event: 'add_reminder'),
          qa(
              keyVal: 'qa_action_open_calendar',
              icon: Icons.calendar_month,
              label: 'Open Calendar v3',
              route: '/calendar',
              event: 'open_calendar'),
          qa(
              keyVal: 'qa_action_my_groups',
              icon: Icons.groups_2_outlined,
              label: 'My Groups v3',
              route: '/groups',
              event: 'my_groups'),
          Semantics(
            label: 'Go Premium',
            button: true,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.star),
              label: const Text('Go Premium'),
              onPressed: () async {
                final uid = ref.read(currentUserIdProvider) ?? 'anonymous';
                final resp = await http.post(
                  ApiClient.uri('/api/user/premium/checkout'),
                  headers: {'Content-Type': 'application/json'},
                  body: jsonEncode({
                    'userId': uid,
                    'priceId': const String.fromEnvironment(
                        'USER_PREMIUM_PRICE_ID',
                        defaultValue: 'price_123'),
                    'successUrl': Uri.base.replace(
                        queryParameters: {'premium': 'success'}).toString(),
                    'cancelUrl': Uri.base.toString(),
                  }),
                );
                if (resp.statusCode == 200) {
                  final url =
                      (jsonDecode(resp.body) as Map<String, dynamic>)['url']
                          ?.toString();
                  if (url != null) {
                    final u = Uri.parse(url);
                    if (!await launchUrl(u,
                        mode: LaunchMode.externalApplication)) {
                      await launchUrl(u);
                    }
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
