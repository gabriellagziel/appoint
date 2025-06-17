import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/chat_flow_widget.dart';

class ChatBookingScreen extends ConsumerWidget {
  const ChatBookingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const ChatFlowWidget();
  }
}
