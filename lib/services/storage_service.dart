import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

/// Simple wrapper around [FirebaseStorage] that connects to the emulator
/// when running in tests.
class StorageService {
  StorageService({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance {
    _connectToEmulatorIfNeeded();
  }
  final FirebaseStorage _storage;

  void _connectToEmulatorIfNeeded() {
    const isTest = bool.fromEnvironment('FLUTTER_TEST');
    final host = Platform.environment['FIREBASE_STORAGE_EMULATOR_HOST'];
    if (isTest && host != null && host.contains(':')) {
      final parts = host.split(':');
      final port = int.tryParse(parts[1]) ?? 9199;
      _storage.useStorageEmulator(parts[0], port);
    }
  }

  Future<String> uploadFile(File file, final String path) async {
    final ref = _storage.ref().child(path);
    await ref.putFile(file);
    return ref.getDownloadURL();
  }
}
