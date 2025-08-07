# Dashboard Service Docker Usage Guide

## 🚀 Quick Start

### Prerequisites
- Docker Engine 20.10+
- Docker Compose 2.0+
- Node.js 18+ (for local development)

## 🔧 Local Development

### 1. Environment Setup
Create your environment file:
```bash
cp .env.example .env.local
```

### 2. Development with Docker
```bash
# Build and run in development mode
docker-compose up dashboard-dev

# Run with hot reloading
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up dashboard
```

### 3. Traditional Local Development
```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Open browser
open http://localhost:3000
```

## 🐳 Docker Commands

### Building the Image
```bash
# Build production image
docker build -t app-oint/dashboard:latest .

# Build with build args
docker build \
  --build-arg NODE_ENV=production \
  --build-arg PORT=3000 \
  -t app-oint/dashboard:latest .
```

### Running Containers

#### Development Mode
```bash
# Run with environment variables
docker run -d \
  --name dashboard-dev \
  -p 3000:3000 \
  -e NODE_ENV=development \
  -e DATABASE_URL=your_database_url \
  -e API_BASE_URL=http://functions:5001 \
  app-oint/dashboard:latest

# Run with mounted volume for development
docker run -d \
  --name dashboard-dev \
  -p 3000:3000 \
  -v $(pwd):/app \
  -v /app/node_modules \
  app-oint/dashboard:dev
```

#### Production Mode
```bash
# Run production container
docker run -d \
  --name dashboard-prod \
  -p 3000:3000 \
  -e NODE_ENV=production \
  -e DATABASE_URL=your_database_url \
  -e API_BASE_URL=http://functions:5001 \
  --restart unless-stopped \
  app-oint/dashboard:latest
```

## 📋 Docker Compose Usage

### Basic Usage
```bash
# Start all services
docker-compose up

# Start in background
docker-compose up -d

# Start specific service
docker-compose up dashboard

# View logs
docker-compose logs dashboard

# Stop services
docker-compose down
```

### Development Environment
```yaml
# docker-compose.dev.yml
version: '3.8'
services:
  dashboard:
    build:
      context: .
      target: development
    volumes:
      - .:/app
      - /app/node_modules
    environment:
      - NODE_ENV=development
      - WATCHPACK_POLLING=true
    ports:
      - "3000:3000"
```

### Production Environment
```yaml
# docker-compose.prod.yml
version: '3.8'
services:
  dashboard:
    build:
      context: .
      target: production
    environment:
      - NODE_ENV=production
      - DATABASE_URL=${DATABASE_URL}
      - API_BASE_URL=${API_BASE_URL}
    ports:
      - "3000:3000"
    restart: unless-stopped
```

## 🌍 Environment Variables

### Required Variables
| Variable | Description | Example |
|----------|-------------|---------|
| `NODE_ENV` | Environment mode | `production` |
| `DATABASE_URL` | Database connection string | `postgresql://user:pass@host:5432/db` |
| `API_BASE_URL` | Functions API base URL | `http://functions:5001` |

### Optional Variables
| Variable | Description | Default | Example |
|----------|-------------|---------|---------|
| `PORT` | Service port | `3000` | `3000` |
| `HOST` | Service host | `0.0.0.0` | `0.0.0.0` |
| `NEXT_PUBLIC_API_URL` | Public API URL | - | `https://api.app-oint.com` |

## 🔍 Health Checks

The container includes built-in health checks:
```bash
# Check container health
docker inspect dashboard --format='{{.State.Health.Status}}'

# View health check logs
docker inspect dashboard --format='{{range .State.Health.Log}}{{.Output}}{{end}}'
```

Health check endpoint: `GET /api/health`

## 🛠️ Troubleshooting

### Common Issues

#### Port Already in Use
```bash
# Find process using port 3000
lsof -i :3000

# Kill process
kill -9 <PID>
```

#### Container Won't Start
```bash
# Check logs
docker logs dashboard

# Debug with shell access
docker run -it --entrypoint /bin/sh app-oint/dashboard:latest
```

#### Permission Issues
```bash
# Fix ownership (Linux/macOS)
sudo chown -R $(whoami):$(whoami) .

# Run with correct user
docker run --user $(id -u):$(id -g) app-oint/dashboard:latest
```

### Performance Optimization

#### Memory Usage
```bash
# Limit memory usage
docker run -m 512m app-oint/dashboard:latest

# Monitor memory usage
docker stats dashboard
```

#### CPU Usage
```bash
# Limit CPU usage
docker run --cpus="1.5" app-oint/dashboard:latest
```

## 🚢 Deployment

### Container Registry
```bash
# Tag for registry
docker tag app-oint/dashboard:latest your-registry.com/app-oint/dashboard:latest

# Push to registry
docker push your-registry.com/app-oint/dashboard:latest

# Pull and run
docker pull your-registry.com/app-oint/dashboard:latest
docker run -d your-registry.com/app-oint/dashboard:latest
```

### Kubernetes Deployment
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: dashboard
spec:
  replicas: 3
  selector:
    matchLabels:
      app: dashboard
  template:
    metadata:
      labels:
        app: dashboard
    spec:
      containers:
      - name: dashboard
        image: app-oint/dashboard:latest
        ports:
        - containerPort: 3000
        env:
        - name: NODE_ENV
          value: "production"
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              name: dashboard-secrets
              key: database-url
```

## 📊 Monitoring

### Logging
```bash
# Follow logs
docker logs -f dashboard

# View last 100 lines
docker logs --tail 100 dashboard

# Export logs
docker logs dashboard > dashboard.log 2>&1
```

### Metrics
- Container metrics via `docker stats`
- Application metrics via `/api/metrics` endpoint
- Health status via `/api/health` endpoint

## 🔒 Security

### Best Practices
- Run as non-root user (implemented in Dockerfile)
- Use specific image tags, not `latest` in production
- Regularly update base images
- Scan images for vulnerabilities
- Use secrets management for sensitive data

### Security Scanning
```bash
# Scan with Docker Scout (if available)
docker scout cves app-oint/dashboard:latest

# Scan with Trivy
trivy image app-oint/dashboard:latest
```

## 📚 Additional Resources

- [Next.js Docker Documentation](https://nextjs.org/docs/deployment#docker-image)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [App-Oint Architecture Guide](../docs/architecture.md)

## 🆘 Support

For issues specific to the Dashboard service:
1. Check container logs: `docker logs dashboard`
2. Verify environment variables
3. Test health check endpoint
4. Review application-specific logs in `/app/logs`

For general Docker issues, consult the Docker documentation or your platform-specific guides.