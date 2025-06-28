import 'package:flutter/material.dart';
import '../../config/theme.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  final String? title;

  const AppScaffold({Key? key, required this.child, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: title != null ? AppBar(title: Text(title!)) : null,
      body: SafeArea(child: child),
    );
  }
}
