# Functions Service Docker Usage Guide

## 🚀 Quick Start

### Prerequisites
- Docker Engine 20.10+
- Docker Compose 2.0+
- Node.js 22+ (for local development)

## 🔧 Local Development

### Environment Setup
```bash
# Copy environment file
cp .env.example .env

# Edit with your configuration
nano .env
```

### Development with Docker
```bash
# Build and run in development mode
docker-compose up functions-dev

# Or use development profile
docker-compose --profile dev up functions-dev

# Run with hot reloading
docker-compose -f docker-compose.yml up functions-dev
```

### Traditional Local Development
```bash
# Install dependencies
npm install

# Build TypeScript
npm run build

# Start development server
npm run dev

# Run tests
npm test
```

## 🐳 Docker Commands

### Building Images

#### Production Build
```bash
# Build production image
docker build -t app-oint/functions:latest .

# Build with specific target
docker build --target production -t app-oint/functions:prod .

# Build with build args
docker build \
  --build-arg NODE_ENV=production \
  --build-arg PORT=8080 \
  -t app-oint/functions:latest .
```

#### Development Build
```bash
# Build development image
docker build --target development -t app-oint/functions:dev .

# Build and tag with version
docker build -t app-oint/functions:dev-1.0.0 --target development .
```

### Running Containers

#### Production Mode
```bash
# Run production container
docker run -d \
  --name functions-prod \
  -p 8080:8080 \
  -e NODE_ENV=production \
  -e DATABASE_URL=your_database_url \
  -e REDIS_URL=redis://redis:6379/0 \
  --restart unless-stopped \
  app-oint/functions:latest

# Run with environment file
docker run -d \
  --name functions-prod \
  -p 8080:8080 \
  --env-file .env \
  app-oint/functions:latest
```

#### Development Mode
```bash
# Run with volume mounting for development
docker run -d \
  --name functions-dev \
  -p 8080:8080 \
  -v $(pwd):/app \
  -v /app/node_modules \
  -e NODE_ENV=development \
  app-oint/functions:dev

# Run interactively for debugging
docker run -it \
  --name functions-debug \
  -p 8080:8080 \
  -v $(pwd):/app \
  app-oint/functions:dev \
  /bin/sh
```

### Testing in Docker

#### Run Tests
```bash
# Run all tests
docker run --rm \
  -v $(pwd):/app \
  -e NODE_ENV=test \
  app-oint/functions:dev \
  npm test

# Run specific test suite
docker run --rm \
  -v $(pwd):/app \
  -e NODE_ENV=test \
  app-oint/functions:dev \
  npm run test:health

# Run tests with coverage
docker run --rm \
  -v $(pwd):/app \
  -v $(pwd)/coverage:/app/coverage \
  -e NODE_ENV=test \
  app-oint/functions:dev \
  npm run test:coverage
```

#### Health Check Testing
```bash
# Test health endpoints
curl -f http://localhost:8080/health
curl -f http://localhost:8080/api/health
curl -f http://localhost:8080/ping

# Check container health status
docker inspect functions-prod --format='{{.State.Health.Status}}'
```

## 📋 Docker Compose Usage

### Basic Usage
```bash
# Start all services
docker-compose up

# Start in background
docker-compose up -d

# Start specific service
docker-compose up functions

# View logs
docker-compose logs functions
docker-compose logs -f functions

# Stop services
docker-compose down

# Stop and remove volumes
docker-compose down -v
```

### Development Environment
```bash
# Start development environment
docker-compose --profile dev up

# Rebuild and start
docker-compose up --build functions-dev

# Run tests in compose environment
docker-compose exec functions npm test
```

### Production Environment
```yaml
# docker-compose.prod.yml example
version: '3.8'
services:
  functions:
    build:
      context: .
      target: production
    environment:
      - NODE_ENV=production
      - DATABASE_URL=${DATABASE_URL}
      - REDIS_URL=${REDIS_URL}
      - JWT_SECRET=${JWT_SECRET}
    deploy:
      resources:
        limits:
          memory: 1G
          cpus: '0.5'
        reservations:
          memory: 512M
          cpus: '0.25'
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8080/ping"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
```

## 🌍 Environment Variables

### Required Variables
| Variable | Description | Example |
|----------|-------------|---------|
| `NODE_ENV` | Environment mode | `production` |
| `PORT` | Service port | `8080` |
| `DATABASE_URL` | Database connection | `postgresql://user:pass@host:5432/db` |

### Optional Variables
| Variable | Description | Default | Example |
|----------|-------------|---------|---------|
| `HOSTNAME` | Service hostname | `0.0.0.0` | `0.0.0.0` |
| `REDIS_URL` | Redis connection | - | `redis://redis:6379/0` |
| `JWT_SECRET` | JWT signing secret | - | `your-jwt-secret` |
| `LOG_LEVEL` | Logging level | `info` | `debug` |

