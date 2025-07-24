# App-Oint Monitoring Stack

This document describes the monitoring setup for the App-Oint application stack using Prometheus and Grafana.

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose
- All App-Oint services running
- Ports 9090 (Prometheus) and 3001 (Grafana) available

### Starting the Monitoring Stack

```bash
# Start all services including monitoring
docker-compose up -d

# Start only monitoring services
docker-compose up -d prometheus grafana

# Check monitoring services status
docker-compose ps prometheus grafana
```

### Access URLs
- **Prometheus**: http://localhost:9090
- **Grafana**: http://localhost:3001
- **Grafana Credentials**: admin/admin (configurable via environment variables)

## 📊 Architecture

### Components

#### Prometheus (Port 9090)
- **Purpose**: Metrics collection and time-series database
- **Configuration**: `prometheus.yml`
- **Data Retention**: 200 hours
- **Scrape Interval**: 15s (global), 30s (services), 60s (infrastructure)

#### Grafana (Port 3001)
- **Purpose**: Visualization and dashboards
- **Default Dashboard**: App-Oint System Overview
- **Data Source**: Prometheus (auto-configured)
- **Plugins**: grafana-piechart-panel

### Monitored Services

| Service | Port | Health Endpoint | Scrape Interval |
|---------|------|----------------|-----------------|
| Functions/API | 8080 | `/health` | 30s |
| Dashboard | 3000 | `/api/health` | 30s |
| Business | 8081 | `/health.html` | 30s |
| Admin | 8082 | `/health.html` | 30s |
| PostgreSQL | 5432 | Connection check | 60s |
| Redis | 6379 | Connection check | 60s |
| Prometheus | 9090 | `/metrics` | 15s |
| Grafana | 3001 | `/metrics` | 60s |

## 🔧 Configuration

### Environment Variables

```bash
# Grafana Authentication
GRAFANA_USER=admin                    # Default: admin
GRAFANA_PASSWORD=admin               # Default: admin

# General Environment
NODE_ENV=production                  # Affects monitoring behavior
```

### Prometheus Configuration

The `prometheus.yml` file defines:

1. **Global Settings**
   - Scrape interval: 15s
   - Evaluation interval: 15s

2. **Service Discovery**
   - Static configurations for all services
   - Automatic service labeling
   - Health check endpoints

3. **Metric Relabeling**
   - Service identification
   - Instance labeling
   - Target configuration

### Grafana Provisioning

Grafana is automatically configured with:

1. **Data Source** (`monitoring/grafana/provisioning/datasources/prometheus.yml`)
   - Prometheus connection
   - Default settings
   - Automatic setup

2. **Dashboards** (`monitoring/grafana/provisioning/dashboards/dashboard.yml`)
   - Dashboard provider configuration
   - Auto-loading from `/etc/grafana/provisioning/dashboards`
   - Update detection

## 📈 Default Dashboard

The system includes a pre-configured dashboard with:

### Service Health Panels
- **Service Status Overview**: Up/Down status for all services
- **Response Time**: Average response time per service
- **Error Rate**: HTTP error rates and failed health checks
- **Request Volume**: Request count and rate per service

### Infrastructure Panels
- **System Resources**: CPU, Memory, Disk usage
- **Database Metrics**: PostgreSQL connections, query performance
- **Cache Metrics**: Redis hit/miss ratio, memory usage
- **Network Metrics**: Network I/O and connections

### Application Panels
- **User Activity**: Active sessions, page views
- **API Performance**: Endpoint response times, throughput
- **Business Metrics**: Custom application metrics
- **Error Tracking**: Application errors and exceptions

## 🛠️ Operations

### Starting Services

```bash
# Start entire stack
docker-compose up -d

# Start monitoring only
docker-compose up -d prometheus grafana

# Restart monitoring services
docker-compose restart prometheus grafana

# View logs
docker-compose logs -f prometheus
docker-compose logs -f grafana
```

### Health Checks

```bash
# Check Prometheus health
curl http://localhost:9090/-/healthy

# Check Grafana health
curl http://localhost:3001/api/health

# Check all service targets in Prometheus
curl http://localhost:9090/api/v1/targets
```

### Data Management

```bash
# View Prometheus data size
docker exec app-oint-prometheus du -sh /prometheus

# Backup Grafana data
docker cp app-oint-grafana:/var/lib/grafana ./grafana-backup

# Restore Grafana data
docker cp ./grafana-backup app-oint-grafana:/var/lib/grafana
docker-compose restart grafana
```

## 🔍 Monitoring Endpoints

### Service Health Endpoints

#### Functions Service (Node.js)
```bash
# Health check
curl http://localhost:8080/health

# Example response
{
  "status": "healthy",
  "timestamp": "2024-01-15T10:30:00.000Z",
  "service": "app-oint-functions",
  "version": "1.0.0",
  "uptime": 3600,
  "environment": "production",
  "dependencies": {
    "database": "healthy",
    "redis": "healthy",
    "firebase": "healthy"
  }
}
```

