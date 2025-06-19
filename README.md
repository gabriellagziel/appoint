# Appoint

Appointment scheduling app built with Flutter.

## Setup

1. **Flutter version**  
   Ensure you have Flutter 3.3+ installed.

2. **Dependencies & Codegen**  
   
```bash
   flutter pub get
   ./tool/codegen.sh

```

3. **Run & Test**

   
```bash
   flutter run
   flutter test
```

## Contribution Guidelines

1. Run `flutter pub get` before development.
2. Execute `flutter analyze` and `flutter test` before submitting a PR.


## CI

Our GitHub Actions pipeline (`.github/workflows/flutter.yml`) runs on every push/PR to `main`:


* `flutter pub get`

* `tool/codegen.sh`

* `flutter analyze`

* `flutter test --coverage`

* Uploads coverage to Codecov
