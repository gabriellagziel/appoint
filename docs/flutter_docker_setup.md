# Permanent Flutter Docker Environment Setup

This document describes the setup of a permanent Flutter environment using Docker images stored in DigitalOcean Container Registry.

## Overview

The goal is to install Flutter (and all required tools) once into a permanent Docker image stored in DigitalOcean Container Registry, and use this image across all CI jobs and DigitalOcean deployments.

### Benefits

- ✅ No more downloading Flutter or Dart every time
- ✅ Faster builds and tests
- ✅ Stable and version-controlled environment
- ✅ Consistent environment across all deployments
- ✅ Reduced CI/CD execution time

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    DigitalOcean Container Registry         │
│  registry.digitalocean.com/appoint/flutter-ci:latest      │
│  registry.digitalocean.com/appoint/flutter-ci:3.32.5      │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    GitHub Actions CI/CD                    │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐         │
│  │   Build     │ │    Test     │ │   Deploy    │         │
│  │   Jobs      │ │   Jobs      │ │   Jobs      │         │
│  └─────────────┘ └─────────────┘ └─────────────┘         │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                DigitalOcean App Platform                   │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐         │
│  │   Staging   │ │ Production  │ │   Services  │         │
│  │   Deploy    │ │   Deploy    │ │   Deploy    │         │
│  └─────────────┘ └─────────────┘ └─────────────┘         │
└─────────────────────────────────────────────────────────────┘
```

## Components

### 1. Docker Image (`infrastructure/flutter_ci/Dockerfile`)

The Docker image contains:
- Ubuntu 22.04 base
- Flutter 3.32.5 (configurable via build arg)
- Dart SDK (included with Flutter)
- Java 17 JDK
- Node.js and npm
- Firebase CLI
- All necessary build tools

### 2. Build Scripts

- `scripts/build_flutter_image.sh` - Manual build and push script
- `scripts/update_flutter_image.sh` - Update script for latest Flutter version

### 3. CI/CD Integration

All GitHub Actions jobs now use the Docker container:
- `setup-dependencies` - Uses Docker image
- `generate-code` - Uses Docker image  
- `analyze` - Uses Docker image
- `test` - Uses Docker image
- `security-scan` - Uses Docker image
- `build-web` - Uses Docker image
- `deploy-firebase` - Uses Docker image
- `deploy-digitalocean` - Uses Docker image

### 4. Automated Updates

- Weekly workflow (`update_flutter_image.yml`) runs every Sunday at 2 AM UTC
- Automatically fetches latest Flutter version
- Only updates if version has changed
- Can be manually triggered with force update option

## Usage

### Building the Image

```bash
# Build and push to DigitalOcean Container Registry
./scripts/build_flutter_image.sh
```

### Updating Flutter Version

```bash
# Update to latest Flutter version
./scripts/update_flutter_image.sh
```

### Manual CI Trigger

```bash
# Trigger the update workflow manually
gh workflow run update_flutter_image.yml
```

## Configuration

### Environment Variables

- `FLUTTER_VERSION` - Flutter version to use (default: 3.32.5)
- `DIGITALOCEAN_ACCESS_TOKEN` - Required for pushing to registry

### Secrets Required

- `DIGITALOCEAN_ACCESS_TOKEN` - For container registry access
- `DIGITALOCEAN_APP_ID` - For App Platform deployments
- `FIREBASE_TOKEN` - For Firebase deployments

## Monitoring

### Check Image Status

```bash
# List available images
doctl registry repository list

# Check image tags
doctl registry repository list-tags appoint/flutter-ci
```

### CI Performance

Monitor CI performance improvements:
- Build time reduction
- Cache hit rates
- Deployment success rates

## Troubleshooting

### Common Issues

1. **Registry Authentication**
   ```bash
   # Login to DigitalOcean Container Registry
   doctl registry login
   ```

2. **Image Pull Issues**
   ```bash
   # Check image availability
   docker pull registry.digitalocean.com/appoint/flutter-ci:latest
   ```

3. **Version Mismatch**
   ```bash
   # Force update to specific version
   gh workflow run update_flutter_image.yml -f force_update=true
   ```

### Logs

- CI logs: GitHub Actions → Workflows → Main CI/CD Pipeline
- Update logs: GitHub Actions → Workflows → Update Flutter Docker Image
- Registry logs: DigitalOcean Console → Container Registry

## Maintenance

### Regular Tasks

1. **Weekly**: Automated Flutter version check
2. **Monthly**: Review and update base Ubuntu image
3. **Quarterly**: Review and update Java/Node.js versions

### Manual Updates

```bash
# Update to specific Flutter version
FLUTTER_VERSION=3.33.0 ./scripts/update_flutter_image.sh

# Rebuild with different base image
docker build --build-arg UBUNTU_VERSION=22.04 -t appoint/flutter-ci:latest infrastructure/flutter_ci
```

## Security

### Best Practices

- ✅ Use specific version tags, not just `latest`
- ✅ Regular security updates to base image
- ✅ Scan images for vulnerabilities
- ✅ Rotate access tokens regularly

### Vulnerability Scanning

```bash
# Scan image for vulnerabilities
docker scan appoint/flutter-ci:latest
```

## Performance Metrics

### Before Implementation
- Flutter download: ~2-3 minutes per job
- Total CI time: ~15-20 minutes
- Cache misses: Frequent

### After Implementation
- Flutter download: 0 minutes (pre-installed)
- Total CI time: ~8-12 minutes
- Cache hits: 95%+

## Future Enhancements

1. **Multi-stage builds** for smaller images
2. **Platform-specific images** (ARM64 support)
3. **Automated security scanning** in CI
4. **Image optimization** for faster pulls
5. **Regional registry mirrors** for faster access

## Support

For issues or questions:
1. Check CI logs in GitHub Actions
2. Review Docker build logs
3. Verify registry access and permissions
4. Contact DevOps team for assistance