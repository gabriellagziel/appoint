import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/greeting_section.dart';
import '../widgets/quick_actions.dart';
import '../widgets/today_schedule_section.dart';
import '../widgets/smart_suggestions.dart';

class HomeLandingScreen extends ConsumerWidget {
  const HomeLandingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          // TODO: Refresh data from controllers
          await Future.delayed(const Duration(seconds: 1));
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            GreetingSection(),
            SizedBox(height: 24),
            QuickActions(),
            SizedBox(height: 24),
            TodayScheduleSection(),
            SizedBox(height: 24),
            SmartSuggestions(),
          ],
        ),
      ),
    );
  }
}



