import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeDashboardStub extends StatelessWidget {
  const HomeDashboardStub({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            final u = Uri.base;
            final skip =
                u.queryParameters['skipSetup'] == '1' ? '&skipSetup=1' : '';
            context.go('/flow?preview=mobile$skip');
          },
          child: const Text('Start meeting flow'),
        ),
      ),
    );
  }
}

