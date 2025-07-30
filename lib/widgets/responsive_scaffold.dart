import 'package:appoint/theme/app_breakpoints.dart';
import 'package:appoint/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// Simple scaffold that renders different layouts based on width breakpoints.
class ResponsiveScaffold extends StatelessWidget {
  const ResponsiveScaffold({
    required this.mobile,
    super.key,
    this.tablet,
    this.desktop,
  });

  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, final constraints) {
          final width = constraints.maxWidth;
          if (width >= AppBreakpoints.desktop && desktop != null) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: desktop,
              ),
            );
          }
          if (width >= AppBreakpoints.tablet && tablet != null) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: tablet,
              ),
            );
          }
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: mobile,
            ),
          );
        },
      );
}
