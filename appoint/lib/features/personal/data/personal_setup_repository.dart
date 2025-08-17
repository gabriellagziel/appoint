import 'package:shared_preferences/shared_preferences.dart';

class PersonalSetupRepository {
  static const _key = 'hasCompletedPersonalSetup';

  Future<bool> getHasCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  Future<void> setCompleted(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value);
  }
}







