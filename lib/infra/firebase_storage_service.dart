import 'dart:io';

class FirebaseStorageService {
  Future<String> uploadFile(final File file, final String path) async {
    // In production this would upload to Firebase Storage.
    return path;
  }
}
