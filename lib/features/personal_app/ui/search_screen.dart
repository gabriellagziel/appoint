import 'package:flutter/material.dart';

/// TODO: implement per spec §2.1
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: TextField(),
          ),
          const Expanded(
            child: ListView(
              children: [],
            ),
          ),
        ],
      ),
    );
  }
}
