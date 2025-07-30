import 'package:flutter/material.dart';
import 'package:appoint/common/ui/error_screen.dart';
import 'package:appoint/common/ui/empty_screen.dart';

class HomeFeedScreen extends StatelessWidget {
  const HomeFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool hasError = false; // Placeholder for error state
    bool isEmpty = false; // Placeholder for empty state

    Widget body;
    // ignore: dead_code
    if (hasError) {
      body = ErrorScreen(
        message: 'Something went wrong',
        onRetry: () {},
      );
    // ignore: dead_code
    } else if (isEmpty) {
      body = EmptyScreen(
        onExplore: () {},
      );
    } else {
      body = const Center(child: Text('Home Feed Screen'));
    }

    return Scaffold(
      body: body,
    );
  }
}
