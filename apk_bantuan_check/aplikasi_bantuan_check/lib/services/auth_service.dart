import 'package:aplikasi_bantuan_check/app_constants.dart';
import 'package:aplikasi_bantuan_check/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print("AuthService - Sign In Error: ${e.message}");
      rethrow;
    } catch (e) {
      print("AuthService - Sign In General Error: $e");
      rethrow;
    }
  }

  // REVISI: Tambahkan parameter name dan nik
  Future<UserCredential?> registerWithEmailAndPassword(
      String email, String password, String role,
      {String? name, String? nik}) async {
    // Tambahkan
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        await _firestore
            .collection(AppConstants.usersCollection)
            .doc(userCredential.user!.uid)
            .set({
          'email': email,
          'role': role,
          'uid': userCredential.user!.uid,
          'createdAt': FieldValue.serverTimestamp(),
          'name': name, // Simpan nama
          'nik': nik, // Simpan NIK
        });
      }
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print("AuthService - Register Error: ${e.message}");
      rethrow;
    } catch (e) {
      print("AuthService - Register General Error: $e");
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print("AuthService - Sign Out Error: $e");
    }
  }

  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print("AuthService - Get User Data Error: $e");
      return null;
    }
  }
}
