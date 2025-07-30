# AppOint

A comprehensive appointment booking and management platform with separate B2C mobile app and B2B web dashboard, featuring flexible pricing models and map integration.

## 🚀 Quick Start

### With Docker (Recommended)

```bash
# Clone the repository
git clone https://github.com/your-username/appoint.git
cd appoint

# Start all services with Docker Compose
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

**Services will be available at:**
- **Dashboard**: http://localhost:3000
- **API/Functions**: http://localhost:8080
- **Database**: PostgreSQL on localhost:5432
- **Cache**: Redis on localhost:6379

### Traditional Development

1. **Setup Environment**: Run `scripts/setup_env.sh` for local development setup
2. **Install Dependencies**: `flutter pub get`
3. **Run Tests**: `flutter test`
4. **Start Development**: `flutter run`

## 🐳 Docker Development

### Development Mode with Hot Reloading

```bash
# Start in development mode with hot reloading
docker-compose --profile dev up -d

# Or start specific services in dev mode
docker-compose up dashboard-dev functions-dev -d
```

### Environment Configuration

1. Copy environment files:
   ```bash
   cp dashboard/.env.example dashboard/.env
   cp functions/.env.example functions/.env
   ```

2. Update the `.env` files with your configuration values

3. Restart services:
   ```bash
   docker-compose restart
   ```

### Useful Docker Commands

```bash
# View service logs
docker-compose logs dashboard
docker-compose logs functions

# Rebuild services after code changes
docker-compose build dashboard functions

# Reset databases
docker-compose down -v
docker-compose up -d

# Run tests in containers
docker-compose exec dashboard npm test
docker-compose exec functions npm test
```

## 📊 Status

[![CI Pipeline](https://github.com/your-username/appoint/actions/workflows/ci.yml/badge.svg)](https://github.com/your-username/appoint/actions/workflows/ci.yml)
[![Nightly Builds](https://github.com/your-username/appoint/actions/workflows/nightly.yml/badge.svg)](https://github.com/your-username/appoint/actions/workflows/nightly.yml)
[![Codecov](https://codecov.io/gh/your-username/appoint/branch/main/graph/badge.svg)](https://codecov.io/gh/your-username/appoint)

## 📚 Documentation

- **[Feature Inventory](FEATURE_INVENTORY.md)** - Comprehensive list of all App-Oint platform features
- **[Project Documentation](docs/README.md)** - Comprehensive project documentation
- **[Architecture](docs/architecture.md)** - System architecture and design patterns
- **[CI/CD Setup](docs/ci_setup.md)** - Continuous Integration and Deployment guide
- **[Docker Usage - Dashboard](dashboard/DOCKER_USAGE.md)** - Dashboard service Docker guide
- **[Docker Usage - Functions](functions/DOCKER_USAGE.md)** - Functions service Docker guide

## 🛠️ Development

### Prerequisites

- Docker & Docker Compose (recommended)
- Flutter SDK 3.4.0+ (for mobile development)
- Dart SDK 3.4.0+
- Android Studio / Xcode (for mobile development)
- Node.js 22+ (for local development without Docker)

### Local Development (Without Docker)

```bash
# Clone the repository
git clone https://github.com/your-username/appoint.git
cd appoint

# Setup environment
./scripts/setup_env.sh

# Install dependencies
flutter pub get

# Run tests
flutter test

# Start development server
flutter run
```

### Mobile Development

```bash
# Install Flutter dependencies
flutter pub get

# Run Flutter app
flutter run

# Run on specific device
flutter run -d chrome  # Web
flutter run -d android # Android
flutter run -d ios     # iOS
```

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run integration tests
flutter test --tags integration

# Test Docker services
docker-compose exec dashboard npm test
docker-compose exec functions npm test
```

## 📦 Build

### Mobile App

```bash
# Build debug APK
flutter build apk --debug

# Build release APK
flutter build apk --release

# Build for iOS
flutter build ios
```

### Docker Images

```bash
# Build all Docker images
docker-compose build

# Build specific service
docker-compose build dashboard
docker-compose build functions

# Build for production
docker-compose -f docker-compose.yml -f docker-compose.prod.yml build
```

## 🔧 Architecture

This project uses a microservices architecture:

- **Dashboard**: Next.js frontend for admin/business management
- **Functions**: Node.js API service handling business logic
- **Mobile App**: Flutter cross-platform mobile application
- **Database**: PostgreSQL for data persistence
- **Cache**: Redis for session storage and caching

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Quality

- All code must pass static analysis (`flutter analyze`)
- All tests must pass (`flutter test`)
- Docker builds must succeed (`docker-compose build`)
- Code coverage is tracked via Codecov
- PRs require all CI checks to pass before merge

## 💰 Pricing Model

### Personal App (B2C - Mobile)
- **Free Trial**: 5 meetings with full features including maps
- **Ad-Supported**: After 5 meetings, ads shown but no map access
- **Premium**: €4/month via App Store/Google Play
  - Up to 20 meetings per week
  - Full map access
  - Ad-free experience
  - Premium support

### Business Plans (B2B - Web Dashboard)
- **Starter**: Free
  - Unlimited meetings
  - No map access
  - Basic features
- **Professional**: €15/month
  - Unlimited meetings
  - 200 map loads/month included
  - Full branding and analytics
  - Overage: €0.01 per extra map load
- **Business Plus**: €25/month
  - Everything in Professional
  - 500 map loads/month included
  - Advanced analytics and priority support
  - Overage: €0.01 per extra map load

### Special Cases
- Children (minors): Always free, no map access unless parent upgrades
- Business meeting participation: Map access charged to hosting business
- API access: Per-call billing for enterprise customers

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔗 Links

- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Next.js Documentation](https://nextjs.org/docs)
- [Docker Documentation](https://docs.docker.com/)
