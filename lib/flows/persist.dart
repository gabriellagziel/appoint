import 'flow_engine.dart';
import 'persist_web.dart' if (dart.library.io) 'persist_io.dart';

class FlowPersist {
  static Future<void> save(FlowEngine e, {String key = 'flow_state'}) =>
      PersistBackend.save(e, key: key);
  static Future<bool> restore(FlowEngine e, {String key = 'flow_state'}) =>
      PersistBackend.restore(e, key: key);
  static Future<void> clear({String key = 'flow_state'}) =>
      PersistBackend.clear(key: key);
}
