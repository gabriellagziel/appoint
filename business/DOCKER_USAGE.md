# Business Service Docker Usage Guide

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
docker build --target development -t app-oint/business:dev .
docker run -p 8081:8081 app-oint/business:dev

# Or use docker-compose for full stack
docker-compose up business
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
docker build -t app-oint/business:latest .

# Build with specific target
docker build --target production -t app-oint/business:prod .

# Build with build args
docker build \
  --build-arg NODE_ENV=production \
  --build-arg NGINX_PORT=8081 \
  -t app-oint/business:latest .
```

#### Development Build
```bash
# Build development image
docker build --target development -t app-oint/business:dev .

# Build and tag with version
docker build -t app-oint/business:dev-1.0.0 --target development .
```

### Running Containers

#### Production Mode
```bash
# Run production container
docker run -d \
  --name business-prod \
  -p 8081:8081 \
  --restart unless-stopped \
  app-oint/business:latest

# Run with custom nginx configuration
docker run -d \
  --name business-prod \
  -p 8081:8081 \
  -v $(pwd)/custom-nginx.conf:/etc/nginx/nginx.conf:ro \
  app-oint/business:latest

# Run with environment variables
docker run -d \
  --name business-prod \
  -p 8081:8081 \
  -e NGINX_PORT=8081 \
  app-oint/business:latest
```

#### Development Mode
```bash
# Run development container with volume mounting
docker run -d \
  --name business-dev \
  -p 8081:8081 \
  -v $(pwd)/public:/app/public \
  app-oint/business:dev

# Run interactively for debugging
docker run -it \
  --name business-debug \
  -p 8081:8081 \
  app-oint/business:dev \
  /bin/sh
```

### Testing and Health Checks

#### Health Check Testing
```bash
# Test health endpoints
curl -f http://localhost:8081/health.html
curl -f http://localhost:8081/

# Check container health status
docker inspect business-prod --format='{{.State.Health.Status}}'

# View health check logs
docker inspect business-prod --format='{{range .State.Health.Log}}{{.Output}}{{end}}'
```

#### Manual Testing
```bash
# Test static file serving
curl -I http://localhost:8081/
curl http://localhost:8081/

# Test specific files
curl http://localhost:8081/health.html

# Test with different user agents
curl -H "User-Agent: Mozilla/5.0" http://localhost:8081/
```

## 📋 Docker Compose Usage

### Basic Usage
```bash
# Start all services
docker-compose up

# Start in background
docker-compose up -d

# Start specific service
docker-compose up business

# View logs
docker-compose logs business
docker-compose logs -f business

# Stop services
docker-compose down

# Stop and remove volumes
docker-compose down -v
```

### Sample docker-compose.yml
```yaml
version: '3.8'
services:
  business:
    build:
      context: ./business
      target: production
    ports:
      - "8081:8081"
    environment:
      - NGINX_PORT=8081
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8081/health.html"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 30s
    restart: unless-stopped
    
  business-dev:
    profiles:
      - dev
    build:
      context: ./business
      target: development
    ports:
      - "8081:8081"
    volumes:
      - ./business/public:/app/public
    environment:
      - NODE_ENV=development
```

### Production Environment
```yaml
# docker-compose.prod.yml example
version: '3.8'
services:
  business:
    build:
      context: ./business
      target: production
    ports:
      - "8081:8081"
    deploy:
      resources:
        limits:
          memory: 256M
          cpus: '0.25'
        reservations:
          memory: 128M
          cpus: '0.1'
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8081/health.html"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 30s
    restart: unless-stopped
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.business.rule=Host(`business.app-oint.com`)"
```

## 🌍 Environment Variables

### Optional Variables
| Variable | Description | Default | Example |
|----------|-------------|---------|---------|
| `NGINX_PORT` | Nginx port | `8081` | `8081` |
| `NODE_ENV` | Environment mode | `production` | `development` |
| `NGINX_ENVSUBST_OUTPUT_DIR` | Nginx config dir | `/etc/nginx` | `/etc/nginx` |

## 🔍 Health Checks

The container includes comprehensive health checks:

### Health Endpoints
- `GET /health.html` - Static health check page
- `GET /` - Main application (index.html)

### Health Check Commands
```bash
# Manual health check
curl -f http://localhost:8081/health.html

# Docker health check
docker exec business-prod curl -f http://localhost:8081/health.html

