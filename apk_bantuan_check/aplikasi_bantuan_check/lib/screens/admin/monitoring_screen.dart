import 'package:aplikasi_bantuan_check/models/submission_model.dart';
import 'package:aplikasi_bantuan_check/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Ini akan bekerja setelah 'flutter pub get intl'
import 'package:url_launcher/url_launcher.dart';

class MonitoringScreen extends StatefulWidget {
  const MonitoringScreen({super.key});

  @override
  State<MonitoringScreen> createState() => _MonitoringScreenState();
}

class _MonitoringScreenState extends State<MonitoringScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<SubmissionModel> _submissions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _firestoreService.getSubmissions().listen((data) {
      // Tambahkan pengecekan mounted sebelum setState
      if (mounted) {
        // <--- PERUBAHAN DI SINI
        setState(() {
          _submissions = data;
          _isLoading = false;
        });
      }
    }).onError((error) {
      // Tambahkan pengecekan mounted sebelum setState
      if (mounted) {
        // <--- PERUBAHAN DI SINI
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error memuat data monitoring: $error')),
        );
      }
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Diterima':
        return Colors.green;
      case 'Ditolak':
        return Colors.red;
      case 'Pending':
      default:
        return Colors.orange;
    }
  }

  Future<void> _launchURL(String url) async {
    // Tambahkan pengecekan if (!mounted) return; di awal fungsi async yang menggunakan context
    if (!mounted) return; // <--- PERUBAHAN DI SINI
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      if (mounted) {
        // <--- PERUBAHAN DI SINI
        throw 'Could not launch $url';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Monitoring Data Penerima')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _submissions.isEmpty
              ? const Center(child: Text('Belum ada data pengajuan.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _submissions.length,
                  itemBuilder: (context, index) {
                    final submission = _submissions[index];
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
                              // Gunakan NumberFormat secara langsung
                              'Jumlah: Rp${NumberFormat('#,##0').format(submission.jumlahPengajuan)}', // <--- SUDAH BENAR
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
                              // Gunakan DateFormat secara langsung
                              'Tanggal: ${DateFormat('dd MMMM HH:mm').format(submission.timestamp)}', // <--- SUDAH BENAR
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Text(
                                  'Status: ',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(submission.status),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    submission.status,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (submission.documentUrl != null &&
                                submission.documentUrl!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: TextButton.icon(
                                  onPressed: () =>
                                      _launchURL(submission.documentUrl!),
                                  icon: const Icon(Icons.file_present),
                                  label: const Text('Lihat Dokumen'),
                                ),
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
