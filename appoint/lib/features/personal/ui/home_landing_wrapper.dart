import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'personal_start_screen.dart';
import '../providers/personal_setup_provider.dart';
import '../../home/home_landing_screen.dart';

class HomeLandingWrapper extends ConsumerWidget {
  const HomeLandingWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completedAsync = ref.watch(REDACTED_TOKEN);
    return completedAsync.when(
      data: (done) =>
          done ? const HomeLandingScreen() : const PersonalStartScreen(),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, __) => const HomeLandingScreen(),
    );
  }
}
