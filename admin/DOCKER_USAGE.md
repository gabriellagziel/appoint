# Admin Service Docker Usage Guide

## 🚀 Quick Start

### Prerequisites
- Docker Engine 20.10+
- Docker Compose 2.0+
- Node.js 22+ (for local development)

## 🔧 Local Development

### Environment Setup
```bash
# Copy environment file (if needed)
cp .env.example .env

# Edit with your configuration
nano .env
```

### Development with Docker
```bash
# Build and run in development mode
docker build --target development -t app-oint/admin:dev .
docker run -p 8082:8082 app-oint/admin:dev

# Or use docker-compose for full stack
docker-compose up admin
```

### Traditional Local Development
```bash
# Install dependencies
npm install

# Export static files
npm run export

# Start development server
npm run serve

# Health check
npm run health
```

## 🐳 Docker Commands

### Building Images

#### Production Build
```bash
# Build production image (default target)
docker build -t app-oint/admin:latest .

# Build with specific target
docker build --target production -t app-oint/admin:prod .

# Build with build args
docker build \
  --build-arg NODE_ENV=production \
  --build-arg NGINX_PORT=8082 \
  -t app-oint/admin:latest .
```

#### Development Build
```bash
# Build development image
docker build --target development -t app-oint/admin:dev .

# Build and tag with version
docker build -t app-oint/admin:dev-1.0.0 --target development .
```

### Running Containers

#### Production Mode
```bash
# Run production container
docker run -d \
  --name admin-prod \
  -p 8082:8082 \
  --restart unless-stopped \
  app-oint/admin:latest

# Run with custom nginx configuration
docker run -d \
  --name admin-prod \
  -p 8082:8082 \
  -v $(pwd)/custom-nginx.conf:/etc/nginx/nginx.conf:ro \
  app-oint/admin:latest

# Run with environment variables
docker run -d \
  --name admin-prod \
  -p 8082:8082 \
  -e NGINX_PORT=8082 \
  app-oint/admin:latest
```

#### Development Mode
```bash
# Run development container with volume mounting
docker run -d \
  --name admin-dev \
  -p 8082:8082 \
  -v $(pwd)/public:/app/public \
  app-oint/admin:dev

# Run interactively for debugging
docker run -it \
  --name admin-debug \
  -p 8082:8082 \
  app-oint/admin:dev \
  /bin/sh
```

### Testing and Health Checks

#### Health Check Testing
```bash
# Test health endpoints
curl -f http://localhost:8082/health.html
curl -f http://localhost:8082/

# Check container health status
docker inspect admin-prod --format='{{.State.Health.Status}}'

# View health check logs
docker inspect admin-prod --format='{{range .State.Health.Log}}{{.Output}}{{end}}'
```

#### Manual Testing
```bash
# Test static file serving
curl -I http://localhost:8082/
curl http://localhost:8082/

# Test specific files
curl http://localhost:8082/health.html

# Test with different user agents
curl -H "User-Agent: Mozilla/5.0" http://localhost:8082/
```

## 📋 Docker Compose Usage

### Basic Usage
```bash
# Start all services
docker-compose up

# Start in background
docker-compose up -d

# Start specific service
docker-compose up admin

# View logs
docker-compose logs admin
docker-compose logs -f admin

# Stop services
docker-compose down

# Stop and remove volumes
docker-compose down -v
```

### Sample docker-compose.yml
```yaml
version: '3.8'
services:
  admin:
    build:
      context: ./admin
      target: production
    ports:
      - "8082:8082"
    environment:
      - NGINX_PORT=8082
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8082/health.html"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 30s
    restart: unless-stopped
    
  admin-dev:
    profiles:
      - dev
    build:
      context: ./admin
      target: development
    ports:
      - "8082:8082"
    volumes:
      - ./admin/public:/app/public
    environment:
      - NODE_ENV=development
```

### Production Environment
```yaml
# docker-compose.prod.yml example
version: '3.8'
services:
  admin:
    build:
      context: ./admin
      target: production
    ports:
      - "8082:8082"
    deploy:
      resources:
        limits:
          memory: 256M
          cpus: '0.25'
        reservations:
          memory: 128M
          cpus: '0.1'
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8082/health.html"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 30s
    restart: unless-stopped
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.admin.rule=Host(`admin.app-oint.com`)"
      - "traefik.http.middlewares.admin-auth.basicauth.users=admin:$$2y$$10$$..."
```

## 🌍 Environment Variables

### Optional Variables
| Variable | Description | Default | Example |
|----------|-------------|---------|---------|
| `NGINX_PORT` | Nginx port | `8082` | `8082` |
| `NODE_ENV` | Environment mode | `production` | `development` |
| `NGINX_ENVSUBST_OUTPUT_DIR` | Nginx config dir | `/etc/nginx` | `/etc/nginx` |

## 🔍 Health Checks

The container includes comprehensive health checks:

### Health Endpoints
- `GET /health.html` - Static health check page
- `GET /` - Main admin application (index.html)

