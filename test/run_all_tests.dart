import 'package:flutter_test/flutter_test.dart';

// import 'booking_service_test.dart' as booking_service_test;
import 'features/admin/admin_broadcast_screen_test.dart'
    as admin_broadcast_screen_test;
import 'features/auth/login_screen_test.dart' as login_screen_test;
import 'firebase_test_helper.dart';
import 'models/admin_broadcast_message_test.dart' as admin_broadcast_test;
import 'models/appointment_test.dart' as appointment_test;
// Import all test files
import 'models/user_profile_test.dart' as user_profile_test;
import 'services/admin_service_test.dart' as admin_service_test;
import 'services/broadcast_service_test.dart' as broadcast_service_test;
import 'test_config.dart';

void main() {
  setupTestConfig();

  setUpAll(() async {
    await initializeTestFirebase();
  });

  group('All Tests', () {
    group('Model Tests', () {
      user_profile_test.main();
      appointment_test.main();
      admin_broadcast_test.main();
    });

    group('Service Tests', () {
      admin_service_test.main();
      broadcast_service_test.main();
      // booking_service_test.main();
    });

    group('UI Component Tests', () {
      admin_broadcast_screen_test.main();
      login_screen_test.main();
    });
  });
}
