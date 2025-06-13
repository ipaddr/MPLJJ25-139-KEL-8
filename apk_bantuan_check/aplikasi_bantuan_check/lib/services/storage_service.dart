import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Mengupload file ke Firebase Storage
  Future<String?> uploadFile(File file, String path) async {
    try {
      final ref = _storage.ref().child(path);
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } on FirebaseException catch (e) {
      print("StorageService - Upload File Error: ${e.code} - ${e.message}");
      rethrow;
    } catch (e) {
      print("StorageService - General Upload Error: $e");
      return null;
    }
  }
}
