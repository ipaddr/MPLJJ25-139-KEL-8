import 'package:aplikasi_bantuan_check/app_constants.dart';
import 'package:aplikasi_bantuan_check/models/submission_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Mendapatkan semua pengajuan (untuk admin)
  Stream<List<SubmissionModel>> getSubmissions() {
    return _firestore
        .collection(AppConstants.submissionsCollection)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => SubmissionModel.fromFirestore(doc))
            .toList());
  }

  // Mendapatkan pengajuan berdasarkan userId (untuk masyarakat)
  Stream<List<SubmissionModel>> getUserSubmissions(String userId) {
    return _firestore
        .collection(AppConstants.submissionsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => SubmissionModel.fromFirestore(doc))
            .toList());
  }

  // Menambah pengajuan baru
  Future<void> addSubmission(SubmissionModel submission) async {
    try {
      await _firestore
          .collection(AppConstants.submissionsCollection)
          .add(submission.toFirestore());
    } catch (e) {
      print("FirestoreService - Add Submission Error: $e");
      rethrow;
    }
  }

  // Memperbarui status pengajuan
  Future<void> updateSubmissionStatus(
      String submissionId, String status) async {
    try {
      await _firestore
          .collection(AppConstants.submissionsCollection)
          .doc(submissionId)
          .update({
        'status': status,
      });
    } catch (e) {
      print("FirestoreService - Update Submission Status Error: $e");
      rethrow;
    }
  }

  // Mendapatkan link edukasi
  Stream<List<Map<String, dynamic>>> getEducationLinks() {
    return _firestore
        .collection(AppConstants.educationLinksCollection)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  // Mengirim pesan chat (sederhana, untuk chatbot lokal)
  Future<void> sendChatMessage(
      String userId, String message, String sender) async {
    try {
      await _firestore.collection(AppConstants.chatMessagesCollection).add({
        'userId': userId,
        'message': message,
        'sender': sender, // 'user' or 'chatbot'
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("FirestoreService - Send Chat Message Error: $e");
      rethrow;
    }
  }

  // Mendapatkan riwayat chat untuk user tertentu
  Stream<List<Map<String, dynamic>>> getChatMessages(String userId) {
    return _firestore
        .collection(AppConstants.chatMessagesCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}
