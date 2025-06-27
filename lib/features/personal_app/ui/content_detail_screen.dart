import 'package:flutter/material.dart';

/// TODO: Implement detailed content view
class ContentDetailScreen extends StatelessWidget {
  final String contentId;

  const ContentDetailScreen({super.key, required this.contentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Content Detail')),
      body: Center(
        child: Text('Content ID: $contentId'),
      ),
    );
  }
}
