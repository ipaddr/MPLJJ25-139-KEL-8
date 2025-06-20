import 'package:aplikasi_bantuan_check/models/submission_model.dart';
import 'package:aplikasi_bantuan_check/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
      if (mounted) {
        setState(() {
          _submissions = data;
          _isLoading = false;
        });
      }
    }).onError((error) {
      if (mounted) {
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
        return const Color(0xFF28A745); // Hijau
      case 'Ditolak':
        return Colors.red;
      case 'Pending':
      default:
        return Colors.orange;
    }
  }

  Future<void> _launchURL(String url) async {
    if (!mounted) return;
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      if (mounted) {
        throw 'Could not launch $url';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF0C72C3), // Warna biru latar belakang utama
      body: Stack(
        children: [
          Column(
            children: [
              // Header Kustom
              Container(
                padding: const EdgeInsets.only(
                    top: 60, bottom: 30, left: 20, right: 20),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF9800), // Warna oranye untuk header
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: const Text(
                  'MONITORING\nDATA PENERIMA',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : _submissions.isEmpty
                          ? const Text(
                              'Belum ada data pengajuan yang tersedia.',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                              textAlign: TextAlign.center,
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(24.0),
                              itemCount: _submissions.length,
                              itemBuilder: (context, index) {
                                final submission = _submissions[index];
                                return Card(
                                  color: const Color(
                                      0xFFFFF7E7), // Warna krem/kuning muda untuk kartu
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 8,
                                  margin: const EdgeInsets.only(bottom: 24),
                                  child: Padding(
                                    padding: const EdgeInsets.all(24.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildInfoRow(
                                            'UID Pengaju', submission.userId),
                                        _buildInfoRow('Jenis Bantuan',
                                            submission.jenisBantuan),
                                        _buildInfoRow('Jumlah',
                                            'Rp${NumberFormat('#,##0').format(submission.jumlahPengajuan)}'),
                                        _buildInfoRow(
                                            'Alamat', submission.alamat,
                                            maxLines: 3),
                                        _buildInfoRow('No. Rekening',
                                            submission.noRekening),
                                        _buildInfoRow(
                                            'Tgl. Pengajuan',
                                            DateFormat('dd MMMM HH:mm')
                                                .format(submission.timestamp)),
                                        // Tampilkan keterangan dokumen jika ada
                                        if (submission.keteranganDokumen !=
                                                null &&
                                            submission
                                                .keteranganDokumen!.isNotEmpty)
                                          _buildInfoRow('Keterangan Dokumen',
                                              submission.keteranganDokumen!,
                                              maxLines: 3),

                                        const SizedBox(height: 15),
                                        Row(
                                          children: [
                                            const Text(
                                              'Status: ',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black87),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                              decoration: BoxDecoration(
                                                color: _getStatusColor(
                                                    submission.status),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Text(
                                                submission.status,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (submission.documentUrl != null &&
                                            submission.documentUrl!.isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 12.0),
                                            child: TextButton.icon(
                                              onPressed: () => _launchURL(
                                                  submission.documentUrl!),
                                              icon: const Icon(
                                                  Icons.file_present,
                                                  color: Colors.blueAccent),
                                              label: const Text(
                                                  'Lihat Dokumen Terupload',
                                                  style: TextStyle(
                                                      color:
                                                          Colors.blueAccent)),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                ),
              ),
            ],
          ),
          // Tombol Kembali di kiri bawah
          Positioned(
            bottom: 30,
            left: 24,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Kembali'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFF7E7), // Warna kuning muda
                foregroundColor: Colors.black87, // Teks hitam
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120, // Lebar tetap untuk label
            child: Text('$label:',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}
