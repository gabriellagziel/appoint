# App-Oint Microservices Quick Start Guide

## 🚀 Getting Started in 5 Minutes

### Prerequisites
- Docker Engine 20.10+
- Docker Compose 2.0+
- Node.js 18+ (for local development)

### 1. Environment Setup
```bash
# Clone the repository (if not already done)
# cd app-oint

# Copy environment file
cp .env.example .env

# Edit .env with your configuration
nano .env
```

### 2. Start All Services
```bash
# Start all services in background
docker-compose up -d

# Or start with logs visible
docker-compose up

# Start only specific services
docker-compose up functions dashboard marketing
```

### 3. Verify Services
```bash
# Check service status
docker-compose ps

# Check logs for specific service
docker-compose logs -f functions

# Health checks
curl http://localhost:5001/health  # API
curl http://localhost:3000         # Dashboard  
curl http://localhost:8080         # Marketing
curl http://localhost:8081         # Business
curl http://localhost:8082         # Admin
```

## 🌐 Service URLs

| Service | URL | Purpose |
|---------|-----|---------|
| API/Functions | http://localhost:5001 | Backend API |
| Dashboard | http://localhost:3000 | Analytics Dashboard |
| Marketing | http://localhost:8080 | Public Website |
| Business Portal | http://localhost:8081 | Business Interface |
| Admin Panel | http://localhost:8082 | Admin Interface |
| API Docs | http://localhost:5001/api-docs | Swagger UI |
| Grafana | http://localhost:3001 | Monitoring |
| Prometheus | http://localhost:9090 | Metrics |

## 🔧 Development Commands

### Individual Service Development
```bash
# Dashboard development (with hot reload)
cd dashboard && npm run dev

# Functions development  
cd functions && npm run dev

# Marketing development
cd marketing && npm run dev
```

### Docker Commands
```bash
# Build all services
docker-compose build

# Rebuild specific service
docker-compose build dashboard

# View service logs
docker-compose logs -f dashboard

# Stop all services
docker-compose down

# Stop and remove volumes
docker-compose down -v
```

### Service Management
```bash
# Scale specific service
docker-compose up --scale dashboard=3

# Restart service
docker-compose restart functions

# Execute command in running container
docker-compose exec functions npm test
```

## 🛠️ Common Tasks

### Database Operations
```bash
# Connect to PostgreSQL
docker-compose exec postgres psql -U postgres -d app_oint

# Backup database
docker-compose exec postgres pg_dump -U postgres app_oint > backup.sql

# View Redis data
docker-compose exec redis redis-cli
```

### Testing
```bash
# Run tests for all services
./scripts/run-all-tests.sh

# Run specific service tests
cd functions && npm test
cd dashboard && npm test
```

### Monitoring
```bash
# View Grafana dashboards
open http://localhost:3001
# Login: admin/admin

# View Prometheus metrics
open http://localhost:9090

# View distributed traces
open http://localhost:16686
```

## 🔍 Troubleshooting

### Port Conflicts
```bash
# Find processes using ports
lsof -i :3000
lsof -i :5001

# Kill process
kill -9 <PID>
```

### Container Issues
```bash
# Remove all containers and start fresh
docker-compose down -v
docker system prune -f
docker-compose up --build

# Check container resources
docker stats

# Access container shell
docker-compose exec dashboard sh
```

### Service Communication
```bash
# Test API from dashboard container
docker-compose exec dashboard curl http://functions:5001/health

# Check network connectivity
docker network ls
docker network inspect app-oint_app-oint-network
```

## 📝 Environment Variables

### Key Variables to Configure
```bash
# In .env file:
NODE_ENV=development
DATABASE_URL=postgresql://postgres:postgres@postgres:5432/app_oint
JWT_SECRET=your-secret-key
FIREBASE_PROJECT_ID=your-project-id
STRIPE_SECRET_KEY=your-stripe-key
```

### Service-Specific Variables
- **functions/.env** - API configuration
- **dashboard/.env.local** - Dashboard settings  
- **marketing/.env.local** - Marketing site config

## 🚀 Production Deployment

### Build Production Images
```bash
# Build all production images
docker-compose -f docker-compose.yml -f docker-compose.prod.yml build

# Tag for registry
docker tag app-oint/functions:latest your-registry.com/app-oint/functions:latest
```

### Deploy to Staging
```bash
# Set production environment
export NODE_ENV=production

# Deploy to staging
docker-compose -f docker-compose.prod.yml up -d
```

## 📊 Monitoring & Health Checks

### Health Check Endpoints
- Functions: `GET /health`
- Dashboard: `GET /api/health`  
- Marketing: `GET /api/health`

### Metrics Collection
- Prometheus: http://localhost:9090
- Application metrics: `GET /metrics`
- Container metrics: `docker stats`

## 🆘 Support

### Common Issues
1. **Port conflicts** - Change ports in docker-compose.yml
2. **Database connection** - Check DATABASE_URL in .env
3. **Service communication** - Verify service names in docker-compose.yml
4. **Memory issues** - Increase Docker memory limits

### Getting Help
- Check service logs: `docker-compose logs <service>`
- Review environment variables in .env files
- Verify service dependencies in docker-compose.yml
- Consult service-specific DOCKER_USAGE.md files

---

## 🎯 Next Steps

1. **Configure your .env file** with real credentials
2. **Start development** on individual services
3. **Set up CI/CD pipelines** for automated testing
4. **Configure monitoring** dashboards in Grafana
5. **Plan production deployment** strategy

**Happy coding! 🚀**