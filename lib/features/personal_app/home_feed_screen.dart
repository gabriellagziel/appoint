import 'package:flutter/material.dart';
import 'package:appoint/common/ui/error_screen.dart';
import 'package:appoint/common/ui/empty_screen.dart';

class HomeFeedScreen extends StatelessWidget {
  const HomeFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const hasError = false; // Placeholder for error state
    const isEmpty = false; // Placeholder for empty state

    Widget body;
    if (hasError) {
      body = ErrorScreen(
        message: 'Something went wrong',
        onRetry: () {},
      );
    } else if (isEmpty) {
      body = EmptyScreen(
        subtitle: 'No posts yet',
        actionLabel: 'Refresh',
        onAction: () {},
      );
    } else {
      body = const Center(child: Text('Home Feed Screen'));
    }

    return Scaffold(
      body: body,
    );
  }
}
