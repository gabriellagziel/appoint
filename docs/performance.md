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

## DevTools Memory and Performance Profiling

### Setup Instructions

1. **Launch app in profile mode:**
   ```bash
   flutter run --profile
   ```

2. **Open DevTools:**
   ```bash
   flutter pub global activate devtools
   flutter pub global run devtools
   ```

3. **Connect to running app** and navigate to:
   - **Memory tab** for heap analysis
   - **Performance tab** for FPS and frame analysis

### Recording Metrics Under 50-Booking Load

#### Memory Profiling Steps:
1. Open DevTools Memory tab
2. Take initial heap snapshot
3. Load 50+ bookings in the calendar
4. Take second heap snapshot
5. Compare snapshots for memory leaks
6. Record peak memory usage

#### Performance Profiling Steps:
1. Open DevTools Performance tab
2. Start recording
3. Navigate to calendar with 50+ bookings
4. Perform typical user interactions (scroll, filter, search)
5. Stop recording
6. Analyze frame times and FPS

#### Metrics to Record:
- **Memory Usage**: Baseline vs. 50-booking load
- **FPS**: Average and minimum frame rates
- **Frame Build Time**: 90th percentile frame build time
- **Memory Leaks**: Objects not properly disposed
- **Garbage Collection**: Frequency and duration

### Profiling Logs

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

# Performance Metrics Documentation

## Calendar Widget Performance

### Test Results

#### Calendar Widget Build Performance
- **Target**: ≤ 1000ms build time
- **Memory Usage**: TBD (to be measured with DevTools)
- **FPS Target**: ≥ 60 FPS (16ms frame time)

#### Calendar with 50+ Events Performance
- **Target**: ≤ 1000ms build time with 50+ bookings
- **Memory Usage**: TBD (to be measured with DevTools)
- **FPS Target**: ≥ 60 FPS under load

#### Calendar Navigation Performance
- **Target**: ≤ 1000ms for rapid tab switching
- **Memory Usage**: TBD (to be measured with DevTools)
- **FPS Target**: ≥ 60 FPS during navigation

### DevTools Profiling Results

#### Memory Profiling
- **Baseline Memory**: TBD
- **Memory with 50 bookings**: TBD
- **Memory Leaks**: TBD

#### Performance Profiling
- **Average Frame Build Time**: TBD
- **90th Percentile Frame Build Time**: TBD
- **Peak Memory Usage**: TBD

### Performance Optimization Recommendations

1. **Widget Optimization**
   - Use `const` constructors where possible
   - Implement `shouldRebuild` in custom widgets
   - Use `ListView.builder` for large lists

2. **Memory Management**
   - Dispose of controllers properly
   - Use weak references for callbacks
   - Implement proper widget lifecycle management

3. **Rendering Optimization**
   - Minimize widget rebuilds
   - Use `RepaintBoundary` for complex widgets
   - Optimize image loading and caching

### Testing Methodology

1. **Integration Tests**: Automated performance tests in `integration_test/performance_test.dart`
2. **DevTools Profiling**: Manual profiling with Flutter DevTools
3. **Memory Analysis**: Heap snapshots and memory leak detection
4. **FPS Monitoring**: Real-time frame rate monitoring

### Performance Baselines

| Metric | Target | Current | Status |
|--------|--------|---------|--------|
| Build Time | ≤ 1000ms | TBD | ⏳ |
| Memory Usage | < 100MB | TBD | ⏳ |
| FPS | ≥ 60 | TBD | ⏳ |
| Frame Build Time | < 16ms | TBD | ⏳ |

### Notes

- Performance metrics are measured on representative devices
- Tests include various screen sizes and orientations
- Memory profiling includes garbage collection analysis
- FPS monitoring covers both idle and active states