### Health Check Commands
```bash
# Manual health check
curl -f http://localhost:8082/health.html

# Docker health check
docker exec admin-prod curl -f http://localhost:8082/health.html

# Check if main admin app loads
curl -f http://localhost:8082/
```

### Sample Health Response
```html
<!DOCTYPE html>
<html>
<head><title>Health Check</title></head>
<body>
  <h1>OK</h1>
  <p>Admin service is healthy</p>
  <script>window.healthStatus = "healthy";</script>
</body>
</html>
```

## 🛠️ Troubleshooting

### Common Issues

#### Container Won't Start
```bash
# Check logs
docker logs admin-prod

# Check nginx configuration
docker exec admin-prod nginx -t

# Debug with shell access
docker run -it --entrypoint /bin/sh app-oint/admin:latest
```

#### Port Already in Use
```bash
# Find process using port 8082
lsof -i :8082

# Kill process
kill -9 <PID>

# Use different port
docker run -p 8083:8082 app-oint/admin:latest
```

#### Static Files Not Loading
```bash
# Check file permissions
docker exec admin-prod ls -la /var/www/html

# Check nginx status
docker exec admin-prod ps aux | grep nginx

# Check nginx error logs
docker exec admin-prod cat /var/log/nginx/error.log
```

### Performance Optimization

#### Nginx Tuning
```bash
# Check nginx configuration
docker exec admin-prod nginx -T

# Monitor nginx access logs
docker exec admin-prod tail -f /var/log/nginx/access.log

# Check worker processes
docker exec admin-prod ps aux | grep nginx
```

#### Container Optimization
```bash
# Check container size
docker images app-oint/admin

# Analyze image layers
docker history app-oint/admin:latest

# Check resource usage
docker stats admin-prod
```

## 🚢 Deployment

### Container Registry
```bash
# Tag for registry
docker tag app-oint/admin:latest your-registry.com/app-oint/admin:latest

# Push to registry
docker push your-registry.com/app-oint/admin:latest

# Pull and run
docker pull your-registry.com/app-oint/admin:latest
docker run -d your-registry.com/app-oint/admin:latest
```

### Kubernetes Deployment
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: admin
spec:
  replicas: 2
  selector:
    matchLabels:
      app: admin
  template:
    metadata:
      labels:
        app: admin
    spec:
      containers:
      - name: admin
        image: app-oint/admin:latest
        ports:
        - containerPort: 8082
        livenessProbe:
          httpGet:
            path: /health.html
            port: 8082
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /
            port: 8082
          initialDelaySeconds: 5
          periodSeconds: 5
        resources:
          limits:
            memory: 256Mi
            cpu: 250m
          requests:
            memory: 128Mi
            cpu: 100m
---
apiVersion: v1
kind: Service
metadata:
  name: admin-service
spec:
  selector:
    app: admin
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8082
  type: ClusterIP
```

### Docker Swarm
```bash
# Deploy to swarm
docker service create \
  --name admin \
  --replicas 2 \
  --publish 8082:8082 \
  --constraint 'node.role == worker' \
  app-oint/admin:latest

# Update service
docker service update --image app-oint/admin:v1.1.0 admin
```

## 📊 Monitoring

### Logging
```bash
# Follow logs
docker logs -f admin-prod

# View last 100 lines
docker logs --tail 100 admin-prod

# Export logs
docker logs admin-prod > admin.log 2>&1
```

### Metrics
```bash
# Container metrics
docker stats admin-prod

# Nginx metrics (if enabled)
curl http://localhost:8082/nginx_status

# Check disk usage
docker exec admin-prod df -h
```

### Health Monitoring
- Health status: `GET /health.html`
- Service status: `GET /`
- Nginx status: Check logs and process status

## 🔒 Security

### Best Practices
- Uses non-root user (`admin:admin`)
- Minimal Alpine Linux base image
- Multi-stage build reduces attack surface
- Proper file permissions and ownership
- Tini for proper signal handling
- Basic auth middleware support for admin routes

### Security Scanning
```bash
# Scan with Docker Scout (if available)
docker scout cves app-oint/admin:latest

# Scan with Trivy
trivy image app-oint/admin:latest

# Check for vulnerabilities
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  -v $(pwd):/tmp -w /tmp \
  aquasec/trivy image app-oint/admin:latest
```

### Admin Security
```bash
# Example basic auth setup for admin routes
echo "admin:$(openssl passwd -apr1 your-password)" > .htpasswd

# Use in nginx configuration or reverse proxy
# For production, implement proper OAuth/JWT authentication
```

## 📚 Additional Resources

- [Nginx Docker Best Practices](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-docker/)
- [Docker Multi-stage Builds](https://docs.docker.com/develop/dev-best-practices/)
- [Admin Panel Security Guide](https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html)

## 🆘 Support

For issues specific to the Admin service:
1. Check container logs: `docker logs admin-prod`
2. Verify nginx configuration: `docker exec admin-prod nginx -t`
3. Test health endpoints: `curl http://localhost:8082/health.html`
4. Check resource usage: `docker stats admin-prod`
5. Verify admin authentication (if configured)

For general Docker issues, consult the Docker documentation or your platform-specific guides.