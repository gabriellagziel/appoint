import 'package:flutter/material.dart';

class ExtrasStep extends StatelessWidget {
  const ExtrasStep({super.key});
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Extras (forms/checklist) — placeholder'),
        SizedBox(height: 8),
        Text('Add fields according to type (event/playtime).'),
      ],
    );
  }
}


