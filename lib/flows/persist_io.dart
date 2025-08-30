import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'flow_engine.dart';

abstract class PersistBackend {
  static Future<void> save(FlowEngine e, {required String key}) async {
    final sp = await SharedPreferences.getInstance();
    final s = jsonEncode({'i': e.index, 'slots': e.slots});
    await sp.setString(key, s);
  }

  static Future<bool> restore(FlowEngine e, {required String key}) async {
    final sp = await SharedPreferences.getInstance();
    final s = sp.getString(key);
    if (s == null) return false;
    final m = jsonDecode(s) as Map<String, dynamic>;
    final i = (m['i'] as num?)?.toInt() ?? 0;
    final slots = (m['slots'] as Map?)?.cast<String, String>() ?? {};
    e.slots
      ..clear()
      ..addAll(slots);
    while (e.index < i && !e.isLast) e.next();
    return true;
  }

  static Future<void> clear({required String key}) async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(key);
  }
}
