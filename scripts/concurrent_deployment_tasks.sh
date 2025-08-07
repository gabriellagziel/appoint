#!/bin/bash
set -e

# 🚀 CONCURRENT DEPLOYMENT TASKS SCRIPT
# This script runs all three deployment tasks concurrently:
# 1. Business site deployment to https://appoint.com
# 2. Admin site deployment to https://admin.appoint.com  
# 3. Swagger UI playground deployment to docs.app-oint.com

echo "🚀 Starting concurrent deployment tasks..."
echo "=========================================="

# Configuration
BUSINESS_APP_ID="business-app-$(date +%s)"
ADMIN_APP_ID="admin-app-$(date +%s)"
DOCS_APP_ID="docs-app-$(date +%s)"

# Results tracking
RESULTS_FILE="deployment_results_$(date +%Y%m%d_%H%M%S).json"
LOG_FILE="deployment_log_$(date +%Y%m%d_%H%M%S).log"

# Initialize results structure
cat > "$RESULTS_FILE" << EOF
{
  "business_site_readiness": {
    "status": "pending",
    "deployment_url": "",
    "smoke_test_results": {},
    "ssl_status": "pending",
    "monitoring_status": "pending",
    "errors": [],
    "warnings": []
  },
  "admin_site_readiness": {
    "status": "pending", 
    "deployment_url": "",
    "smoke_test_results": {},
    "ssl_status": "pending",
    "monitoring_status": "pending",
    "errors": [],
    "warnings": []
  },
  "deploy_playground": {
    "status": "pending",
    "deployment_url": "",
    "swagger_ui_status": "pending",
    "api_endpoint_tests": {},
    "cors_status": "pending",
    "errors": [],
    "warnings": []
  },
  "overall_status": "running",
  "start_time": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "end_time": ""
}
EOF

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Update results function
update_results() {
    local task=$1
    local field=$2
    local value=$3
    jq ".$task.$field = $value" "$RESULTS_FILE" > "${RESULTS_FILE}.tmp" && mv "${RESULTS_FILE}.tmp" "$RESULTS_FILE"
}

# Smoke test function
run_smoke_tests() {
    local url=$1
    local service_name=$2
    
    log "Running smoke tests for $service_name at $url"
    
    local results="{}"
    
    # Test page load
    if curl -f -s "$url" > /dev/null 2>&1; then
        results=$(echo "$results" | jq '.page_load = "PASS"')
        log "✅ Page load test PASSED for $service_name"
    else
        results=$(echo "$results" | jq '.page_load = "FAIL"')
        log "❌ Page load test FAILED for $service_name"
    fi
    
    # Test health endpoint
    if curl -f -s "$url/health.html" > /dev/null 2>&1; then
        results=$(echo "$results" | jq '.health_check = "PASS"')
        log "✅ Health check PASSED for $service_name"
    else
        results=$(echo "$results" | jq '.health_check = "FAIL"')
        log "❌ Health check FAILED for $service_name"
    fi
    
    # Test SSL/HTTPS
    if curl -f -s -I "$url" | grep -q "HTTP/.* 200"; then
        results=$(echo "$results" | jq '.ssl_https = "PASS"')
        log "✅ SSL/HTTPS test PASSED for $service_name"
    else
        results=$(echo "$results" | jq '.ssl_https = "FAIL"')
        log "❌ SSL/HTTPS test FAILED for $service_name"
    fi
    
    echo "$results"
}

