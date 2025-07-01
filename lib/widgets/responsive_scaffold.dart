import 'package:flutter/material.dart';
import 'package:appoint/theme/app_breakpoints.dart';
import 'package:appoint/theme/app_spacing.dart';

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
  Widget build(final BuildContext context) {
    return LayoutBuilder(
      builder: (final context, final constraints) {
        final width = constraints.maxWidth;
        if (width >= AppBreakpoints.desktop && desktop != null) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: desktop!,
            ),
          );
        }
        if (width >= AppBreakpoints.tablet && tablet != null) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: tablet!,
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
}
