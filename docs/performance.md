# Performance Documentation

## Performance Profiling

Profiling helps identify slow operations and memory leaks. Launch the app in profiling mode using:

```bash
flutter run --profile
```

Enable timeline tracing to capture startup information:

```bash
flutter run --trace-startup --profile
```

Open the Flutter DevTools **Performance** tab to inspect timeline events. You can also record custom events with `dart:developer`:

```dart
import 'dart:developer';

void expensiveOperation() {
  Timeline.startSync('expensiveOperation');
  // ... work ...
  Timeline.finishSync();
}
```

Export the timeline to a JSON file by clicking **Export Timeline** in DevTools. Analyze the resulting log with Chrome tracing or other visualization tools.

## Profiling Logs

Run the application with `--trace-skia` to log rendering commands:

```bash
flutter run --profile --trace-skia --trace-systrace
```

The logs are written to `build/flutter_profile.log`. Use `flutter screenshot` to capture GPU information for offline analysis.

## Content Management Module (once merged)

A new content management module will allow administrators to edit static pages and translations directly from the dashboard. When integrated:

- It will live under `lib/content/` with pages stored in Firestore.
- Access is restricted to roles configured in Firebase Auth.
- The module exposes widgets for creating, editing and publishing content.

Refer to project release notes for the merge status and additional configuration options.
