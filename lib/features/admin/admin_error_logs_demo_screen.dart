// DEMO SCREEN: For onboarding/testing. For production, use the error/activity log tabs in AdminDashboardScreen.
// See lib/features/admin/admin_dashboard_screen.dart for the full implementation.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Demo provider for Error Logs
final errorLogProvider =
    StateNotifierProvider<ErrorLogNotifier, List<ErrorLog>>((ref) {
  return ErrorLogNotifier();
});

class ErrorLogNotifier extends StateNotifier<List<ErrorLog>> {
  ErrorLogNotifier() : super([]);

  void addErrorLog(String message) {
    state = [...state, ErrorLog(message: message)];
    // In production, log errors to Firebase or another service
  }
}

class ErrorLog {
  final String message;
  ErrorLog({required this.message});
}

class ErrorLogsDemoScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final errorLogs = ref.watch(errorLogProvider);

    return Scaffold(
      appBar: AppBar(title: Text("Error & Activity Logs")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: errorLogs.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(errorLogs[index].message),
              // You can add actions for resolving or filtering logs
            );
          },
        ),
      ),
    );
  }
}