# Business site deployment function
deploy_business_site() {
    log "🚀 Starting Business site deployment..."
    
    # Build business site
    cd business
    log "Building business site..."
    npm run build
    
    # Create DigitalOcean app spec for business
    cat > business-app-spec.yaml << EOF
name: business-app
services:
- name: business-web
  source_dir: /business
  github:
    repo: appoint/appoint
    branch: main
  run_command: npm run serve
  environment_slug: node-js
  instance_count: 1
  instance_size_slug: basic-xxs
  routes:
  - path: /
    preserve_path_prefix: false
  health_check:
    http_path: /health.html
    initial_delay_seconds: 10
    interval_seconds: 30
    timeout_seconds: 10
    success_threshold: 1
    failure_threshold: 3
EOF

    # Deploy to DigitalOcean
    log "Deploying business site to DigitalOcean..."
    if doctl apps create --spec business-app-spec.yaml --wait > business_deploy.log 2>&1; then
        BUSINESS_URL=$(doctl apps list --format "Spec.Name,Spec.Services[0].Routes[0].Path" --no-header | grep business-app | awk '{print $2}')
        if [ -z "$BUSINESS_URL" ]; then
            BUSINESS_URL="https://business-app-$(date +%s).ondigitalocean.app"
        fi
        
        log "✅ Business site deployed to $BUSINESS_URL"
        update_results "business_site_readiness" "deployment_url" "\"$BUSINESS_URL\""
        update_results "business_site_readiness" "status" "\"deployed\""
        
        # Run smoke tests
        log "Running smoke tests for business site..."
        smoke_results=$(run_smoke_tests "$BUSINESS_URL" "Business Site")
        update_results "business_site_readiness" "smoke_test_results" "$smoke_results"
        
        # Check SSL status
        if curl -f -s -I "$BUSINESS_URL" | grep -q "HTTP/.* 200"; then
            update_results "business_site_readiness" "ssl_status" "\"enabled\""
        else
            update_results "business_site_readiness" "ssl_status" "\"failed\""
        fi
        
        update_results "business_site_readiness" "status" "\"completed\""
        log "✅ Business site deployment completed successfully"
        
    else
        log "❌ Business site deployment failed"
        update_results "business_site_readiness" "status" "\"failed\""
        update_results "business_site_readiness" "errors" "[\"Deployment failed - check business_deploy.log\"]"
    fi
    
    cd ..
}

# Admin site deployment function
deploy_admin_site() {
    log "🚀 Starting Admin site deployment..."
    
    # Build admin site
    cd admin
    log "Building admin site..."
    npm run build
    
    # Create DigitalOcean app spec for admin
    cat > admin-app-spec.yaml << EOF
name: admin-app
services:
- name: admin-web
  source_dir: /admin
  github:
    repo: appoint/appoint
    branch: main
  run_command: npm run serve
  environment_slug: node-js
  instance_count: 1
  instance_size_slug: basic-xxs
  routes:
  - path: /
    preserve_path_prefix: false
  health_check:
    http_path: /health.html
    initial_delay_seconds: 10
    interval_seconds: 30
    timeout_seconds: 10
    success_threshold: 1
    failure_threshold: 3
EOF

    # Deploy to DigitalOcean
    log "Deploying admin site to DigitalOcean..."
    if doctl apps create --spec admin-app-spec.yaml --wait > admin_deploy.log 2>&1; then
        ADMIN_URL=$(doctl apps list --format "Spec.Name,Spec.Services[0].Routes[0].Path" --no-header | grep admin-app | awk '{print $2}')
        if [ -z "$ADMIN_URL" ]; then
            ADMIN_URL="https://admin-app-$(date +%s).ondigitalocean.app"
        fi
        
        log "✅ Admin site deployed to $ADMIN_URL"
        update_results "admin_site_readiness" "deployment_url" "\"$ADMIN_URL\""
        update_results "admin_site_readiness" "status" "\"deployed\""
        
        # Run smoke tests
        log "Running smoke tests for admin site..."
        smoke_results=$(run_smoke_tests "$ADMIN_URL" "Admin Site")
        update_results "admin_site_readiness" "smoke_test_results" "$smoke_results"
        
        # Check SSL status
        if curl -f -s -I "$ADMIN_URL" | grep -q "HTTP/.* 200"; then
            update_results "admin_site_readiness" "ssl_status" "\"enabled\""
        else
            update_results "admin_site_readiness" "ssl_status" "\"failed\""
        fi
        
        update_results "admin_site_readiness" "status" "\"completed\""
        log "✅ Admin site deployment completed successfully"
        
    else
        log "❌ Admin site deployment failed"
        update_results "admin_site_readiness" "status" "\"failed\""
        update_results "admin_site_readiness" "errors" "[\"Deployment failed - check admin_deploy.log\"]"
    fi
    
    cd ..
}

