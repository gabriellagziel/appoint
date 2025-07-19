import 'package:flutter/material.dart';
import 'package:appoint/l10n/app_localizations.dart';

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
                Text(AppLocalizations.of(context)!.authErrorInternalError,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),),
                const SizedBox(height: 8),
                Text(_error.toString(),
                    style: const TextStyle(color: Colors.grey),),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => setState(() {
                    _error = null;
                  }),
                  child:
                      Text(AppLocalizations.of(context)!.retry),
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
