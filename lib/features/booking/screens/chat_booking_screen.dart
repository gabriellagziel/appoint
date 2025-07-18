import 'package:appoint/features/booking/widgets/chat_flow_widget.dart';
import 'package:appoint/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatBookingScreen extends ConsumerWidget {
  const ChatBookingScreen({super.key});

  @override
  Widget build(BuildContext context, final WidgetRef ref) {
    final auth = ref.read(authServiceProvider);
    return ChatFlowWidget(auth: auth);
  }
}
