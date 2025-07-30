# Testing and Deployment

## Unit
Run `scripts/run_tests.sh unit` to execute unit tests.
Ensure the Firebase emulator suite is running with Storage enabled:

```bash
export FIREBASE_STORAGE_EMULATOR_HOST="localhost:9199"
firebase emulators:start --only auth,firestore,storage &
```

## Integration
Run `scripts/run_tests.sh integration` to execute integration tests.

## Smoke
Run `scripts/smoke_test.sh` after deployment.

## CI
CI runs `scripts/run_tests.sh all` in `.github/workflows/ci.yml`.
