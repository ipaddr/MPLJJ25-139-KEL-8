import 'package:aplikasi_bantuan_check/app_constants.dart';
import 'package:aplikasi_bantuan_check/models/submission_model.dart';
import 'package:aplikasi_bantuan_check/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<SubmissionModel> _historySubmissions = [];
  bool _isLoading = true;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (_currentUserId != null) {
      _firestoreService.getUserSubmissions(_currentUserId!).listen((data) {
        if (mounted) {
          setState(() {
            // Filter riwayat yang statusnya Diterima atau Ditolak
            _historySubmissions = data
                .where((s) =>
                    s.status == AppConstants.statusAccepted ||
                    s.status == AppConstants.statusRejected)
                .toList();
            _isLoading = false;
          });
        }
      }).onError((error) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error memuat riwayat: $error')),
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
                      Text('Anda harus login untuk melihat riwayat bantuan.')),
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
      default:
        return Colors.orange; // Untuk pending jika tidak difilter
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUserId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Riwayat Bantuan Usaha')),
        body: const Center(child: Text('Mohon login terlebih dahulu.')),
      );
    }

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
                  'RIWAYAT\nBANTUAN USAHA',
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
                      : _historySubmissions.isEmpty
                          ? const Text(
                              'Belum ada riwayat bantuan yang tersedia.',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                              textAlign: TextAlign.center,
                            )
                          : SingleChildScrollView(
                              padding: const EdgeInsets.all(24.0),
                              child: Card(
                                color: const Color(
                                    0xFFFFF7E7), // Warna krem/kuning muda untuk kartu
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 8,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: SingleChildScrollView(
                                    // Untuk horizontal scroll tabel
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      columnSpacing: 20, // Spasi antar kolom
                                      dataRowHeight: 50, // Tinggi baris
                                      headingRowColor: MaterialStateProperty
                                          .resolveWith<Color?>(
                                        (Set<MaterialState> states) => Colors
                                            .grey[200], // Warna header tabel
                                      ),
                                      columns: const [
                                        DataColumn(
                                            label: Text('No.',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black87))),
                                        DataColumn(
                                            label: Text('Jenis Bantuan',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black87))),
                                        DataColumn(
                                            label: Text('Jumlah',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black87))),
                                        DataColumn(
                                            label: Text('Tanggal',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black87))),
                                        DataColumn(
                                            label: Text('Status',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black87))),
                                      ],
                                      rows: List<DataRow>.generate(
                                        _historySubmissions.length,
                                        (index) {
                                          final submission =
                                              _historySubmissions[index];
                                          return DataRow(
                                            cells: [
                                              DataCell(Text(
                                                  (index + 1).toString(),
                                                  style: const TextStyle(
                                                      color: Colors.black87))),
                                              DataCell(Text(
                                                  submission.jenisBantuan,
                                                  style: const TextStyle(
                                                      color: Colors.black87))),
                                              DataCell(Text(
                                                'Rp${NumberFormat('#,##0').format(submission.jumlahPengajuan)}',
                                                style: const TextStyle(
                                                    color: Colors.black87),
                                              )),
                                              DataCell(Text(
                                                DateFormat('dd-MM-yyyy').format(
                                                    submission.timestamp),
                                                style: const TextStyle(
                                                    color: Colors.black87),
                                              )),
                                              DataCell(
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: _getStatusColor(
                                                        submission.status),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Text(
                                                    submission.status,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          12, // Ukuran font status
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
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
}
