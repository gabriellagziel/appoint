import 'package:flutter/material.dart';

class EmptyScreen extends StatelessWidget {
  final String message;
  final VoidCallback? onExplore;

  const EmptyScreen({super.key, this.message = 'Nothing here yet', this.onExplore});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message, textAlign: TextAlign.center),
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
