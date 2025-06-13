import 'package:aplikasi_bantuan_check/app_constants.dart';
import 'package:aplikasi_bantuan_check/models/submission_model.dart';
import 'package:aplikasi_bantuan_check/models/user_model.dart'; // Import UserModel untuk data Nama & NIK
import 'package:aplikasi_bantuan_check/services/firestore_service.dart';
import 'package:aplikasi_bantuan_check/services/auth_service.dart'; // Import AuthService
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckStatusScreen extends StatefulWidget {
  const CheckStatusScreen({super.key});

  @override
  State<CheckStatusScreen> createState() => _CheckStatusScreenState();
}

class _CheckStatusScreenState extends State<CheckStatusScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService(); // Inisialisasi AuthService
  List<SubmissionModel> _submissions = [];
  UserModel? _currentUserModel; // Untuk menyimpan data nama dan NIK
  bool _isLoading = true;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (_currentUserId != null) {
      // Muat data pengguna (nama, NIK)
      _authService.getUserData(_currentUserId!).then((userModel) {
        if (mounted) {
          setState(() {
            _currentUserModel = userModel;
          });
        }
      });

      // Muat data pengajuan
      _firestoreService.getUserSubmissions(_currentUserId!).listen((data) {
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
            SnackBar(content: Text('Error memuat pengajuan: $error')),
          );
        }
      });
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content:
                      Text('Anda harus login untuk melihat status pengajuan.')),
            );
          }
        });
      }
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case AppConstants.statusAccepted:
        return const Color(0xFF28A745); // Hijau dari desain
      case AppConstants.statusRejected:
        return Colors.red;
      case AppConstants.statusPending:
      default:
        return Colors.orange;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case AppConstants.statusAccepted:
        return 'DITERIMA';
      case AppConstants.statusRejected:
        return 'DITOLAK';
      case AppConstants.statusPending:
      default:
        return 'MENUNGGU VERIFIKASI';
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
    if (_currentUserId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Cek Status Pengajuan')),
        body: const Center(child: Text('Mohon login terlebih dahulu.')),
      );
    }

    return Scaffold(
      backgroundColor:
          const Color(0xFF0C72C3), // Warna biru latar belakang utama
      body: Stack(
        // Menggunakan Stack untuk menempatkan tombol kembali di atas
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
                  'STATUS\nBANTUAN USAHA',
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
                      ? const CircularProgressIndicator()
                      : _submissions.isEmpty
                          ? const Text(
                              'Anda belum mengajukan bantuan apapun.',
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
                                  margin: const EdgeInsets.only(
                                      bottom: 24), // Spasi antar kartu
                                  child: Padding(
                                    padding: const EdgeInsets.all(24.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildStatusField(
                                            'Nama',
                                            _currentUserModel?.name ??
                                                'Tidak Ada'),
                                        const SizedBox(height: 15),
                                        _buildStatusField(
                                            'NIK',
                                            _currentUserModel?.nik ??
                                                'Tidak Ada'),
                                        const SizedBox(height: 15),
                                        _buildStatusField(
                                            'No. Rek', submission.noRekening),
                                        const SizedBox(height: 15),
                                        _buildStatusField('Jenis Bantuan',
                                            submission.jenisBantuan),
                                        const SizedBox(height: 15),
                                        // Total Bantuan (dengan highlight oranye)
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 12),
                                          decoration: BoxDecoration(
                                            color: const Color(
                                                0xFFFF9800), // Oranye
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            'Total Bantuan: Rp${NumberFormat('#,##0').format(submission.jumlahPengajuan)},-',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 15),
                                        // Status Bantuan (dengan highlight warna)
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 12),
                                          decoration: BoxDecoration(
                                            color: _getStatusColor(
                                                submission.status),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            'Status Bantuan: ${_getStatusText(submission.status)}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        if (submission.documentUrl != null &&
                                            submission.documentUrl!.isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20.0),
                                            child: TextButton.icon(
                                              onPressed: () => _launchURL(
                                                  submission.documentUrl!),
                                              icon: const Icon(
                                                  Icons.file_present,
                                                  color: Colors.blueAccent),
                                              label: const Text(
                                                'Lihat Dokumen Terupload',
                                                style: TextStyle(
                                                    color: Colors.blueAccent),
                                              ),
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

  // Helper method untuk field status
  Widget _buildStatusField(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white, // Latar belakang putih
        borderRadius: BorderRadius.circular(10),
        border:
            Border.all(color: Colors.grey[300]!, width: 1.0), // Border tipis
      ),
      child: Text(
        '$label : $value',
        style: const TextStyle(fontSize: 16, color: Colors.black87),
      ),
    );
  }
}
