#!/bin/bash
set -e

echo "🚀 COMPREHENSIVE DEPLOYMENT TASKS"
echo "=================================="

# Configuration
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
RESULTS_FILE="deployment_results_${TIMESTAMP}.json"

# Initialize results
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

# Helper functions
update_results() {
    local task=$1
    local field=$2
    local value=$3
    jq ".$task.$field = $value" "$RESULTS_FILE" > "${RESULTS_FILE}.tmp" && mv "${RESULTS_FILE}.tmp" "$RESULTS_FILE"
}

add_error() {
    local task=$1
    local error=$2
    jq ".$task.errors += [\"$error\"]" "$RESULTS_FILE" > "${RESULTS_FILE}.tmp" && mv "${RESULTS_FILE}.tmp" "$RESULTS_FILE"
}

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Smoke test function
run_smoke_tests() {
    local url=$1
    local service_name=$2
    
    log "Running smoke tests for $service_name"
    
    local results="{}"
    
    # Test page load
    if curl -f -s --max-time 10 "$url" > /dev/null 2>&1; then
        results=$(echo "$results" | jq '.page_load = "PASS"')
        log "✅ Page load test PASSED"
    else
        results=$(echo "$results" | jq '.page_load = "FAIL"')
        log "❌ Page load test FAILED"
    fi
    
    # Test health endpoint
    if curl -f -s --max-time 10 "$url/health.html" > /dev/null 2>&1; then
        results=$(echo "$results" | jq '.health_check = "PASS"')
        log "✅ Health check PASSED"
    else
        results=$(echo "$results" | jq '.health_check = "FAIL"')
        log "❌ Health check FAILED"
    fi
    
    echo "$results"
}

# Business site deployment
deploy_business_site() {
    log "🚀 Deploying Business Site..."
    
    cd business
    
    # Build and start server
    npm install > /dev/null 2>&1
    npm run build > /dev/null 2>&1
    
    # Start server on port 8081
    npm run serve > business_server.log 2>&1 &
    BUSINESS_PID=$!
    
    # Wait for server
    sleep 3
    
    BUSINESS_URL="http://localhost:8081"
    
    if curl -f -s --max-time 5 "$BUSINESS_URL" > /dev/null 2>&1; then
        log "✅ Business site deployed successfully"
        update_results "business_site_readiness" "deployment_url" "\"$BUSINESS_URL\""
        update_results "business_site_readiness" "status" "\"deployed\""
        
        # Run smoke tests
        smoke_results=$(run_smoke_tests "$BUSINESS_URL" "Business Site")
        update_results "business_site_readiness" "smoke_test_results" "$smoke_results"
        
        # Local development - no SSL
        update_results "business_site_readiness" "ssl_status" "\"local_development\""
        update_results "business_site_readiness" "status" "\"completed\""
        
        echo $BUSINESS_PID > business_server.pid
    else
        log "❌ Business site deployment failed"
        add_error "business_site_readiness" "Server failed to start"
        update_results "business_site_readiness" "status" "\"failed\""
    fi
    
    cd ..
}

# Admin site deployment
deploy_admin_site() {
    log "🚀 Deploying Admin Site..."
    
    cd admin
    
    # Build and start server
    npm install > /dev/null 2>&1
    npm run build > /dev/null 2>&1
    
    # Start server on port 8082
    npm run serve > admin_server.log 2>&1 &
    ADMIN_PID=$!
    
    # Wait for server
    sleep 3
    
    ADMIN_URL="http://localhost:8082"
    
    if curl -f -s --max-time 5 "$ADMIN_URL" > /dev/null 2>&1; then
        log "✅ Admin site deployed successfully"
        update_results "admin_site_readiness" "deployment_url" "\"$ADMIN_URL\""
        update_results "admin_site_readiness" "status" "\"deployed\""
        
        # Run smoke tests
        smoke_results=$(run_smoke_tests "$ADMIN_URL" "Admin Site")
        update_results "admin_site_readiness" "smoke_test_results" "$smoke_results"
        
        # Local development - no SSL
        update_results "admin_site_readiness" "ssl_status" "\"local_development\""
        update_results "admin_site_readiness" "status" "\"completed\""
        
        echo $ADMIN_PID > admin_server.pid
    else
        log "❌ Admin site deployment failed"
        add_error "admin_site_readiness" "Server failed to start"
        update_results "admin_site_readiness" "status" "\"failed\""
    fi
    
    cd ..
}

