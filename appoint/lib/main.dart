import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'app_router.dart';

void main() {
  runApp(
    const ProviderScope(
      child: AppOintApp(),
    ),
  );
}

class AppOintApp extends StatelessWidget {
  const AppOintApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'App-Oint',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}


