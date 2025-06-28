// TODO per spec §2.1
import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView(
        children: const [
          ListTile(title: Text('Notification 1')),
          ListTile(title: Text('Notification 2')),
          ListTile(title: Text('Notification 3')),
        ],
      ),
    );
  }
}
