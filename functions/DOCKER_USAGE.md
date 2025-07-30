# Functions/API Service - Docker Usage Guide

## 🐳 Overview

This guide provides instructions for building and running the Functions/API service using Docker. The service is built with Node.js 22, TypeScript, and includes comprehensive production-ready features.

## 📋 Prerequisites

- Docker 20.10+ installed
- Docker Compose 2.0+ (for multi-service setup)
- Basic knowledge of Node.js and Firebase Functions

## 🏗️ Building the Docker Image

### Local Build

```bash
# Navigate to the functions directory
cd functions/

# Build the Docker image
docker build -t app-oint-functions:latest .

# Build with a specific tag
docker build -t app-oint-functions:v1.0.0 .

# Build for different architectures (if needed)
docker buildx build --platform linux/amd64,linux/arm64 -t app-oint-functions:latest .
```

### Build with Custom Node Version (if needed)

```bash
# Override the base image version
docker build --build-arg NODE_VERSION=20-alpine -t app-oint-functions:node20 .
```

## 🚀 Running the Container

### Basic Run

```bash
# Run the container
docker run -p 8080:8080 app-oint-functions:latest

# Run with environment variables
docker run -p 8080:8080 \
  -e NODE_ENV=production \
  -e FIREBASE_PROJECT_ID=your-project-id \
  app-oint-functions:latest

# Run in detached mode
docker run -d -p 8080:8080 --name functions-api app-oint-functions:latest
```

### Run with Environment File

```bash
# Create a .env file with your environment variables
cat > .env << EOF
NODE_ENV=production
PORT=8080
FIREBASE_PROJECT_ID=your-project-id
STRIPE_SECRET_KEY=your-stripe-key
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@domain.com
SMTP_PASS=your-password
EOF

# Run with environment file
docker run -p 8080:8080 --env-file .env app-oint-functions:latest
```

### Run with Volume Mounts (for logs or data)

```bash
# Create a logs directory
mkdir -p ./logs

# Run with volume mount for logs
docker run -p 8080:8080 \
  -v $(pwd)/logs:/app/logs \
  app-oint-functions:latest
```

## 📊 Health Check & Monitoring

```bash
# Check container health
docker ps
docker inspect app-oint-functions | grep -A 5 Health

# View logs
docker logs functions-api
docker logs -f functions-api  # Follow logs

# Execute commands inside the container
docker exec -it functions-api sh
docker exec -it functions-api npm run test
```

## 🔧 Docker Compose Integration

### Basic docker-compose.yml

```yaml
version: '3.8'

services:
  functions-api:
    build: 
      context: ./functions
      dockerfile: Dockerfile
    ports:
      - "8080:8080"
    environment:
      - NODE_ENV=production
      - FIREBASE_PROJECT_ID=${FIREBASE_PROJECT_ID}
      - STRIPE_SECRET_KEY=${STRIPE_SECRET_KEY}
    volumes:
      - ./logs:/app/logs
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8080/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 30s

  # Add other services here (marketing, dashboard, etc.)
  marketing:
    build: ./marketing
    ports:
      - "3000:8080"
    depends_on:
      - functions-api

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data

volumes:
  redis_data:
```

### Advanced docker-compose with Database

```yaml
version: '3.8'

services:
  functions-api:
    build: 
      context: ./functions
      dockerfile: Dockerfile
    ports:
      - "8080:8080"
    environment:
      - NODE_ENV=production
      - DATABASE_URL=postgresql://user:password@postgres:5432/appoint
      - REDIS_URL=redis://redis:6379
    depends_on:
      - postgres
      - redis
    volumes:
      - ./logs:/app/logs
    restart: unless-stopped
    networks:
      - app-network

  postgres:
    image: postgres:15-alpine
    environment:
      - POSTGRES_DB=apppoint
      - POSTGRES_USER=user
      - POSTGRES_PASSWORD=password
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"
    networks:
      - app-network

  redis:
    image: redis:7-alpine
    volumes:
      - redis_data:/data
    ports:
      - "6379:6379"
    networks:
      - app-network

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
    depends_on:
      - functions-api
    networks:
      - app-network

volumes:
  postgres_data:
  redis_data:

networks:
  app-network:
    driver: bridge
```

## 🔄 Development Workflow

### Local Development with Hot Reload

```bash
# For development, you might want to mount the source code
docker run -p 8080:8080 \
  -v $(pwd)/src:/app/src \
  -v $(pwd)/package.json:/app/package.json \
  -e NODE_ENV=development \
  app-oint-functions:latest
```

### Running Tests in Container

```bash
# Run tests
docker run --rm app-oint-functions:latest npm test

# Run tests with coverage
docker run --rm app-oint-functions:latest npm run test:coverage

# Run linting
docker run --rm app-oint-functions:latest npm run lint
```

## 🐛 Troubleshooting

### Common Issues

1. **Container won't start**
   ```bash
   # Check logs
   docker logs functions-api
   
   # Check if port is already in use
   lsof -i :8080
   ```

2. **Health check failing**
   ```bash
   # Test health endpoint manually
   curl http://localhost:8080/health
   
   # Check if service is responding
   docker exec functions-api curl localhost:8080/health
   ```

3. **Permission issues**
   ```bash
   # Fix ownership issues
   sudo chown -R $USER:$USER ./logs
   ```

4. **Memory issues**
   ```bash
   # Run with memory limit
   docker run -m 512m -p 8080:8080 app-oint-functions:latest
   
   # Monitor memory usage
   docker stats functions-api
   ```

### Debug Mode

```bash
# Run in debug mode
docker run -p 8080:8080 -p 9229:9229 \
  -e NODE_ENV=development \
  app-oint-functions:latest node --inspect=0.0.0.0:9229 index.js
```

## 🚀 Production Deployment

### Build for Production

```bash
# Build optimized production image
docker build -t app-oint-functions:production \
  --target production \
  --no-cache .

# Tag for registry
docker tag app-oint-functions:production your-registry.com/app-oint-functions:latest

# Push to registry
docker push your-registry.com/app-oint-functions:latest
```

### Production docker-compose

```bash
# Run in production mode
docker-compose -f docker-compose.prod.yml up -d

# Scale the service
docker-compose up -d --scale functions-api=3

# Update service
docker-compose pull functions-api
docker-compose up -d functions-api
```

## 📝 Environment Variables

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `NODE_ENV` | Environment mode | `production` | No |
| `PORT` | Server port | `8080` | No |
| `FIREBASE_PROJECT_ID` | Firebase project identifier | - | Yes |
| `STRIPE_SECRET_KEY` | Stripe API secret key | - | Yes |
| `SMTP_HOST` | Email server host | - | No |
| `SMTP_PORT` | Email server port | `1025` | No |
| `SMTP_USER` | Email username | - | No |
| `SMTP_PASS` | Email password | - | No |
| `DATABASE_URL` | Database connection string | - | No |
| `REDIS_URL` | Redis connection string | - | No |

## 🔍 Container Inspection

```bash
# Inspect the image
docker image inspect app-oint-functions:latest

# Check image size
docker images app-oint-functions

# Analyze image layers
docker history app-oint-functions:latest

# Security scan (if using Docker Scout)
docker scout cves app-oint-functions:latest
```

## 📚 Additional Resources

- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [Node.js Docker Guide](https://nodejs.org/en/docs/guides/nodejs-docker-webapp/)
- [Firebase Functions Documentation](https://firebase.google.com/docs/functions)
- [Docker Compose Reference](https://docs.docker.com/compose/compose-file/)

---

For more information or issues, please refer to the main project documentation or create an issue in the repository.