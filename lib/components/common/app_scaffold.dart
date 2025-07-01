import 'package:flutter/material.dart';
import 'package:appoint/config/theme.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  final String? title;

  const AppScaffold({final Key? key, required this.child, this.title}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: title != null ? AppBar(title: Text(title!)) : null,
      body: SafeArea(child: child),
    );
  }
}
