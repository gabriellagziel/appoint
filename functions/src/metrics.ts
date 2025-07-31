import * as functions from 'firebase-functions';

// Metrics collection interface
interface HttpMetrics {
  request_count: number;
  request_duration_p50: number;
  request_duration_p95: number;
  request_duration_p99: number;
  error_rate_4xx: number;
  error_rate_5xx: number;
  cpu_usage: number;
  memory_usage: number;
  active_connections: number;
}

interface RequestMetric {
  timestamp: number;
  method: string;
  path: string;
  statusCode: number;
  duration: number;
  userAgent?: string;
  ip?: string;
}

// In-memory metrics store (for demonstration - use Redis/DB in production)
class MetricsCollector {
  private requests: RequestMetric[] = [];
  private maxStoredRequests = 10000;

  addRequest(metric: RequestMetric) {
    this.requests.push(metric);
    
    // Keep only recent requests
    if (this.requests.length > this.maxStoredRequests) {
      this.requests = this.requests.slice(-this.maxStoredRequests);
    }
  }

  getMetrics(timeWindowMs: number = 300000): HttpMetrics { // Default 5 minutes
    const now = Date.now();
    const windowStart = now - timeWindowMs;
    const recentRequests = this.requests.filter(r => r.timestamp >= windowStart);

    if (recentRequests.length === 0) {
      return {
        request_count: 0,
        request_duration_p50: 0,
        request_duration_p95: 0,
        request_duration_p99: 0,
        error_rate_4xx: 0,
        error_rate_5xx: 0,
        cpu_usage: 0,
        memory_usage: 0,
        active_connections: 0,
      };
    }

    // Calculate percentiles
    const durations = recentRequests.map(r => r.duration).sort((a, b) => a - b);
    const p50Index = Math.floor(durations.length * 0.5);
    const p95Index = Math.floor(durations.length * 0.95);
    const p99Index = Math.floor(durations.length * 0.99);

    // Calculate error rates
    const total4xx = recentRequests.filter(r => r.statusCode >= 400 && r.statusCode < 500).length;
    const total5xx = recentRequests.filter(r => r.statusCode >= 500).length;
    const totalRequests = recentRequests.length;

    // System metrics
    const memory = process.memoryUsage();
    const memoryUsagePercent = (memory.heapUsed / memory.heapTotal) * 100;

    return {
      request_count: totalRequests,
      request_duration_p50: durations[p50Index] || 0,
      request_duration_p95: durations[p95Index] || 0,
      request_duration_p99: durations[p99Index] || 0,
      error_rate_4xx: (total4xx / totalRequests) * 100,
      error_rate_5xx: (total5xx / totalRequests) * 100,
      cpu_usage: this.getCpuUsage(),
      memory_usage: memoryUsagePercent,
      active_connections: 0, // Would need to track connections separately
    };
  }

  private getCpuUsage(): number {
    const usage = process.cpuUsage();
    return (usage.user + usage.system) / 1000000; // Convert to seconds
  }

  getPrometheusMetrics(): string {
    const metrics = this.getMetrics();
    const timestamp = Date.now();

    return `
# HELP http_requests_total Total number of HTTP requests
# TYPE http_requests_total counter
http_requests_total ${metrics.request_count} ${timestamp}

# HELP http_request_duration_seconds HTTP request duration percentiles
# TYPE http_request_duration_seconds histogram
http_request_duration_seconds{quantile="0.5"} ${metrics.request_duration_p50 / 1000} ${timestamp}
http_request_duration_seconds{quantile="0.95"} ${metrics.request_duration_p95 / 1000} ${timestamp}
http_request_duration_seconds{quantile="0.99"} ${metrics.request_duration_p99 / 1000} ${timestamp}

# HELP http_errors_rate HTTP error rate percentage
# TYPE http_errors_rate gauge
http_errors_4xx_rate ${metrics.error_rate_4xx} ${timestamp}
http_errors_5xx_rate ${metrics.error_rate_5xx} ${timestamp}

# HELP process_cpu_usage_seconds CPU usage in seconds
# TYPE process_cpu_usage_seconds gauge
process_cpu_usage_seconds ${metrics.cpu_usage} ${timestamp}

# HELP process_memory_usage_percent Memory usage percentage
# TYPE process_memory_usage_percent gauge
process_memory_usage_percent ${metrics.memory_usage} ${timestamp}
    `.trim();
  }
}

// Global metrics collector instance
const metricsCollector = new MetricsCollector();

// Middleware function to track requests
export function trackRequest(req: any, res: any, next: any) {
  const startTime = Date.now();
  
  // Patch res.end to capture response
  const originalEnd = res.end;
  res.end = function(...args: any[]) {
    const duration = Date.now() - startTime;
    
    metricsCollector.addRequest({
      timestamp: startTime,
      method: req.method,
      path: req.path || req.url,
      statusCode: res.statusCode,
      duration,
      userAgent: req.get('User-Agent'),
      ip: req.ip || req.connection.remoteAddress,
    });
    
    originalEnd.apply(res, args);
  };
  
  next();
}

// Metrics endpoint for Prometheus scraping
export const metrics = functions.https.onRequest((req, res) => {
  // Set CORS headers
  res.set('Access-Control-Allow-Origin', '*');
  res.set('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.set('Access-Control-Allow-Headers', 'Content-Type');

  // Handle preflight requests
  if (req.method === 'OPTIONS') {
    res.status(204).send('');
    return;
  }

  // Only allow GET requests
  if (req.method !== 'GET') {
    res.status(405).json({ error: 'Method not allowed' });
    return;
  }

  try {
    const prometheusMetrics = metricsCollector.getPrometheusMetrics();
    res.set('Content-Type', 'text/plain; version=0.0.4; charset=utf-8');
    res.status(200).send(prometheusMetrics);
  } catch (error) {
    console.error('Failed to generate metrics:', error);
    res.status(500).json({ error: 'Failed to generate metrics' });
  }
});

// JSON metrics endpoint for debugging
export const metricsJson = functions.https.onRequest((req, res) => {
  // Set CORS headers
  res.set('Access-Control-Allow-Origin', '*');
  res.set('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.set('Access-Control-Allow-Headers', 'Content-Type');

  // Handle preflight requests
  if (req.method === 'OPTIONS') {
    res.status(204).send('');
    return;
  }

  // Only allow GET requests
  if (req.method !== 'GET') {
    res.status(405).json({ error: 'Method not allowed' });
    return;
  }

  try {
    const timeWindow = parseInt(req.query.window as string) || 300000; // 5 minutes default
    const metrics = metricsCollector.getMetrics(timeWindow);
    
    res.status(200).json({
      timestamp: new Date().toISOString(),
      window_ms: timeWindow,
      metrics,
    });
  } catch (error) {
    console.error('Failed to get metrics:', error);
    res.status(500).json({ error: 'Failed to get metrics' });
  }
});

export { metricsCollector };