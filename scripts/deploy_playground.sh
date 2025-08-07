#!/bin/bash

# Deploy App-Oint API Playground to docs.app-oint.com
# This script deploys the Swagger UI playground with the OpenAPI spec

set -e

echo "🚀 Deploying App-Oint API Playground..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
DOMAIN="docs.app-oint.com"
DEPLOY_PATH="/var/www/docs.app-oint.com"
BACKUP_PATH="/var/www/backups/docs.app-oint.com"

# Create necessary directories
echo -e "${BLUE}📁 Creating deployment directories...${NC}"
sudo mkdir -p $DEPLOY_PATH
sudo mkdir -p $BACKUP_PATH

# Backup existing deployment
if [ -d "$DEPLOY_PATH" ] && [ "$(ls -A $DEPLOY_PATH)" ]; then
    echo -e "${YELLOW}💾 Creating backup of existing deployment...${NC}"
    sudo cp -r $DEPLOY_PATH $BACKUP_PATH/$(date +%Y%m%d_%H%M%S)
fi

# Copy OpenAPI spec
echo -e "${BLUE}📄 Copying OpenAPI specification...${NC}"
sudo cp openapi_spec.yaml $DEPLOY_PATH/

# Copy Swagger UI files
echo -e "${BLUE}🌐 Copying Swagger UI files...${NC}"
sudo cp -r docs/swagger-ui/* $DEPLOY_PATH/

# Set proper permissions
echo -e "${BLUE}🔐 Setting file permissions...${NC}"
sudo chown -R www-data:www-data $DEPLOY_PATH
sudo chmod -R 755 $DEPLOY_PATH

# Create nginx configuration
echo -e "${BLUE}⚙️ Creating nginx configuration...${NC}"
sudo tee /etc/nginx/sites-available/docs.app-oint.com > /dev/null <<EOF
server {
    listen 80;
    server_name docs.app-oint.com;
    
    root $DEPLOY_PATH;
    index index.html;
    
    location / {
        try_files \$uri \$uri/ =404;
    }
    
    location /openapi_spec.yaml {
        add_header Content-Type application/yaml;
        add_header Access-Control-Allow-Origin *;
    }
    
    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;
}
EOF

# Enable site
echo -e "${BLUE}🔗 Enabling nginx site...${NC}"
sudo ln -sf /etc/nginx/sites-available/docs.app-oint.com /etc/nginx/sites-enabled/

# Test nginx configuration
echo -e "${BLUE}🧪 Testing nginx configuration...${NC}"
if sudo nginx -t; then
    echo -e "${GREEN}✅ Nginx configuration is valid${NC}"
else
    echo -e "${RED}❌ Nginx configuration test failed${NC}"
    exit 1
fi

# Reload nginx
echo -e "${BLUE}🔄 Reloading nginx...${NC}"
sudo systemctl reload nginx

# Test deployment
echo -e "${BLUE}🧪 Testing deployment...${NC}"
sleep 3

if curl -f -s "http://$DOMAIN" > /dev/null; then
    echo -e "${GREEN}✅ Deployment successful!${NC}"
    echo -e "${GREEN}🌐 Playground available at: https://$DOMAIN${NC}"
else
    echo -e "${RED}❌ Deployment test failed${NC}"
    echo -e "${YELLOW}🔍 Checking nginx status...${NC}"
    sudo systemctl status nginx
    exit 1
fi

# Create SSL certificate (if certbot is available)
if command -v certbot &> /dev/null; then
    echo -e "${BLUE}🔒 Setting up SSL certificate...${NC}"
    sudo certbot --nginx -d $DOMAIN --non-interactive --agree-tos --email admin@appoint.com || {
        echo -e "${YELLOW}⚠️ SSL certificate setup failed, but deployment is complete${NC}"
    }
else
    echo -e "${YELLOW}⚠️ Certbot not found, SSL certificate not configured${NC}"
fi

echo -e "${GREEN}🎉 App-Oint API Playground deployment complete!${NC}"
echo -e "${BLUE}📊 Playground URL: https://$DOMAIN${NC}"
echo -e "${BLUE}📚 API Documentation: https://$DOMAIN${NC}"
echo -e "${BLUE}🔑 Demo API Key: demo_api_key_123456789${NC}" 