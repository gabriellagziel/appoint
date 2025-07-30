import 'package:flutter/material.dart';

/// TODO: implement per spec §2.1
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) => const ListTile(),
      ),
    );
  }
}
