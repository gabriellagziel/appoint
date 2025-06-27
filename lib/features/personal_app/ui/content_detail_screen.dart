import 'package:flutter/material.dart';

// TODO per spec §2.1
class ContentDetailScreen extends StatelessWidget {
  final String id;

  const ContentDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Content Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            SizedBox(height: 24),
            FlutterLogo(size: 200),
            SizedBox(height: 24),
            Text(
              'Content Title Placeholder',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text('Content description coming soon.'),
          ],
        ),
      ),
    );
  }
}
