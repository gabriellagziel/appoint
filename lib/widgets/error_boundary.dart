import 'package:flutter/material.dart';

class ErrorBoundary extends StatefulWidget {
  const ErrorBoundary({required this.child, super.key});
  final Widget child;

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  Object? _error;

  @override
  void initState() {
    super.initState();
    FlutterError.onError = (FlutterErrorDetails details) {
      setState(() {
        _error = details.exception;
      });
      FlutterError.dumpErrorToConsole(details);
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 64),
                const SizedBox(height: 16),
                const Text('Something went wrong',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                const SizedBox(height: 8),
                Text(_error.toString(),
                    style: const TextStyle(color: Colors.grey),),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => setState(() {
                    _error = null;
                  }),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return widget.child;
  }
}
