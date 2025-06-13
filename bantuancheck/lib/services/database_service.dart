import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/bantuan_model.dart';
import '../models/pengajuan_model.dart';
import '../models/edukasi_model.dart';
import '../models/user_model.dart'; // pastikan file ini ada

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get all bantuan
  Future<List<Bantuan>> getBantuanList() async {
    final snapshot = await _db.collection('bantuan').get();
    return snapshot.docs.map((doc) => Bantuan.fromJson(doc.data())).toList();
  }

  // Submit pengajuan
  Future<void> submitPengajuan(Pengajuan pengajuan) async {
    await _db.collection('pengajuan').add(pengajuan.toJson());
  }

  // Get edukasi list
  Future<List<Edukasi>> getEdukasiList() async {
    final snapshot = await _db.collection('edukasi').get();
    return snapshot.docs.map((doc) => Edukasi.fromJson(doc.data())).toList();
  }

  // Get pengajuan by user
  Future<List<Pengajuan>> getPengajuanByUserId(int userId) async {
    final snapshot = await _db
        .collection('pengajuan')
        .where('user_id', isEqualTo: userId)
        .get();
    return snapshot.docs.map((doc) => Pengajuan.fromJson(doc.data())).toList();
  }

  // Get user data
  Future<UserModel?> getUserData(int userId) async {
    final doc = await _db.collection('users').doc(userId.toString()).get();
    if (doc.exists) {
      return UserModel.fromJson(doc.data()!);
    }
    return null;
  }
}
