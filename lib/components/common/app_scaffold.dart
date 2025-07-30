import 'package:appoint/config/theme.dart';
import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({required this.child, super.key, this.title});
  final Widget child;
  final String? title;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: title != null ? AppBar(title: Text(title!)) : null,
        body: SafeArea(child: child),
      );
}
