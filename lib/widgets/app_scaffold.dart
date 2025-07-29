import 'package:appoint/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// Basic wrapper around [Scaffold] used across the app.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.body,
    super.key,
    this.title,
    this.actions,
    this.floatingActionButton,
    this.useSliverAppBar = false,
  });

  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool useSliverAppBar;

  @override
  Widget build(BuildContext context) {
    final content = SafeArea(
      child: useSliverAppBar
          ? CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  title: title != null ? Text(title!) : null,
                  actions: actions,
                ),
                SliverFillRemaining(child: body),
              ],
            )
          : body,
    );

    return Scaffold(
      appBar: useSliverAppBar
          ? null
          : (title != null || actions != null
              ? AppBar(
                  title: title != null ? Text(title!) : null,
                  actions: actions,
                )
              : null),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: content,
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
