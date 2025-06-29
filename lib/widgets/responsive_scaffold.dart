import 'package:flutter/material.dart';

/// Simple scaffold that renders different layouts based on width breakpoints.
class ResponsiveScaffold extends StatelessWidget {
  const ResponsiveScaffold({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        if (width >= 1024 && desktop != null) {
          return SafeArea(
              child:
                  Padding(padding: const EdgeInsets.all(16), child: desktop!));
        }
        if (width >= 600 && tablet != null) {
          return SafeArea(
              child:
                  Padding(padding: const EdgeInsets.all(16), child: tablet!));
        }
        return SafeArea(
            child: Padding(padding: const EdgeInsets.all(16), child: mobile));
      },
    );
  }
}