## 🔍 Health Checks

The container includes comprehensive health checks:

### Health Endpoints
- `GET /health` - Detailed health status with dependencies
- `GET /api/health` - Alias to `/health`
- `GET /ping` - Simple health check for Docker
- `GET /api/status` - Service status information

### Health Check Commands
```bash
# Manual health check
curl -f http://localhost:8080/health

# Docker health check
docker exec functions-prod curl -f http://localhost:8080/ping

# View health check logs
docker inspect functions-prod --format='{{range .State.Health.Log}}{{.Output}}{{end}}'
```

### Sample Health Response
```json
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

## 🛠️ Troubleshooting

### Common Issues

#### Container Won't Start
```bash
# Check logs
docker logs functions-prod

# Check environment variables
docker exec functions-prod env

# Debug with shell access
docker run -it --entrypoint /bin/sh app-oint/functions:latest
```

#### Port Already in Use
```bash
# Find process using port 8080
lsof -i :8080

# Kill process
kill -9 <PID>

# Use different port
docker run -p 8081:8080 app-oint/functions:latest
```

#### Permission Issues
```bash
# Check file ownership
docker exec functions-prod ls -la /app

# Fix ownership (if needed)
docker exec --user root functions-prod chown -R functions:nodejs /app
```

### Performance Optimization

#### Memory Usage
```bash
# Limit memory usage
docker run -m 1g app-oint/functions:latest

# Monitor memory usage
docker stats functions-prod

# Check Node.js memory usage
docker exec functions-prod node -e "console.log(process.memoryUsage())"
```

#### Build Optimization
```bash
# Use build cache
docker build --cache-from app-oint/functions:latest .

# Multi-platform build
docker buildx build --platform linux/amd64,linux/arm64 .

# Squash layers (experimental)
docker build --squash -t app-oint/functions:latest .
```

## 🚢 Deployment

### Container Registry
```bash
# Tag for registry
docker tag app-oint/functions:latest your-registry.com/app-oint/functions:latest

# Push to registry
docker push your-registry.com/app-oint/functions:latest

# Pull and run
docker pull your-registry.com/app-oint/functions:latest
docker run -d your-registry.com/app-oint/functions:latest
```

### Kubernetes Deployment
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: functions
spec:
  replicas: 3
  selector:
    matchLabels:
      app: functions
  template:
    metadata:
      labels:
        app: functions
    spec:
      containers:
      - name: functions
        image: app-oint/functions:latest
        ports:
        - containerPort: 8080
        env:
        - name: NODE_ENV
          value: "production"
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              name: functions-secrets
              key: database-url
        livenessProbe:
          httpGet:
            path: /ping
            port: 8080
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 5
        resources:
          limits:
            memory: 1Gi
            cpu: 500m
          requests:
            memory: 512Mi
            cpu: 250m
```

### Docker Swarm
```bash
# Deploy to swarm
docker service create \
  --name functions \
  --replicas 3 \
  --publish 8080:8080 \
  --env NODE_ENV=production \
  --constraint 'node.role == worker' \
  app-oint/functions:latest

# Update service
docker service update --image app-oint/functions:v1.1.0 functions
```

## 📊 Monitoring

### Logging
```bash
# Follow logs
docker logs -f functions-prod

# View last 100 lines
docker logs --tail 100 functions-prod

# Export logs
docker logs functions-prod > functions.log 2>&1
```

### Metrics
```bash
# Container metrics
docker stats functions-prod

# Resource usage
docker exec functions-prod top

# Process list
docker exec functions-prod ps aux
```

### Application Metrics
- Health status: `GET /health`
- Service status: `GET /api/status`
- Custom metrics can be added to these endpoints

## 🔒 Security

### Best Practices
- Runs as non-root user (`functions:nodejs`)
- Uses Alpine Linux base image for minimal attack surface
- Multi-stage build reduces final image size
- No sensitive data in environment variables (use secrets)
- Regular base image updates

### Security Scanning
```bash
# Scan with Docker Scout (if available)
docker scout cves app-oint/functions:latest

# Scan with Trivy
trivy image app-oint/functions:latest

# Scan with Snyk
snyk container test app-oint/functions:latest
```

## 📚 Additional Resources

- [Node.js Docker Best Practices](https://nodejs.org/en/docs/guides/nodejs-docker-webapp/)
- [Docker Multi-stage Builds](https://docs.docker.com/develop/dev-best-practices/)
- [Express.js Production Best Practices](https://expressjs.com/en/advanced/best-practice-performance.html)

## 🆘 Support

For issues specific to the Functions service:
1. Check container logs: `docker logs functions-prod`
2. Verify environment variables: `docker exec functions-prod env`
3. Test health endpoints: `curl http://localhost:8080/health`
4. Check resource usage: `docker stats functions-prod`

For general Docker issues, consult the Docker documentation or your platform-specific guides.