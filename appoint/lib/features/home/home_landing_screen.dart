import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import 'widgets/greeting_header.dart';
import 'widgets/quick_actions.dart';
import 'widgets/today_agenda.dart';
import 'widgets/suggestions_strip.dart';

class HomeLandingScreen extends ConsumerWidget {
  const HomeLandingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sp = Theme.of(context).extension<AppSpace>() ?? AppSpace.defaults;
    final cr = Theme.of(context).extension<AppCorners>() ?? AppCorners.defaults;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, c) {
            final isMobile = c.maxWidth < 720;
            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(sp.lg, sp.lg, sp.lg, sp.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Greeting
                  Card(
                    key: const Key('home_card_greeting'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(cr.xl),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(sp.lg),
                      child: const GreetingHeader(isDesktop: true),
                    ),
                  ),
                  SizedBox(height: sp.lg),

                  // Quick Actions + Suggestions
                  Flex(
                    direction: isMobile ? Axis.vertical : Axis.horizontal,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Card(
                          key: const Key('home_card_quick_actions'),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(cr.xl),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(sp.lg),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Quick actions',
                                    style:
                                        Theme.of(context).textTheme.titleLarge),
                                SizedBox(height: sp.md),
                                const QuickActions(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (!isMobile)
                        SizedBox(width: sp.lg)
                      else
                        SizedBox(height: sp.lg),
                      Expanded(
                        flex: 3,
                        child: Card(
                          key: const Key('home_card_suggestions'),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(cr.xl),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(sp.lg),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Suggestions',
                                    style:
                                        Theme.of(context).textTheme.titleLarge),
                                SizedBox(height: sp.md),
                                const SuggestionsStrip(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: sp.lg),

                  // Today Agenda
                  Card(
                    key: const Key('home_card_today'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(cr.xl),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(sp.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('Today at a glance',
                                  style:
                                      Theme.of(context).textTheme.titleLarge),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: cs.surfaceVariant,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text('-',
                                    key: Key('agenda_count_chip')),
                              ),
                            ],
                          ),
                          SizedBox(height: sp.md),
                          const TodayAgenda(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
