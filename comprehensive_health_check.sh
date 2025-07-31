#!/bin/bash

echo "🏥 COMPREHENSIVE DIGITALOCEAN HEALTH CHECK"
echo "==========================================="

# Check main application
echo "🌐 Testing main application..."
curl -s -o /dev/null -w "Main App: %{http_code} (%{time_total}s)\n" https://app-oint.com/ || echo "Main App: Connection failed"

# Check admin portal
echo "👨‍💼 Testing admin portal..."
curl -s -o /dev/null -w "Admin Portal: %{http_code} (%{time_total}s)\n" https://app-oint.com/admin || echo "Admin Portal: Connection failed"

# Check business portal
echo "🏢 Testing business portal..."
curl -s -o /dev/null -w "Business Portal: %{http_code} (%{time_total}s)\n" https://app-oint.com/business || echo "Business Portal: Connection failed"

# Check API endpoints
echo "🔌 Testing API endpoints..."
curl -s -o /dev/null -w "API Status: %{http_code} (%{time_total}s)\n" https://app-oint.com/api/status || echo "API Status: Connection failed"

# Check SEO assets
echo "🔍 Testing SEO assets..."
curl -s -o /dev/null -w "Robots.txt: %{http_code} (%{time_total}s)\n" https://app-oint.com/robots.txt || echo "Robots.txt: Connection failed"
curl -s -o /dev/null -w "Sitemap.xml: %{http_code} (%{time_total}s)\n" https://app-oint.com/sitemap.xml || echo "Sitemap.xml: Connection failed"

# Check subdomains
echo "🌍 Testing subdomains..."
curl -s -o /dev/null -w "API Subdomain: %{http_code} (%{time_total}s)\n" https://api.app-oint.com/status || echo "API Subdomain: Connection failed"
curl -s -o /dev/null -w "Admin Subdomain: %{http_code} (%{time_total}s)\n" https://admin.app-oint.com/ || echo "Admin Subdomain: Connection failed"

echo ""
echo "✅ Health check complete!"
echo "Run python3 verify_deployment.py for detailed analysis"

