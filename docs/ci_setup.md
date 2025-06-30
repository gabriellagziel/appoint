# Continuous Integration Setup

## Overview

CI runs on GitHub Actions using the `ci.yml` workflow. The workflow installs Flutter and Dart inside a container image and caches the SDK and pub packages for faster builds.

## Installing Dependencies

The workflow uses the [`subosito/flutter-action`](https://github.com/subosito/flutter-action) to install Flutter 3.32.0. Dart is available from the same SDK so tests can run with either the `dart` or `flutter` command.

Cached directories:

- `~/.flutter` – Flutter SDK
- `~/.pub-cache` – packages fetched with `dart pub get`

Caching is configured with `actions/cache` using keys that include the workflow files and `pubspec.yaml`. When dependencies change, a new cache is created automatically.

## Running Tests in CI

Tests are executed with coverage enabled:

```bash
dart test --coverage
flutter test integration_test
```

Firebase emulators for Auth, Firestore and Storage are started in the background before tests run. Network allowlists are verified so the workflow can reach `pub.dev`, `storage.googleapis.com` and other required domains.

## Offline Builds

Some jobs run with the `--offline` flag to ensure reproducible builds. The `PUB_HOSTED_URL` environment variable is set to a local Verdaccio server so that pub packages are installed from cache without external network access.
