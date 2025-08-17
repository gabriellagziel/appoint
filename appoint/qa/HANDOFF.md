## Handoff — App-Oint (Cursor)

**All green. Ship final QA and prep release:**

- **Run**

  - Dummy:

    ```bash
    flutter run -d web-server --web-port 3004 --web-hostname localhost -t lib/main.dart
    ```
  - Real:

    ```bash
    flutter clean && flutter pub get
    flutter run -d chrome -t lib/main.dart --dart-define=USE_REAL_AGENDA=true
    ```

- **QA**

  ```bash
  flutter analyze
  flutter test test/features/home/greeting_test.dart \
               test/features/home/home_landing_screen_test.dart \
               test/features/home/midnight_edge_test.dart
  ```

- **Functional checks**

  - Skeletons → data OK.
  - Agenda sorted asc; tie-breaker: reminders before meetings when minute equal.
  - No redirect to Groups; first-run intact.
  - Greeting correct by time; midnight edge-case covered (test passes).

- **Release smoke**

  ```bash
  flutter build web --no-tree-shake-icons --release
  cd build/web && python3 -m http.server 5000
  # open http://localhost:5000
  ```

- If Firebase web plugins bark on web-server: use Dummy run, or temporarily remove messaging/storage from `pubspec.yaml` for web-only runs.

If anything regresses, paste logs; I’ll patch.



