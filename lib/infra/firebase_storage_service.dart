import 'dart:io';

class FirebaseStorageService {
  Future<String> uploadFile(File file, final String path) async {
    // In production this would upload to Firebase Storage.
    return path;
  }
}
