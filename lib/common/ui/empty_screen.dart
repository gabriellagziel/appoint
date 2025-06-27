import 'package:flutter/material.dart';

/// Simple screen displayed when there is no content available.
class EmptyScreen extends StatelessWidget {
  final VoidCallback onExplore;

  const EmptyScreen({
    super.key,
    required this.onExplore,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Nothing here yet', textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onExplore,
            child: const Text('Explore'),
          ),
        ],
      ),
    );
  }
}
