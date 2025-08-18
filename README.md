# AppOint

A Flutter mobile application for appointment booking and management with microservices architecture.

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

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔗 Links

- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Next.js Documentation](https://nextjs.org/docs)
- [Docker Documentation](https://docs.docker.com/)

<!-- HOW-WE-SHIP:START -->
## How We Ship

### Required checks (branch protection)
- Only these 3 checks must pass:
  - Flutter (web) build
  - Next.js apps build
  - Cloud Functions compile

Badge:  
[![core-ci](https://github.com/gabriellagziel/appoint/actions/workflows/core-ci.yml/badge.svg)](https://github.com/gabriellagziel/appoint/actions/workflows/core-ci.yml)

### CI pipeline (core-ci)
- Builds Flutter web (analyze, test, build artifact)
- Builds all Next.js apps (marketing, business, enterprise-app, dashboard)
- Compiles Functions (Node 18, CommonJS)
- No deploys from CI; artifacts only

### Environments (Vercel)
- Each app linked to its subdirectory
- Framework: Next.js
- Build: `npm ci && npm run build`
- Output: `.next`
- Env vars set for Preview + Production (see `ops/vercel/README.md`)

### Functions runtime (Firebase)
- `functions/package.json` → `"type": "commonjs"`, `"engines": { "node": "18" }`
- Build locally before deploy:
```bash
cd functions && npm ci && npm run build
```

### Release process

1. Merge PR (core-ci must be green)
2. Tag `vX.Y.Z` from main
3. Deploy Functions first (verify health)
4. Promote Vercel Preview → Production per app

### Quick smoke (per app)

* Homepage 200, key route 200
* Console: no errors
* Env-driven UI value looks sane
* Auth flow OK (if present)
* Critical path works (no 4xx/5xx)

### Rollback

* Vercel: promote previous deployment to Production
* Functions: redeploy previous working build/tag

### Keep it green

* Only core-ci runs on push/PR; all other workflows are manual
* Preview envs in Vercel must mirror prod where applicable
* If CI fails:

  * Flutter: fix `flutter analyze`/tests
  * Next.js: missing env or bad build script
  * Functions: CommonJS + Node 18; fix TS errors

### References

* Exec summary: `ops/audit/EXEC_SUMMARY.md`
* CI: `.github/workflows/core-ci.yml`
* Vercel mapping: `ops/vercel/README.md`

<!-- HOW-WE-SHIP:END -->