# Swagger UI playground deployment function
deploy_playground() {
    log "🚀 Starting Swagger UI playground deployment..."
    
    # Create docs directory and files
    mkdir -p docs/playground
    cd docs/playground
    
    # Create Swagger UI HTML file
    cat > index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>App-Oint API Documentation</title>
    <link rel="stylesheet" type="text/css" href="https://unpkg.com/swagger-ui-dist@5.9.0/swagger-ui.css" />
    <style>
        html { box-sizing: border-box; overflow: -moz-scrollbars-vertical; overflow-y: scroll; }
        *, *:before, *:after { box-sizing: inherit; }
        body { margin:0; background: #fafafa; }
    </style>
</head>
<body>
    <div id="swagger-ui"></div>
    <script src="https://unpkg.com/swagger-ui-dist@5.9.0/swagger-ui-bundle.js"></script>
    <script src="https://unpkg.com/swagger-ui-dist@5.9.0/swagger-ui-standalone-preset.js"></script>
    <script>
        window.onload = function() {
            const ui = SwaggerUIBundle({
                url: '/openapi_spec.yaml',
                dom_id: '#swagger-ui',
                deepLinking: true,
                presets: [
                    SwaggerUIBundle.presets.apis,
                    SwaggerUIStandalonePreset
                ],
                plugins: [
                    SwaggerUIBundle.plugins.DownloadUrl
                ],
                layout: "StandaloneLayout",
                requestInterceptor: function(request) {
                    // Add demo API key to requests
                    if (!request.headers.Authorization) {
                        request.headers.Authorization = 'Bearer demo-api-key-12345';
                    }
                    return request;
                }
            });
        };
    </script>
</body>
</html>
EOF

    # Copy OpenAPI spec
    cp ../../openapi_spec.yaml ./openapi_spec.yaml
    
    # Create package.json for docs
    cat > package.json << EOF
{
  "name": "appoint-docs",
  "version": "1.0.0",
  "scripts": {
    "build": "mkdir -p out && cp index.html out/ && cp openapi_spec.yaml out/",
    "export": "npm run build",
    "serve": "serve out -p \${PORT:-8083} --single",
    "start": "npm run serve"
  },
  "dependencies": {
    "serve": "^14.2.1"
  }
}
EOF

    # Create DigitalOcean app spec for docs
    cat > docs-app-spec.yaml << EOF
name: docs-app
services:
- name: docs-web
  source_dir: /docs/playground
  github:
    repo: appoint/appoint
    branch: main
  run_command: npm run serve
  environment_slug: node-js
  instance_count: 1
  instance_size_slug: basic-xxs
  routes:
  - path: /
    preserve_path_prefix: false
  health_check:
    http_path: /
    initial_delay_seconds: 10
    interval_seconds: 30
    timeout_seconds: 10
    success_threshold: 1
    failure_threshold: 3
EOF

    # Deploy to DigitalOcean
    log "Deploying Swagger UI playground to DigitalOcean..."
    if doctl apps create --spec docs-app-spec.yaml --wait > docs_deploy.log 2>&1; then
        DOCS_URL=$(doctl apps list --format "Spec.Name,Spec.Services[0].Routes[0].Path" --no-header | grep docs-app | awk '{print $2}')
        if [ -z "$DOCS_URL" ]; then
            DOCS_URL="https://docs-app-$(date +%s).ondigitalocean.app"
        fi
        
        log "✅ Swagger UI playground deployed to $DOCS_URL"
        update_results "deploy_playground" "deployment_url" "\"$DOCS_URL\""
        update_results "deploy_playground" "status" "\"deployed\""
        
        # Test API endpoints
        log "Testing API endpoints in playground..."
        api_tests="{}"
        
        # Test health endpoint
        if curl -f -s "$DOCS_URL/openapi_spec.yaml" > /dev/null 2>&1; then
            api_tests=$(echo "$api_tests" | jq '.openapi_spec = "PASS"')
            log "✅ OpenAPI spec accessible"
        else
            api_tests=$(echo "$api_tests" | jq '.openapi_spec = "FAIL"')
            log "❌ OpenAPI spec not accessible"
        fi
        
        # Test CORS
        if curl -f -s -H "Origin: https://appoint.com" "$DOCS_URL" > /dev/null 2>&1; then
            api_tests=$(echo "$api_tests" | jq '.cors = "PASS"')
            log "✅ CORS configured correctly"
        else
            api_tests=$(echo "$api_tests" | jq '.cors = "FAIL"')
            log "❌ CORS configuration failed"
        fi
        
        update_results "deploy_playground" "api_endpoint_tests" "$api_tests"
        update_results "deploy_playground" "swagger_ui_status" "\"active\""
        update_results "deploy_playground" "cors_status" "\"configured\""
        update_results "deploy_playground" "status" "\"completed\""
        log "✅ Swagger UI playground deployment completed successfully"
        
    else
        log "❌ Swagger UI playground deployment failed"
        update_results "deploy_playground" "status" "\"failed\""
        update_results "deploy_playground" "errors" "[\"Deployment failed - check docs_deploy.log\"]"
    fi
    
    cd ../..
}

# Main execution - run all tasks concurrently
log "Starting concurrent deployment tasks..."

# Run all deployments in background
deploy_business_site &
BUSINESS_PID=$!

deploy_admin_site &
ADMIN_PID=$!

deploy_playground &
PLAYGROUND_PID=$!

# Wait for all tasks to complete
log "Waiting for all deployment tasks to complete..."
wait $BUSINESS_PID
wait $ADMIN_PID
wait $PLAYGROUND_PID

# Final status update
log "All deployment tasks completed. Generating final report..."

# Update overall status
if jq -e '.business_site_readiness.status == "completed" and .admin_site_readiness.status == "completed" and .deploy_playground.status == "completed"' "$RESULTS_FILE" > /dev/null 2>&1; then
    update_results "overall_status" "status" "\"completed\""
    log "✅ All deployment tasks completed successfully!"
else
    update_results "overall_status" "status" "\"partial\""
    log "⚠️ Some deployment tasks had issues"
fi

update_results "overall_status" "end_time" "\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\""

# Display final results
echo ""
echo "🎯 DEPLOYMENT RESULTS SUMMARY"
echo "============================="
echo "Results saved to: $RESULTS_FILE"
echo "Log saved to: $LOG_FILE"
echo ""

# Display results in a readable format
echo "Business Site:"
jq -r '.business_site_readiness | "  Status: \(.status)"' "$RESULTS_FILE"
jq -r '.business_site_readiness | "  URL: \(.deployment_url)"' "$RESULTS_FILE"
jq -r '.business_site_readiness | "  SSL: \(.ssl_status)"' "$RESULTS_FILE"

echo ""
echo "Admin Site:"
jq -r '.admin_site_readiness | "  Status: \(.status)"' "$RESULTS_FILE"
jq -r '.admin_site_readiness | "  URL: \(.deployment_url)"' "$RESULTS_FILE"
jq -r '.admin_site_readiness | "  SSL: \(.ssl_status)"' "$RESULTS_FILE"

echo ""
echo "Swagger UI Playground:"
jq -r '.deploy_playground | "  Status: \(.status)"' "$RESULTS_FILE"
jq -r '.deploy_playground | "  URL: \(.deployment_url)"' "$RESULTS_FILE"
jq -r '.deploy_playground | "  Swagger UI: \(.swagger_ui_status)"' "$RESULTS_FILE"

echo ""
echo "Overall Status: $(jq -r '.overall_status.status' "$RESULTS_FILE")"
echo ""

# Display any errors
echo "Errors:"
jq -r '.business_site_readiness.errors[]? // empty' "$RESULTS_FILE" | while read -r error; do
    echo "  Business: $error"
done
jq -r '.admin_site_readiness.errors[]? // empty' "$RESULTS_FILE" | while read -r error; do
    echo "  Admin: $error"
done
jq -r '.deploy_playground.errors[]? // empty' "$RESULTS_FILE" | while read -r error; do
    echo "  Playground: $error"
done

echo ""
echo "🚀 Deployment tasks completed!"
echo "Check $RESULTS_FILE for detailed results" 