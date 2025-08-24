import 'package:flutter/material.dart';

class BusinessCalendarScreen extends StatelessWidget {
  const BusinessCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Business Calendar'),
          bottom: const TabBar(
            tabs: [Tab(text: 'Week'), Tab(text: 'Month'), Tab(text: 'Day')],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('Week View')),
            Center(child: Text('Month View')),
            Center(child: Text('Day View')),
          ],
        ),
      ),
    );
  }
}

