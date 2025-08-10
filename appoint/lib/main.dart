import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_web_plugins/url_strategy.dart';
import 'app_router.dart' show router;

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    // ignore: avoid_print
    print(details.exceptionAsString());
    // ignore: avoid_print
    print(details.stack);
  };
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Something went wrong.\n${details.exceptionAsString()}'),
        ),
      ),
    );
  };
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) setUrlStrategy(const HashUrlStrategy());
  print('[[MAIN]] main.dart at appoint/lib/main.dart IS RUNNING');
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: router);
  }
}
