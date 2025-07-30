import 'package:flutter/material.dart';

class ResponsiveScaffold extends StatelessWidget {
  const ResponsiveScaffold({
    required this.body,
    super.key,
    this.drawer,
    this.bottomNavigationBar,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  });
  final Widget body;
  final Widget? drawer;
  final Widget? bottomNavigationBar;
  final PreferredSizeWidget? appBar;
  final FloatingActionButton? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 800;

    return Scaffold(
      appBar: appBar,
      drawer: isDesktop ? null : drawer,
      bottomNavigationBar: isDesktop ? null : bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      body: Row(
        children: [
          if (isDesktop && drawer != null) SizedBox(width: 250, child: drawer),
          Expanded(child: body),
        ],
      ),
    );
  }
}