#### Dashboard Service (Next.js)
```bash
# Health check
curl http://localhost:3000/api/health

# Example response
{
  "status": "ok",
  "timestamp": "2024-01-15T10:30:00.000Z",
  "checks": {
    "database": "healthy",
    "api": "healthy"
  }
}
```

#### Business/Admin Services (Static)
```bash
# Health check
curl http://localhost:8081/health.html
curl http://localhost:8082/health.html

# Returns simple HTML page with health status
```

### Prometheus Metrics

```bash
# Query service availability
curl 'http://localhost:9090/api/v1/query?query=up'

# Query response time
curl 'http://localhost:9090/api/v1/query?query=http_request_duration_seconds'

# Query error rate
curl 'http://localhost:9090/api/v1/query?query=rate(http_requests_total{status=~"5.."}[5m])'
```

## 📋 Dashboard Configuration

### Accessing Grafana

1. Open http://localhost:3001
2. Login with admin/admin (or configured credentials)
3. Navigate to Dashboards → App-Oint System Overview

### Creating Custom Dashboards

1. **Add New Dashboard**
   - Click "+" → Dashboard
   - Add panels for specific metrics

2. **Common Queries**
   ```promql
   # Service uptime
   up{job="functions"}
   
   # Response time percentiles
   histogram_quantile(0.95, rate(REDACTED_TOKEN[5m]))
   
   # Error rate
   rate(http_requests_total{status=~"5.."}[5m]) / rate(http_requests_total[5m])
   
   # Request rate
   rate(http_requests_total[5m])
   ```

3. **Panel Types**
   - Time series: For metrics over time
   - Stat: For single values
   - Gauge: For percentages
   - Table: For detailed data

### Dashboard Import/Export

```bash
# Export dashboard
curl -H "Authorization: Bearer YOUR_API_KEY" \
     http://localhost:3001/api/dashboards/db/app-oint-overview

# Import dashboard
curl -X POST \
     -H "Content-Type: application/json" \
     -H "Authorization: Bearer YOUR_API_KEY" \
     -d @dashboard.json \
     http://localhost:3001/api/dashboards/db
```

## 🚨 Alerting

### Prometheus Rules (Future Enhancement)

Create `alert_rules.yml`:

```yaml
groups:
  - name: app-oint-alerts
    rules:
      - alert: ServiceDown
        expr: up == 0
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "Service {{ $labels.job }} is down"
          
      - alert: HighErrorRate
        expr: rate(http_requests_total{status=~"5.."}[5m]) > 0.1
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High error rate on {{ $labels.job }}"
```

### Grafana Alerting

1. Navigate to Alerting → Alert Rules
2. Create new rule with conditions
3. Configure notification channels (email, Slack, etc.)

## 🔧 Troubleshooting

### Common Issues

#### Prometheus Can't Scrape Services
```bash
# Check service connectivity
docker exec app-oint-prometheus wget -q --spider http://functions:8080/health

# Check Prometheus targets
curl http://localhost:9090/api/v1/targets | jq '.data.activeTargets'

# Verify network connectivity
docker network inspect app-oint_app-oint-network
```

#### Grafana Can't Connect to Prometheus
```bash
# Check Grafana logs
docker-compose logs grafana

# Test Prometheus connection from Grafana container
docker exec app-oint-grafana curl http://prometheus:9090/api/v1/status/config

# Verify data source configuration
curl -u admin:admin http://localhost:3001/api/datasources
```

#### Missing Metrics
```bash
# Check Prometheus config
curl http://localhost:9090/api/v1/status/config

# Reload Prometheus config
curl -X POST http://localhost:9090/-/reload

# Check metric availability
curl http://localhost:9090/api/v1/label/__name__/values
```

### Performance Tuning

#### Prometheus Optimization
- Adjust scrape intervals based on needs
- Configure metric retention policies
- Use recording rules for complex queries

#### Grafana Optimization
- Enable query caching
- Optimize dashboard queries
- Use appropriate time ranges

## 📚 Additional Resources

### Documentation
- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Documentation](https://grafana.com/docs/)
- [PromQL Query Language](https://prometheus.io/docs/prometheus/latest/querying/)

### Monitoring Best Practices
- [Four Golden Signals](https://sre.google/sre-book/monitoring-distributed-systems/)
- [USE Method](http://www.brendangregg.com/usemethod.html)
- [RED Method](https://grafana.com/blog/2018/08/02/REDACTED_TOKEN/)

### Sample Queries
```promql
# CPU usage
rate(cpu_seconds_total[5m])

# Memory usage
memory_usage_bytes / memory_limit_bytes

# Request latency
histogram_quantile(0.95, sum(rate(REDACTED_TOKEN[5m])) by (le))

# Error rate
sum(rate(http_requests_total{status=~"5.."}[5m])) by (service)
```

## 🆘 Support

For monitoring-related issues:

1. Check service health endpoints
2. Verify Prometheus targets: http://localhost:9090/targets
3. Check Grafana data source: http://localhost:3001/datasources
4. Review Docker logs: `docker-compose logs prometheus grafana`
5. Validate network connectivity between containers

For custom dashboard creation or advanced monitoring setup, refer to the Grafana and Prometheus documentation or contact the development team.