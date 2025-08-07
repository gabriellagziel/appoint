# Observability Instrumentation Snippets

This document provides sample code to emit metrics for booking flows and expose Prometheus metrics endpoints.

## Flutter / Dart

```dart
import 'package:prometheus_client/formatters.dart' as prometheus;
import 'package:prometheus_client/prometheus_client.dart';
import 'dart:io';

final bookingSuccessTotal = Counter(
  name: 'booking_success_total',
  help: 'Total successful bookings',
);
final bookingAttemptTotal = Counter(
  name: 'booking_attempt_total',
  help: 'Total booking attempts',
);
final requestDuration = Histogram(
  name: 'http_request_duration_seconds',
  help: 'Request latency',
  buckets: [0.1, 0.3, 0.5, 1, 2, 5],
);

/// Call when a booking is attempted
void recordBookingAttempt() {
  bookingAttemptTotal.inc();
}

/// Call when a booking succeeds
void recordBookingSuccess() {
  bookingSuccessTotal.inc();
}

/// Wrap HTTP requests to record timing
Future<T> trackRequest<T>(String path, Future<T> Function() f) async {
  final timer = requestDuration.startTimer();
  try {
    return await f();
  } finally {
    timer.observeDuration();
  }
}

/// Simple /metrics handler
Future<void> serveMetrics() async {
  final server = await HttpServer.bind(InternetAddress.anyIPv4, 8081);
  server.listen((request) {
    if (request.uri.path == '/metrics') {
      final body = prometheus.render();
      request.response
        ..headers.contentType = ContentType.text
        ..write(body)
        ..close();
    } else {
      request.response.statusCode = HttpStatus.notFound;
      request.response.close();
    }
  });
}
```

Placeholders for SLO thresholds can be injected when configuring alerts.

## Node.js (Express)

```javascript
const express = require('express');
const client = require('prom-client');
const app = express();
const collectDefaultMetrics = client.collectDefaultMetrics;
collectDefaultMetrics();

const bookingSuccessTotal = new client.Counter({
  name: 'booking_success_total',
  help: 'Total successful bookings',
});
const bookingAttemptTotal = new client.Counter({
  name: 'booking_attempt_total',
  help: 'Total booking attempts',
});
const requestDuration = new client.Histogram({
  name: 'http_request_duration_seconds',
  help: 'Request latency',
  buckets: [0.1, 0.3, 0.5, 1, 2, 5],
});

app.use((req, res, next) => {
  const end = requestDuration.startTimer();
  res.on('finish', () => end());
  next();
});

app.post('/book', (req, res) => {
  bookingAttemptTotal.inc();
  // Booking logic here
  bookingSuccessTotal.inc();
  res.send('ok');
});

app.get('/metrics', async (req, res) => {
  res.set('Content-Type', client.register.contentType);
  res.end(await client.register.metrics());
});

app.listen(3000);
```

Threshold values such as `api_p95_latency_ms` should be referenced from configuration when creating alert rules.
