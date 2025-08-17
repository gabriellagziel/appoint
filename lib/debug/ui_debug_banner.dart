import 'package:flutter/material.dart';
import '../core/preview_flags.dart';

class UiDebugBanner extends StatelessWidget {
  const UiDebugBanner({super.key});
  @override
  Widget build(BuildContext context) {
    final flags = PreviewFlags.fromEnvironmentAndUrl();
    final width = MediaQuery.of(context).size.width.toStringAsFixed(0);
    return IgnorePointer(
      ignoring: true,
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          color: Colors.black.withOpacity(0.6),
          child: Text('w:$width | $flags',
              style: const TextStyle(color: Colors.white, fontSize: 11)),
        ),
      ),
    );
  }
}

