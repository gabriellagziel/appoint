# App-Oint — Personal Web/PWA Home

## Run Modes
- Dummy (default, offline-friendly)
  ```bash
  flutter run -d web-server --web-port 3004 --web-hostname localhost -t lib/main.dart
  ```

- Real data (Firestore)

  ```bash
  flutter clean && flutter pub get
  flutter run -d chrome -t lib/main.dart --dart-define=USE_REAL_AGENDA=true
  ```

  Feature flag: `USE_REAL_AGENDA=true` switches providers to Firestore.

## Tests & Analyze

```bash
flutter analyze
flutter test test/features/home/greeting_test.dart \
             test/features/home/home_landing_screen_test.dart \
             test/features/home/midnight_edge_test.dart
```

## Release Smoke

```bash
flutter build web --no-tree-shake-icons --release
cd build/web && python3 -m http.server 5000
# http://localhost:5000
```

## Preview Mobile Flow

```bash
./tool/build_release.sh
./tool/serve_release.sh 3012
# Open:
# Desktop: http://localhost:3012/?preview=mobile#/home
# Phone:   http://<your-ip>:3012/?preview=mobile#/home

# If LAN blocked:
# In one terminal: ./tool/serve_release.sh 3012
# In another:      ./tool/tunnel.sh 3012  # open the https URL
```

## Notes

- Agenda merge: reminders tie-break meetings when same minute.
- Today empty-state shows friendly CTA.
- Timestamps read as UTC, displayed local (`toLocal()`).
- Providers are `autoDispose` to avoid stale listeners.
- If web plugins complain: keep Dummy run or strip messaging/storage temporarily for web-only runs.
