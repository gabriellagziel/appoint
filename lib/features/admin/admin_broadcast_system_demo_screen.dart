// DEMO SCREEN: For onboarding/testing. For production, use AdminBroadcastScreen and AdminBroadcastMessage.
// See lib/features/admin/admin_broadcast_screen.dart for the full implementation.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Demo provider for Broadcast Messages
final broadcastMessageProvider =
    StateNotifierProvider<BroadcastMessageNotifier, BroadcastMessage>((ref) {
  return BroadcastMessageNotifier();
});

class BroadcastMessageNotifier extends StateNotifier<BroadcastMessage> {
  BroadcastMessageNotifier()
      : super(BroadcastMessage(message: '', target: 'All'));

  void sendMessage(String message, String target) {
    state = BroadcastMessage(message: message, target: target);
    // In production, implement message sending logic (e.g., Firebase)
  }
}

class BroadcastMessage {
  final String message;
  final String target;
  BroadcastMessage({required this.message, required this.target});
}

class BroadcastSystemDemoScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final broadcastMessage = ref.watch(broadcastMessageProvider);

    return Scaffold(
      appBar: AppBar(title: Text("Broadcast System")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: "Message"),
              onChanged: (value) {
                ref
                    .read(broadcastMessageProvider.notifier)
                    .sendMessage(value, broadcastMessage.target);
              },
            ),
            // Add more fields for targeting users (e.g., country, language)
            ElevatedButton(
              onPressed: () {
                ref
                    .read(broadcastMessageProvider.notifier)
                    .sendMessage(broadcastMessage.message, 'All');
              },
              child: Text("Send Message"),
            ),
          ],
        ),
      ),
    );
  }
}
