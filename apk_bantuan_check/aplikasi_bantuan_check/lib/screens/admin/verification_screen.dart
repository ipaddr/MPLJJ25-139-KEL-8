import 'package:aplikasi_bantuan_check/app_constants.dart';
import 'package:aplikasi_bantuan_check/models/submission_model.dart';
import 'package:aplikasi_bantuan_check/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // <--- PASTIKAN INI TERIMPORT
import 'package:url_launcher/url_launcher.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<SubmissionModel> _pendingSubmissions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _firestoreService.getSubmissions().listen((data) {
      if (mounted) {
        // <--- TAMBAHKAN CHECK MOUNTED
        setState(() {
          _pendingSubmissions = data
              .where((s) => s.status == AppConstants.statusPending)
              .toList();
          _isLoading = false;
        });
      }
    }).onError((error) {
      if (mounted) {
        // <--- TAMBAHKAN CHECK MOUNTED
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error memuat pengajuan untuk verifikasi: $error')),
        );
      }
    });
  }

  Future<void> _updateStatus(String submissionId, String newStatus) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await _firestoreService.updateSubmissionStatus(submissionId, newStatus);
      if (mounted) {
        // <--- TAMBAHKAN CHECK MOUNTED
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Status pengajuan berhasil diperbarui menjadi $newStatus')),
        );
      }
    } catch (e) {
      if (mounted) {
        // <--- TAMBAHKAN CHECK MOUNTED
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui status: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        // <--- TAMBAHKAN CHECK MOUNTED
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _launchURL(String url) async {
    if (!mounted) return; // <--- TAMBAHKAN CHECK MOUNTED
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      if (mounted) {
        // <--- TAMBAHKAN CHECK MOUNTED
        throw 'Could not launch $url';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verifikasi dan Validasi')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pendingSubmissions.isEmpty
              ? const Center(
                  child: Text('Tidak ada pengajuan yang perlu diverifikasi.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _pendingSubmissions.length,
                  itemBuilder: (context, index) {
                    final submission = _pendingSubmissions[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pengaju UID: ${submission.userId}',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Jenis Bantuan: ${submission.jenisBantuan}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Jumlah: Rp${NumberFormat('#,##0').format(submission.jumlahPengajuan)}', // <--- HARUSNYA INI BEKERJA SETELAH INTL
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Alamat: ${submission.alamat}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'No. Rekening: ${submission.noRekening}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tanggal Pengajuan: ${DateFormat('dd MMMM HH:mm').format(submission.timestamp)}', // <--- HARUSNYA INI BEKERJA SETELAH INTL
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                            ),
                            if (submission.documentUrl != null &&
                                submission.documentUrl!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: TextButton.icon(
                                  onPressed: () =>
                                      _launchURL(submission.documentUrl!),
                                  icon: const Icon(Icons.file_present),
                                  label: const Text('Lihat Dokumen Pendukung'),
                                ),
                              ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                  onPressed: () => _updateStatus(submission.id,
                                      AppConstants.statusAccepted),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green),
                                  child: const Text('TERIMA',
                                      style: TextStyle(color: Colors.white)),
                                ),
                                ElevatedButton(
                                  onPressed: () => _updateStatus(submission.id,
                                      AppConstants.statusRejected),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red),
                                  child: const Text('TOLAK',
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
