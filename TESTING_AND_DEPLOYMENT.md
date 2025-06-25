# Testing and Deployment

## Unit
Run `scripts/run_tests.sh unit` to execute unit tests.

## Integration
Run `scripts/run_tests.sh integration` to execute integration tests.

## Smoke
Run `scripts/smoke_test.sh` after deployment.

## CI
CI runs `scripts/run_tests.sh all` in `.github/workflows/ci.yml`.