# Check if main app loads
curl -f http://localhost:8081/
```

### Sample Health Response
```html
<!DOCTYPE html>
<html>
<head><title>Health Check</title></head>
<body>
  <h1>OK</h1>
  <p>Business service is healthy</p>
  <script>window.healthStatus = "healthy";</script>
</body>
</html>
```

## 🛠️ Troubleshooting

### Common Issues

#### Container Won't Start
```bash
# Check logs
docker logs business-prod

# Check nginx configuration
docker exec business-prod nginx -t

# Debug with shell access
docker run -it --entrypoint /bin/sh app-oint/business:latest
```

#### Port Already in Use
```bash
# Find process using port 8081
lsof -i :8081

# Kill process
kill -9 <PID>

# Use different port
docker run -p 8082:8081 app-oint/business:latest
```

#### Static Files Not Loading
```bash
# Check file permissions
docker exec business-prod ls -la /var/www/html

# Check nginx status
docker exec business-prod ps aux | grep nginx

# Check nginx error logs
docker exec business-prod cat /var/log/nginx/error.log
```

### Performance Optimization

#### Nginx Tuning
```bash
# Check nginx configuration
docker exec business-prod nginx -T

# Monitor nginx access logs
docker exec business-prod tail -f /var/log/nginx/access.log

# Check worker processes
docker exec business-prod ps aux | grep nginx
```

#### Container Optimization
```bash
# Check container size
docker images app-oint/business

# Analyze image layers
docker history app-oint/business:latest

# Check resource usage
docker stats business-prod
```

## 🚢 Deployment

### Container Registry
```bash
# Tag for registry
docker tag app-oint/business:latest your-registry.com/app-oint/business:latest

# Push to registry
docker push your-registry.com/app-oint/business:latest

# Pull and run
docker pull your-registry.com/app-oint/business:latest
docker run -d your-registry.com/app-oint/business:latest
```

### Kubernetes Deployment
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: business
spec:
  replicas: 2
  selector:
    matchLabels:
      app: business
  template:
    metadata:
      labels:
        app: business
    spec:
      containers:
      - name: business
        image: app-oint/business:latest
        ports:
        - containerPort: 8081
        livenessProbe:
          httpGet:
            path: /health.html
            port: 8081
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /
            port: 8081
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
  name: business-service
spec:
  selector:
    app: business
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8081
  type: ClusterIP
```

### Docker Swarm
```bash
# Deploy to swarm
docker service create \
  --name business \
  --replicas 2 \
  --publish 8081:8081 \
  --constraint 'node.role == worker' \
  app-oint/business:latest

# Update service
docker service update --image app-oint/business:v1.1.0 business
```

## 📊 Monitoring

### Logging
```bash
# Follow logs
docker logs -f business-prod

# View last 100 lines
docker logs --tail 100 business-prod

# Export logs
docker logs business-prod > business.log 2>&1
```

### Metrics
```bash
# Container metrics
docker stats business-prod

# Nginx metrics (if enabled)
curl http://localhost:8081/nginx_status

# Check disk usage
docker exec business-prod df -h
```

### Health Monitoring
- Health status: `GET /health.html`
- Service status: `GET /`
- Nginx status: Check logs and process status

## 🔒 Security

### Best Practices
- Uses non-root user (`business:business`)
- Minimal Alpine Linux base image
- Multi-stage build reduces attack surface
- Proper file permissions and ownership
- Tini for proper signal handling

### Security Scanning
```bash
# Scan with Docker Scout (if available)
docker scout cves app-oint/business:latest

# Scan with Trivy
trivy image app-oint/business:latest

# Check for vulnerabilities
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  -v $(pwd):/tmp -w /tmp \
  aquasec/trivy image app-oint/business:latest
```

## 📚 Additional Resources

- [Nginx Docker Best Practices](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-docker/)
- [Docker Multi-stage Builds](https://docs.docker.com/develop/dev-best-practices/)
- [Static Site Deployment Guide](https://nginx.org/en/docs/beginners_guide.html)

## 🆘 Support

For issues specific to the Business service:
1. Check container logs: `docker logs business-prod`
2. Verify nginx configuration: `docker exec business-prod nginx -t`
3. Test health endpoints: `curl http://localhost:8081/health.html`
4. Check resource usage: `docker stats business-prod`

For general Docker issues, consult the Docker documentation or your platform-specific guides.