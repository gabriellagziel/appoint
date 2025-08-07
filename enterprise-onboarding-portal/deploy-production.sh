#!/bin/bash

# ========================================
# App-Oint Enterprise API - Production Deployment Script
# ========================================

set -e  # Exit on any error

echo "🚀 Starting App-Oint Enterprise API Production Deployment..."

# ========================================
# Configuration
# ========================================

APP_NAME="appoint-enterprise-api"
REGION="nyc"
SIZE="s-1vcpu-1gb"
DOMAIN="api.app-oint.com"

# ========================================
# Pre-deployment Checks
# ========================================

echo "📋 Running pre-deployment checks..."

# Check if doctl is installed
if ! command -v doctl &> /dev/null; then
    echo "❌ doctl CLI is not installed. Please install it first:"
    echo "   https://docs.digitalocean.com/reference/doctl/how-to/install/"
    exit 1
fi

# Check if logged in to DigitalOcean
if ! doctl account get &> /dev/null; then
    echo "❌ Not logged in to DigitalOcean. Please run:"
    echo "   doctl auth init"
    exit 1
fi

# Check if production environment file exists
if [ ! -f ".env.production" ]; then
    echo "❌ Production environment file not found."
    echo "   Please copy env.production.template to .env.production and configure it."
    exit 1
fi

# Check if Firebase service account is configured
if ! grep -q "FIREBASE_SERVICE_ACCOUNT=" .env.production; then
    echo "❌ Firebase service account not configured in .env.production"
    exit 1
fi

# Check if email credentials are configured
if ! grep -q "EMAIL_PASS=" .env.production; then
    echo "❌ Email password not configured in .env.production"
    exit 1
fi

echo "✅ Pre-deployment checks passed"

# ========================================
# Build and Test
# ========================================

echo "🔨 Building application..."

# Install dependencies
npm install

# Run tests
echo "🧪 Running tests..."
npm test

# Build for production
echo "📦 Building for production..."
npm run build

echo "✅ Build completed successfully"

# ========================================
# Create DigitalOcean App Spec
# ========================================

echo "📝 Creating DigitalOcean App Platform specification..."

cat > enterprise-app-spec.yaml << EOF
name: ${APP_NAME}
region: ${REGION}
services:
- name: enterprise-api
  source_dir: .
  github:
    repo: appoint/enterprise-api
    branch: main
  run_command: npm start
  environment_slug: node-js
  instance_count: 1
  instance_size_slug: ${SIZE}
  envs:
  - key: NODE_ENV
    value: production
  - key: PORT
    value: "3000"
  - key: FIREBASE_SERVICE_ACCOUNT
    value: \${FIREBASE_SERVICE_ACCOUNT}
  - key: FIREBASE_DATABASE_URL
    value: \${FIREBASE_DATABASE_URL}
  - key: EMAIL_USER
    value: \${EMAIL_USER}
  - key: EMAIL_PASS
    value: \${EMAIL_PASS}
  - key: JWT_SECRET
    value: \${JWT_SECRET}
  - key: COMPANY_NAME
    value: \${COMPANY_NAME}
  - key: COMPANY_IBAN
    value: \${COMPANY_IBAN}
  - key: COMPANY_SWIFT
    value: \${COMPANY_SWIFT}
  - key: COMPANY_ADDRESS
    value: \${COMPANY_ADDRESS}
  - key: COMPANY_EMAIL
    value: \${COMPANY_EMAIL}
  - key: RATE_LIMIT_WINDOW_MS
    value: \${RATE_LIMIT_WINDOW_MS}
  - key: RATE_LIMIT_MAX_REQUESTS
    value: \${RATE_LIMIT_MAX_REQUESTS}
  - key: API_BASE_URL
    value: https://${DOMAIN}
  - key: DASHBOARD_URL
    value: https://${DOMAIN}/dashboard
  - key: DOCS_URL
    value: \${DOCS_URL}
  - key: SENTRY_DSN
    value: \${SENTRY_DSN}
  - key: GOOGLE_ANALYTICS_ID
    value: \${GOOGLE_ANALYTICS_ID}
  - key: CORS_ORIGIN
    value: https://${DOMAIN}
  - key: SECURE_COOKIES
    value: \${SECURE_COOKIES}
  - key: SESSION_SECRET
    value: \${SESSION_SECRET}
  - key: FIRESTORE_PROJECT_ID
    value: \${FIRESTORE_PROJECT_ID}
  - key: LOG_LEVEL
    value: \${LOG_LEVEL}
  - key: LOG_FORMAT
    value: \${LOG_FORMAT}
  - key: COMPRESSION_ENABLED
    value: \${COMPRESSION_ENABLED}
  - key: CACHE_CONTROL_MAX_AGE
    value: \${CACHE_CONTROL_MAX_AGE}
  - key: UPTIME_WEBHOOK_URL
    value: \${UPTIME_WEBHOOK_URL}
  - key: ALERT_EMAIL
    value: \${ALERT_EMAIL}
  - key: AUTO_APPROVE
    value: "false"
  routes:
  - path: /
    preserve_path_prefix: false
  health_check:
    http_path: /api/status
  cors:
    allow_origins:
    - https://${DOMAIN}
    - https://app-oint.com
    - https://www.app-oint.com
    allow_methods:
    - GET
    - POST
    - PUT
    - DELETE
    - OPTIONS
    allow_headers:
    - Authorization
    - Content-Type
    - X-API-Key
    - X-Requested-With
    max_age: "86400"
  alerts:
  - rule: DEPLOYMENT_FAILED
  - rule: DOMAIN_FAILED
  - rule: HIGH_CPU
    value: 80
  - rule: HIGH_MEMORY
    value: 80
  - rule: HIGH_DISK
    value: 80
  - rule: HIGH_HTTP_ERROR_RATE
    value: 5
  - rule: HIGH_HTTP_LATENCY
    value: 500
