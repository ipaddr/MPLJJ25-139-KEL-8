import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String role;
  final String? name; // Pastikan ini ada
  final String? nik; // Pastikan ini ada

  UserModel({
    required this.uid,
    required this.email,
    required this.role,
    this.name, // Pastikan ini ada di konstruktor
    this.nik, // Pastikan ini ada di konstruktor
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      role: data['role'] ?? 'masyarakat',
      name: data['name'], // Pastikan field 'name' dibaca dari Firestore
      nik: data['nik'], // Pastikan field 'nik' dibaca dari Firestore
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'role': role,
      'name': name, // Pastikan field 'name' ditulis ke Firestore
      'nik': nik, // Pastikan field 'nik' ditulis ke Firestore
    };
  }
}
