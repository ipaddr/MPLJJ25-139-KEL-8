import 'package:cloud_firestore/cloud_firestore.dart';

class SubmissionModel {
  final String id;
  final String userId;
  final String alamat;
  final String jenisBantuan;
  final int jumlahPengajuan;
  final String noRekening;
  final String?
      documentUrl; // Mungkin tetap ada untuk kompatibilitas, tapi akan null
  final String? keteranganDokumen; // <-- TAMBAHAN: Field baru untuk keterangan
  String status;
  final DateTime timestamp;

  SubmissionModel({
    required this.id,
    required this.userId,
    required this.alamat,
    required this.jenisBantuan,
    required this.jumlahPengajuan,
    required this.noRekening,
    this.documentUrl,
    this.keteranganDokumen, // <-- TAMBAHAN: Konstruktor
    required this.status,
    required this.timestamp,
  });

  factory SubmissionModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return SubmissionModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      alamat: data['alamat'] ?? '',
      jenisBantuan: data['jenisBantuan'] ?? '',
      jumlahPengajuan: data['jumlahPengajuan'] ?? 0,
      noRekening: data['noRekening'] ?? '',
      documentUrl: data['documentUrl'],
      keteranganDokumen: data['keteranganDokumen'], // <-- Ambil dari Firestore
      status: data['status'] ?? 'Pending',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'alamat': alamat,
      'jenisBantuan': jenisBantuan,
      'jumlahPengajuan': jumlahPengajuan,
      'noRekening': noRekening,
      'documentUrl': documentUrl,
      'keteranganDokumen': keteranganDokumen, // <-- Simpan ke Firestore
      'status': status,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
