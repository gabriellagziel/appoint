#!/bin/bash

# ========================================
# App-Oint Enterprise API - Monitoring Setup Script
# ========================================

set -e  # Exit on any error

echo "🔍 Setting up monitoring for App-Oint Enterprise API..."

# ========================================
# Configuration
# ========================================

DOMAIN="api.app-oint.com"
ALERT_EMAIL="alerts@appoint.com"
SENTRY_PROJECT="appoint-enterprise-api"

# ========================================
# 1. Sentry Error Tracking
# ========================================

echo "📊 Setting up Sentry error tracking..."

# Check if Sentry CLI is installed
if ! command -v sentry-cli &> /dev/null; then
    echo "📦 Installing Sentry CLI..."
    curl -sL https://sentry.io/get-cli/ | bash
fi

# Initialize Sentry project
if [ ! -f ".sentryclirc" ]; then
    echo "🔧 Initializing Sentry project..."
    sentry-cli init --org appoint --project ${SENTRY_PROJECT}
fi

echo "✅ Sentry configured"

# ========================================
# 2. Uptime Monitoring (UptimeRobot)
# ========================================

echo "⏰ Setting up uptime monitoring..."

# Create uptime monitoring configuration
cat > uptime-monitoring.json << EOF
{
  "monitors": [
    {
      "name": "App-Oint Enterprise API - Health Check",
      "url": "https://${DOMAIN}/api/status",
      "type": "http",
      "interval": 60,
      "timeout": 30,
      "alert_contacts": ["${ALERT_EMAIL}"],
      "alert_conditions": {
        "response_time": 5000,
        "status_code": 200
      }
    },
    {
      "name": "App-Oint Enterprise API - Registration",
      "url": "https://${DOMAIN}/register-business.html",
      "type": "http",
      "interval": 300,
      "timeout": 30,
      "alert_contacts": ["${ALERT_EMAIL}"],
      "alert_conditions": {
        "response_time": 10000,
        "status_code": 200
      }
    },
    {
      "name": "App-Oint Enterprise API - Dashboard",
      "url": "https://${DOMAIN}/dashboard.html",
      "type": "http",
      "interval": 300,
      "timeout": 30,
      "alert_contacts": ["${ALERT_EMAIL}"],
      "alert_conditions": {
        "response_time": 10000,
        "status_code": 200
      }
    }
  ]
}
EOF

echo "✅ Uptime monitoring configuration created"

# ========================================
# 3. Google Analytics Setup
# ========================================

echo "📈 Setting up Google Analytics..."

# Create analytics configuration
cat > analytics-setup.md << EOF
# Google Analytics Setup for App-Oint Enterprise API

## Steps to complete:

1. Create a new Google Analytics 4 property
2. Set up data streams for:
   - https://${DOMAIN} (Web)
   - Mobile app (if applicable)

3. Configure events to track:
   - Page views
   - Registration form submissions
   - API key generation
   - Dashboard usage
   - Error events

4. Set up goals:
   - Registration completion
   - API key generation
   - Dashboard login

5. Configure custom dimensions:
   - User type (Enterprise, Business, etc.)
   - Plan type
   - Registration source

## Implementation:

Add the following to your HTML pages:

