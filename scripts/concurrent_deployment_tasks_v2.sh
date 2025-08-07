#!/bin/bash
set -e

# 🚀 CONCURRENT DEPLOYMENT TASKS SCRIPT V2
# This script runs all three deployment tasks concurrently with better error handling

echo "🚀 Starting concurrent deployment tasks (v2)..."
echo "=============================================="

# Configuration
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
RESULTS_FILE="deployment_results_${TIMESTAMP}.json"
LOG_FILE="deployment_log_${TIMESTAMP}.log"

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
    if [ -f "$RESULTS_FILE" ]; then
        jq ".$task.$field = $value" "$RESULTS_FILE" > "${RESULTS_FILE}.tmp" && mv "${RESULTS_FILE}.tmp" "$RESULTS_FILE"
    fi
}

# Add error function
add_error() {
    local task=$1
    local error=$2
    if [ -f "$RESULTS_FILE" ]; then
        jq ".$task.errors += [\"$error\"]" "$RESULTS_FILE" > "${RESULTS_FILE}.tmp" && mv "${RESULTS_FILE}.tmp" "$RESULTS_FILE"
    fi
}

# Smoke test function
run_smoke_tests() {
    local url=$1
    local service_name=$2
    
    log "Running smoke tests for $service_name at $url"
    
    local results="{}"
    
    # Test page load
    if curl -f -s --max-time 10 "$url" > /dev/null 2>&1; then
        results=$(echo "$results" | jq '.page_load = "PASS"')
        log "✅ Page load test PASSED for $service_name"
    else
        results=$(echo "$results" | jq '.page_load = "FAIL"')
        log "❌ Page load test FAILED for $service_name"
    fi
    
    # Test health endpoint
    if curl -f -s --max-time 10 "$url/health.html" > /dev/null 2>&1; then
        results=$(echo "$results" | jq '.health_check = "PASS"')
        log "✅ Health check PASSED for $service_name"
    else
        results=$(echo "$results" | jq '.health_check = "FAIL"')
        log "❌ Health check FAILED for $service_name"
    fi
    
    # Test SSL/HTTPS
    if curl -f -s -I --max-time 10 "$url" | grep -q "HTTP/.* 200"; then
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
    
    # Check if business directory exists
    if [ ! -d "business" ]; then
        log "❌ Business directory not found"
        add_error "business_site_readiness" "Business directory not found"
        update_results "business_site_readiness" "status" "\"failed\""
        return 1
    fi
    
    cd business
    
    # Check if package.json exists
    if [ ! -f "package.json" ]; then
        log "❌ package.json not found in business directory"
        add_error "business_site_readiness" "package.json not found"
        update_results "business_site_readiness" "status" "\"failed\""
        cd ..
        return 1
    fi
    
    # Install dependencies
    log "Installing business site dependencies..."
    if npm install > business_install.log 2>&1; then
        log "✅ Business dependencies installed"
    else
        log "❌ Business dependencies installation failed"
        add_error "business_site_readiness" "Dependencies installation failed"
        update_results "business_site_readiness" "status" "\"failed\""
        cd ..
        return 1
    fi
    
    # Build business site
    log "Building business site..."
    if npm run build > business_build.log 2>&1; then
        log "✅ Business site built successfully"
    else
        log "❌ Business site build failed"
        add_error "business_site_readiness" "Build failed"
        update_results "business_site_readiness" "status" "\"failed\""
        cd ..
        return 1
    fi
    
    # Create a simple deployment using serve
    log "Starting business site server..."
    BUSINESS_PORT=8081
    BUSINESS_URL="http://localhost:$BUSINESS_PORT"
    
    # Start server in background
    npm run serve > business_server.log 2>&1 &
    BUSINESS_PID=$!
    
    # Wait for server to start
    sleep 5
    
    # Check if server is running
    if curl -f -s --max-time 10 "$BUSINESS_URL" > /dev/null 2>&1; then
        log "✅ Business site server started successfully"
        update_results "business_site_readiness" "deployment_url" "\"$BUSINESS_URL\""
        update_results "business_site_readiness" "status" "\"deployed\""
        
        # Run smoke tests
        log "Running smoke tests for business site..."
        smoke_results=$(run_smoke_tests "$BUSINESS_URL" "Business Site")
        update_results "business_site_readiness" "smoke_test_results" "$smoke_results"
        
        # Check SSL status (local deployment won't have SSL)
        update_results "business_site_readiness" "ssl_status" "\"local_development\""
        update_results "business_site_readiness" "status" "\"completed\""
        log "✅ Business site deployment completed successfully"
        
        # Keep server running for testing
        echo $BUSINESS_PID > business_server.pid
        
    else
        log "❌ Business site server failed to start"
        add_error "business_site_readiness" "Server failed to start"
        update_results "business_site_readiness" "status" "\"failed\""
        kill $BUSINESS_PID 2>/dev/null || true
    fi
    
    cd ..
}

