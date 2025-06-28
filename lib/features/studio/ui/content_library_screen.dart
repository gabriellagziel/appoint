import 'package:flutter/material.dart';

/// TODO: Implement content list per spec §2.2
class ContentLibraryScreen extends StatelessWidget {
  const ContentLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Content Library'),
      ),
      body: ListView(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text('No content available yet'),
            ),
          ),
        ],
      ),
    );
  }
}