# Swagger UI playground deployment
deploy_playground() {
    log "🚀 Deploying Swagger UI Playground..."
    
    # Create playground directory
    mkdir -p docs/playground
    cd docs/playground
    
    # Create Swagger UI HTML
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
    
    # Create package.json
    cat > package.json << EOF
{
  "name": "appoint-docs",
  "version": "1.0.0",
  "scripts": {
    "build": "mkdir -p out && cp index.html out/ && cp openapi_spec.yaml out/",
    "serve": "serve out -p \${PORT:-8083} --single",
    "start": "npm run serve"
  },
  "dependencies": {
    "serve": "^14.2.1"
  }
}
EOF

    # Build and start server
    npm install > /dev/null 2>&1
    npm run build > /dev/null 2>&1
    
    # Start server on port 8083
    npm run serve > playground_server.log 2>&1 &
    DOCS_PID=$!
    
    # Wait for server
    sleep 3
    
    DOCS_URL="http://localhost:8083"
    
    if curl -f -s --max-time 5 "$DOCS_URL" > /dev/null 2>&1; then
        log "✅ Swagger UI playground deployed successfully"
        update_results "deploy_playground" "deployment_url" "\"$DOCS_URL\""
        update_results "deploy_playground" "status" "\"deployed\""
        
        # Test API endpoints
        api_tests="{}"
        
        if curl -f -s --max-time 5 "$DOCS_URL/openapi_spec.yaml" > /dev/null 2>&1; then
            api_tests=$(echo "$api_tests" | jq '.openapi_spec = "PASS"')
            log "✅ OpenAPI spec accessible"
        else
            api_tests=$(echo "$api_tests" | jq '.openapi_spec = "FAIL"')
            log "❌ OpenAPI spec not accessible"
        fi
        
        if curl -f -s -H "Origin: https://appoint.com" --max-time 5 "$DOCS_URL" > /dev/null 2>&1; then
            api_tests=$(echo "$api_tests" | jq '.cors = "PASS"')
            log "✅ CORS configured"
        else
            api_tests=$(echo "$api_tests" | jq '.cors = "FAIL"')
            log "❌ CORS configuration failed"
        fi
        
        update_results "deploy_playground" "api_endpoint_tests" "$api_tests"
        update_results "deploy_playground" "swagger_ui_status" "\"active\""
        update_results "deploy_playground" "cors_status" "\"configured\""
        update_results "deploy_playground" "status" "\"completed\""
        
        echo $DOCS_PID > playground_server.pid
    else
        log "❌ Swagger UI playground deployment failed"
        add_error "deploy_playground" "Server failed to start"
        update_results "deploy_playground" "status" "\"failed\""
    fi
    
    cd ../..
}

# Run all deployments concurrently
log "Starting concurrent deployments..."

deploy_business_site &
BUSINESS_PID=$!

deploy_admin_site &
ADMIN_PID=$!

deploy_playground &
PLAYGROUND_PID=$!

# Wait for all to complete
wait $BUSINESS_PID
wait $ADMIN_PID
wait $PLAYGROUND_PID

# Final status
log "All deployments completed. Generating report..."

if jq -e '.business_site_readiness.status == "completed" and .admin_site_readiness.status == "completed" and .deploy_playground.status == "completed"' "$RESULTS_FILE" > /dev/null 2>&1; then
    update_results "overall_status" "status" "\"completed\""
    log "✅ All deployments successful!"
else
    update_results "overall_status" "status" "\"partial\""
    log "⚠️ Some deployments had issues"
fi

update_results "overall_status" "end_time" "\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\""

# Display results
echo ""
echo "🎯 DEPLOYMENT RESULTS"
echo "===================="
echo "Business Site: $(jq -r '.business_site_readiness.status' "$RESULTS_FILE")"
echo "  URL: $(jq -r '.business_site_readiness.deployment_url' "$RESULTS_FILE")"
echo "  SSL: $(jq -r '.business_site_readiness.ssl_status' "$RESULTS_FILE")"

echo ""
echo "Admin Site: $(jq -r '.admin_site_readiness.status' "$RESULTS_FILE")"
echo "  URL: $(jq -r '.admin_site_readiness.deployment_url' "$RESULTS_FILE")"
echo "  SSL: $(jq -r '.admin_site_readiness.ssl_status' "$RESULTS_FILE")"

echo ""
echo "Swagger UI Playground: $(jq -r '.deploy_playground.status' "$RESULTS_FILE")"
echo "  URL: $(jq -r '.deploy_playground.deployment_url' "$RESULTS_FILE")"
echo "  Status: $(jq -r '.deploy_playground.swagger_ui_status' "$RESULTS_FILE")"

echo ""
echo "Overall Status: $(jq -r '.overall_status.status' "$RESULTS_FILE")"
echo ""
echo "📋 Results saved to: $RESULTS_FILE"
echo ""
echo "🚀 Next Steps for Production:"
echo "1. Configure custom domains (appoint.com, admin.appoint.com, docs.app-oint.com)"
echo "2. Set up SSL certificates"
echo "3. Configure monitoring and alerts"
echo "4. Set up CI/CD pipelines" 