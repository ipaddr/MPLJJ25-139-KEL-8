import 'package:aplikasi_bantuan_check/app_constants.dart';
import 'package:aplikasi_bantuan_check/models/submission_model.dart';
import 'package:aplikasi_bantuan_check/models/user_model.dart'; // Import UserModel
import 'package:aplikasi_bantuan_check/services/firestore_service.dart';
import 'package:aplikasi_bantuan_check/services/auth_service.dart'; // Import AuthService
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();
  List<SubmissionModel> _pendingSubmissions = [];
  Map<String, UserModel> _usersData = {}; // Cache untuk data UserModel
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSubmissionsAndUsers();
  }

  void _fetchSubmissionsAndUsers() {
    _firestoreService.getSubmissions().listen((data) async {
      if (!mounted) return;

      List<SubmissionModel> currentPending =
          data.where((s) => s.status == AppConstants.statusPending).toList();

      Set<String> userIdsToFetch = currentPending.map((s) => s.userId).toSet();

      // Filter userIdsToFetch hanya yang belum ada di _usersData cache
      userIdsToFetch.removeWhere((userId) => _usersData.containsKey(userId));

      List<Future<void>> fetchFutures = [];
      for (String userId in userIdsToFetch) {
        fetchFutures.add(() async {
          UserModel? userModel = await _authService.getUserData(userId);
          if (mounted && userModel != null) {
            _usersData[userId] = userModel;
          }
        }()); // Langsung panggil async function
      }

      // Tunggu semua user data selesai di-fetch
      await Future.wait(fetchFutures);

      if (mounted) {
        setState(() {
          _pendingSubmissions = currentPending;
          _isLoading = false;
        });
      }
    }).onError((error) {
      if (mounted) {
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
      _isLoading =
          true; // Atau gunakan loading indicator per item jika diinginkan
    });
    try {
      await _firestoreService.updateSubmissionStatus(submissionId, newStatus);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Status pengajuan berhasil diperbarui menjadi $newStatus')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui status: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
      backgroundColor: const Color(0xFF0C72C3),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.only(
                    top: 60, bottom: 30, left: 20, right: 20),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF9800),
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
                  'VERIFIKASI\nDAN VALIDASI',
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
                      : _pendingSubmissions.isEmpty
                          ? const Text(
                              'Tidak ada pengajuan yang perlu diverifikasi.',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                              textAlign: TextAlign.center,
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(24.0),
                              itemCount: _pendingSubmissions.length,
                              itemBuilder: (context, index) {
                                final submission = _pendingSubmissions[index];
                                // Ambil UserModel dari cache, atau gunakan UID sebagai fallback
                                final UserModel? user =
                                    _usersData[submission.userId];
                                final String userName =
                                    user?.name ?? submission.userId;
                                final String? userNIK = user?.nik;

                                return Card(
                                  color: const Color(0xFFFFF7E7),
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
                                        _buildInfoRow('ID', userName),
                                        if (userNIK != null &&
                                            userNIK
                                                .isNotEmpty) // Tampilkan NIK jika ada
                                          _buildInfoRow('NIK Pengaju', userNIK),
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
                                        if (submission.keteranganDokumen !=
                                                null &&
                                            submission
                                                .keteranganDokumen!.isNotEmpty)
                                          _buildInfoRow('Keterangan Dokumen',
                                              submission.keteranganDokumen!,
                                              maxLines: 3),
                                        const SizedBox(height: 20),
                                        if (submission.documentUrl != null &&
                                            submission.documentUrl!.isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 16.0),
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
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () => _updateStatus(
                                                  submission.id,
                                                  AppConstants.statusAccepted),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color(0xFF28A745),
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 12),
                                                textStyle: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              child: const Text('TERIMA'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () => _updateStatus(
                                                  submission.id,
                                                  AppConstants.statusRejected),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 12),
                                                textStyle: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              child: const Text('TOLAK'),
                                            ),
                                          ],
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
                backgroundColor: const Color(0xFFFFF7E7),
                foregroundColor: Colors.black87,
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
            width: 150,
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