domains:
- domain: ${DOMAIN}
  type: PRIMARY
  certificate:
    type: LETS_ENCRYPT
EOF

echo "✅ App specification created"

# ========================================
# Deploy to DigitalOcean
# ========================================

echo "🚀 Deploying to DigitalOcean App Platform..."

# Check if app already exists
if doctl apps list --format Name | grep -q "^${APP_NAME}$"; then
    echo "📝 Updating existing app..."
    doctl apps update $(doctl apps list --format ID,Name | grep "${APP_NAME}" | awk '{print $1}') --spec enterprise-app-spec.yaml
else
    echo "🆕 Creating new app..."
    doctl apps create --spec enterprise-app-spec.yaml
fi

# Get app ID
APP_ID=$(doctl apps list --format ID,Name | grep "${APP_NAME}" | awk '{print $1}')

echo "✅ App deployed successfully! App ID: ${APP_ID}"

# ========================================
# Wait for Deployment
# ========================================

echo "⏳ Waiting for deployment to complete..."

# Wait for deployment to be ready
doctl apps wait-deployment ${APP_ID}

echo "✅ Deployment completed!"

# ========================================
# Health Check
# ========================================

echo "🏥 Running health checks..."

# Get the app URL
APP_URL=$(doctl apps get ${APP_ID} --format URL --no-header)

echo "🔍 Testing endpoints..."

# Test health endpoint
echo "Testing health endpoint..."
curl -f "${APP_URL}/api/status" || {
    echo "❌ Health check failed"
    exit 1
}

# Test registration endpoint
echo "Testing registration endpoint..."
curl -f -X POST "${APP_URL}/registerBusiness" \
  -H "Content-Type: application/json" \
  -d '{"companyName":"Test Corp","website":"https://test.com","address":"Test Address","country":"United States","currency":"USD","billingEmail":"test@test.com","firstName":"Test","lastName":"User","email":"test@test.com","intent":"Testing","tos":true}' || {
    echo "❌ Registration endpoint failed"
    exit 1
}

echo "✅ All health checks passed!"

# ========================================
# Domain Configuration
# ========================================

echo "🌐 Configuring domain..."

# Check if domain is already configured
if ! doctl apps list-domains ${APP_ID} --format Domain | grep -q "^${DOMAIN}$"; then
    echo "Adding domain ${DOMAIN}..."
    doctl apps create-domain ${APP_ID} ${DOMAIN}
else
    echo "Domain ${DOMAIN} already configured"
fi

echo "✅ Domain configuration completed"

# ========================================
# Final Status
# ========================================

echo ""
echo "🎉 Deployment completed successfully!"
echo ""
echo "📊 App Details:"
echo "   Name: ${APP_NAME}"
echo "   ID: ${APP_ID}"
echo "   URL: ${APP_URL}"
echo "   Domain: https://${DOMAIN}"
echo ""
echo "🔗 Quick Links:"
echo "   Dashboard: https://${DOMAIN}/dashboard"
echo "   API Status: https://${DOMAIN}/api/status"
echo "   Documentation: https://docs.app-oint.com"
echo ""
echo "📋 Next Steps:"
echo "   1. Configure DNS for ${DOMAIN}"
echo "   2. Set up monitoring and alerts"
echo "   3. Test all functionality"
echo "   4. Update documentation"
echo ""
echo "✅ App-Oint Enterprise API is now live!" 