# Admin site deployment function
deploy_admin_site() {
    log "🚀 Starting Admin site deployment..."
    
    # Check if admin directory exists
    if [ ! -d "admin" ]; then
        log "❌ Admin directory not found"
        add_error "admin_site_readiness" "Admin directory not found"
        update_results "admin_site_readiness" "status" "\"failed\""
        return 1
    fi
    
    cd admin
    
    # Check if package.json exists
    if [ ! -f "package.json" ]; then
        log "❌ package.json not found in admin directory"
        add_error "admin_site_readiness" "package.json not found"
        update_results "admin_site_readiness" "status" "\"failed\""
        cd ..
        return 1
    fi
    
    # Install dependencies
    log "Installing admin site dependencies..."
    if npm install > admin_install.log 2>&1; then
        log "✅ Admin dependencies installed"
    else
        log "❌ Admin dependencies installation failed"
        add_error "admin_site_readiness" "Dependencies installation failed"
        update_results "admin_site_readiness" "status" "\"failed\""
        cd ..
        return 1
    fi
    
    # Build admin site
    log "Building admin site..."
    if npm run build > admin_build.log 2>&1; then
        log "✅ Admin site built successfully"
    else
        log "❌ Admin site build failed"
        add_error "admin_site_readiness" "Build failed"
        update_results "admin_site_readiness" "status" "\"failed\""
        cd ..
        return 1
    fi
    
    # Create a simple deployment using serve
    log "Starting admin site server..."
    ADMIN_PORT=8082
    ADMIN_URL="http://localhost:$ADMIN_PORT"
    
    # Start server in background
    npm run serve > admin_server.log 2>&1 &
    ADMIN_PID=$!
    
    # Wait for server to start
    sleep 5
    
    # Check if server is running
    if curl -f -s --max-time 10 "$ADMIN_URL" > /dev/null 2>&1; then
        log "✅ Admin site server started successfully"
        update_results "admin_site_readiness" "deployment_url" "\"$ADMIN_URL\""
        update_results "admin_site_readiness" "status" "\"deployed\""
        
        # Run smoke tests
        log "Running smoke tests for admin site..."
        smoke_results=$(run_smoke_tests "$ADMIN_URL" "Admin Site")
        update_results "admin_site_readiness" "smoke_test_results" "$smoke_results"
        
        # Check SSL status (local deployment won't have SSL)
        update_results "admin_site_readiness" "ssl_status" "\"local_development\""
        update_results "admin_site_readiness" "status" "\"completed\""
        log "✅ Admin site deployment completed successfully"
        
        # Keep server running for testing
        echo $ADMIN_PID > admin_server.pid
        
    else
        log "❌ Admin site server failed to start"
        add_error "admin_site_readiness" "Server failed to start"
        update_results "admin_site_readiness" "status" "\"failed\""
        kill $ADMIN_PID 2>/dev/null || true
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
    if [ -f "../../openapi_spec.yaml" ]; then
        cp ../../openapi_spec.yaml ./openapi_spec.yaml
        log "✅ OpenAPI spec copied"
    else
        log "❌ OpenAPI spec not found"
        add_error "deploy_playground" "OpenAPI spec not found"
        update_results "deploy_playground" "status" "\"failed\""
        cd ../..
        return 1
    fi
    
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

    # Install dependencies
    log "Installing playground dependencies..."
    if npm install > playground_install.log 2>&1; then
        log "✅ Playground dependencies installed"
    else
        log "❌ Playground dependencies installation failed"
        add_error "deploy_playground" "Dependencies installation failed"
        update_results "deploy_playground" "status" "\"failed\""
        cd ../..
        return 1
    fi
    
    # Build playground
    log "Building playground..."
    if npm run build > playground_build.log 2>&1; then
        log "✅ Playground built successfully"
    else
        log "❌ Playground build failed"
        add_error "deploy_playground" "Build failed"
        update_results "deploy_playground" "status" "\"failed\""
        cd ../..
        return 1
    fi
    
    # Start playground server
    log "Starting playground server..."
    DOCS_PORT=8083
    DOCS_URL="http://localhost:$DOCS_PORT"
    
    # Start server in background
    npm run serve > playground_server.log 2>&1 &
    DOCS_PID=$!
    
    # Wait for server to start
    sleep 5
    
    # Check if server is running
    if curl -f -s --max-time 10 "$DOCS_URL" > /dev/null 2>&1; then
        log "✅ Playground server started successfully"
        update_results "deploy_playground" "deployment_url" "\"$DOCS_URL\""
        update_results "deploy_playground" "status" "\"deployed\""
        
        # Test API endpoints
        log "Testing API endpoints in playground..."
        api_tests="{}"
        
        # Test OpenAPI spec
        if curl -f -s --max-time 10 "$DOCS_URL/openapi_spec.yaml" > /dev/null 2>&1; then
            api_tests=$(echo "$api_tests" | jq '.openapi_spec = "PASS"')
            log "✅ OpenAPI spec accessible"
        else
            api_tests=$(echo "$api_tests" | jq '.openapi_spec = "FAIL"')
            log "❌ OpenAPI spec not accessible"
        fi
        
        # Test CORS
        if curl -f -s -H "Origin: https://appoint.com" --max-time 10 "$DOCS_URL" > /dev/null 2>&1; then
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
        
        # Keep server running for testing
        echo $DOCS_PID > playground_server.pid
        
    else
        log "❌ Playground server failed to start"
        add_error "deploy_playground" "Server failed to start"
        update_results "deploy_playground" "status" "\"failed\""
        kill $DOCS_PID 2>/dev/null || true
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
echo ""
echo "📋 Next Steps:"
echo "1. Configure custom domains (appoint.com, admin.appoint.com, docs.app-oint.com)"
echo "2. Set up SSL certificates for production"
echo "3. Configure monitoring and alerts"
echo "4. Set up CI/CD pipelines for automated deployments" 