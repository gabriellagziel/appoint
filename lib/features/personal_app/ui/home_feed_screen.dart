import 'package:flutter/material.dart';
import '../../../common/ui/error_screen.dart';
import '../../../common/ui/empty_screen.dart';

class HomeFeedScreen extends StatelessWidget {
  const HomeFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Stubbed booleans for demonstration
    const hasError = false;
    const isEmpty = true;

    if (hasError) {
      return Scaffold(
        appBar: AppBar(title: const Text('Home')),
        body: ErrorScreen(
          onRetry: () {},
        ),
      );
    }

    if (isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Home')),
        body: EmptyScreen(
          onExplore: () {},
        ),
      );
    }

    return const Scaffold(
      body: Center(child: Text('Home Feed Screen')),
    );
  }
}