\`\`\`html
<!-- Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=GA_MEASUREMENT_ID"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'GA_MEASUREMENT_ID');
</script>
\`\`\`

Replace GA_MEASUREMENT_ID with your actual Google Analytics Measurement ID.
EOF

echo "✅ Google Analytics setup guide created"

# ========================================
# 4. Log Aggregation Setup
# ========================================

echo "📝 Setting up log aggregation..."

# Create log configuration
cat > log-config.json << EOF
{
  "logging": {
    "level": "info",
    "format": "json",
    "destinations": [
      {
        "type": "console",
        "enabled": true
      },
      {
        "type": "file",
        "enabled": true,
        "path": "./logs/app.log",
        "max_size": "10MB",
        "max_files": 5
      },
      {
        "type": "firebase",
        "enabled": true,
        "collection": "application_logs"
      }
    ]
  },
  "monitoring": {
    "metrics": [
      "request_count",
      "response_time",
      "error_rate",
      "api_usage",
      "registration_count"
    ],
    "alerts": {
      "high_error_rate": {
        "threshold": 5,
        "window": "5m"
      },
      "high_response_time": {
        "threshold": 2000,
        "window": "5m"
      },
      "low_uptime": {
        "threshold": 99.5,
        "window": "1h"
      }
    }
  }
}
EOF

echo "✅ Log configuration created"

# ========================================
# 5. Performance Monitoring
# ========================================

echo "⚡ Setting up performance monitoring..."

# Create performance monitoring script
cat > performance-monitor.js << 'EOF'
const admin = require('firebase-admin');
const os = require('os');

// Performance monitoring middleware
function performanceMonitor(req, res, next) {
  const start = Date.now();
  
  // Capture request details
  const requestData = {
    method: req.method,
    url: req.url,
    userAgent: req.get('User-Agent'),
    ip: req.ip,
    timestamp: new Date(),
    memoryUsage: process.memoryUsage(),
    cpuUsage: process.cpuUsage(),
    loadAverage: os.loadavg()
  };

  // Override res.end to capture response data
  const originalEnd = res.end;
  res.end = function(chunk, encoding) {
    const duration = Date.now() - start;
    
    const responseData = {
      ...requestData,
      statusCode: res.statusCode,
      duration,
      contentLength: res.get('Content-Length') || 0
    };

    // Log to Firestore
    admin.firestore().collection('performance_logs').add(responseData);
    
    // Send alert if response time is too high
    if (duration > 5000) {
      admin.firestore().collection('alerts').add({
        type: 'high_response_time',
        data: responseData,
        timestamp: new Date()
      });
    }

    originalEnd.call(this, chunk, encoding);
  };

  next();
}

module.exports = { performanceMonitor };
EOF

echo "✅ Performance monitoring script created"

# ========================================
# 6. Alert Configuration
# ========================================

echo "🚨 Setting up alert configuration..."

# Create alert configuration
cat > alert-config.json << EOF
{
  "alerts": {
    "email": {
      "enabled": true,
      "recipients": ["${ALERT_EMAIL}"],
      "smtp": {
        "host": "smtp.gmail.com",
        "port": 587,
        "secure": false,
        "auth": {
          "user": "alerts@appoint.com",
          "pass": "your_app_password"
        }
      }
    },
    "webhook": {
      "enabled": true,
      "url": "https://hooks.slack.com/services/YOUR_SLACK_WEBHOOK",
      "events": ["error", "high_response_time", "low_uptime"]
    },
    "rules": [
      {
        "name": "High Error Rate",
        "condition": "error_rate > 5%",
        "window": "5m",
        "actions": ["email", "webhook"]
      },
      {
        "name": "High Response Time",
        "condition": "avg_response_time > 2000ms",
        "window": "5m",
        "actions": ["email"]
      },
      {
        "name": "Low Uptime",
        "condition": "uptime < 99.5%",
        "window": "1h",
        "actions": ["email", "webhook"]
      },
      {
        "name": "Registration Spike",
        "condition": "registration_count > 10",
        "window": "1h",
        "actions": ["email"]
      }
    ]
  }
}
EOF

echo "✅ Alert configuration created"

# ========================================
# 7. Health Check Endpoints
# ========================================

echo "🏥 Setting up health check endpoints..."

# Create health check configuration
cat > health-checks.json << EOF
{
  "health_checks": [
    {
      "name": "api_status",
      "endpoint": "/api/status",
      "expected_status": 200,
      "timeout": 5000
    },
    {
      "name": "firebase_connection",
      "endpoint": "/api/health/firebase",
      "expected_status": 200,
      "timeout": 10000
    },
    {
      "name": "email_service",
      "endpoint": "/api/health/email",
      "expected_status": 200,
      "timeout": 5000
    },
    {
      "name": "database_connection",
      "endpoint": "/api/health/database",
      "expected_status": 200,
      "timeout": 5000
    }
  ],
  "monitoring": {
    "interval": 300000,
    "retries": 3,
    "alert_threshold": 2
  }
}
EOF

echo "✅ Health check configuration created"

# ========================================
# 8. Dashboard Setup
# ========================================

echo "📊 Setting up monitoring dashboard..."

# Create dashboard configuration
cat > monitoring-dashboard.md << EOF
# App-Oint Enterprise API - Monitoring Dashboard

## Key Metrics to Monitor:

### 1. Performance Metrics
- Response time (avg, p95, p99)
- Request rate (requests per minute)
- Error rate (percentage)
- Uptime percentage

### 2. Business Metrics
- Registration count
- API key generation
- Dashboard logins
- Email delivery success rate

### 3. Infrastructure Metrics
- CPU usage
- Memory usage
- Disk usage
- Network I/O

### 4. Security Metrics
- Failed authentication attempts
- Rate limit violations
- Suspicious IP addresses
- API key usage patterns

## Dashboard URLs:

- **Sentry**: https://sentry.io/organizations/appoint/projects/${SENTRY_PROJECT}/
- **Google Analytics**: https://analytics.google.com/
- **UptimeRobot**: https://uptimerobot.com/dashboard
- **Custom Dashboard**: https://${DOMAIN}/admin/monitoring

## Alert Channels:

- **Email**: ${ALERT_EMAIL}
- **Slack**: #appoint-alerts
- **SMS**: +1-555-0123 (critical alerts only)

## Response Procedures:

1. **High Error Rate**: Check logs, restart service if needed
2. **High Response Time**: Scale up resources, optimize queries
3. **Low Uptime**: Check server status, restart if necessary
4. **Security Alerts**: Review logs, block suspicious IPs
EOF

echo "✅ Monitoring dashboard guide created"

# ========================================
# Final Setup Instructions
# ========================================

echo ""
echo "🎉 Monitoring setup completed!"
echo ""
echo "📋 Next Steps:"
echo ""
echo "1. 🔧 Configure Sentry:"
echo "   - Update .sentryclirc with your project details"
echo "   - Add Sentry SDK to your application"
echo ""
echo "2. ⏰ Set up UptimeRobot:"
echo "   - Import uptime-monitoring.json"
echo "   - Configure alert contacts"
echo ""
echo "3. 📈 Set up Google Analytics:"
echo "   - Follow analytics-setup.md"
echo "   - Add tracking code to your pages"
echo ""
echo "4. 📝 Configure Logging:"
echo "   - Update log-config.json with your preferences"
echo "   - Set up log rotation"
echo ""
echo "5. 🚨 Set up Alerts:"
echo "   - Configure alert-config.json"
echo "   - Test alert delivery"
echo ""
echo "6. 🏥 Test Health Checks:"
echo "   - Verify all health check endpoints"
echo "   - Set up automated testing"
echo ""
echo "7. 📊 Create Dashboard:"
echo "   - Set up monitoring dashboard"
echo "   - Configure key metrics"
echo ""
echo "✅ Monitoring is ready to go live!" 