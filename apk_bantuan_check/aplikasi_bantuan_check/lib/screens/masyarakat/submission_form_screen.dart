import 'package:aplikasi_bantuan_check/app_constants.dart';
import 'package:aplikasi_bantuan_check/models/submission_model.dart'; // Pastikan ini sudah diimpor dan diperbarui
import 'package:aplikasi_bantuan_check/services/firestore_service.dart';
// import 'package:aplikasi_bantuan_check/services/storage_service.dart'; // Tidak diperlukan lagi
import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart'; // Tidak diperlukan lagi
import 'package:firebase_auth/firebase_auth.dart';

class SubmissionFormScreen extends StatefulWidget {
  const SubmissionFormScreen({super.key});

  @override
  State<SubmissionFormScreen> createState() => _SubmissionFormScreenState();
}

class _SubmissionFormScreenState extends State<SubmissionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _jenisBantuanController = TextEditingController();
  final TextEditingController _jumlahPengajuanController =
      TextEditingController();
  final TextEditingController _noRekeningController = TextEditingController();
  final TextEditingController _keteranganDokumenController =
      TextEditingController(); // <-- Tambahan: Untuk deskripsi keterangan

  // Variabel untuk upload dokumen sudah dihapus karena tidak digunakan lagi

  bool _isLoading = false;

  final FirestoreService _firestoreService = FirestoreService();
  // Service StorageService tidak diperlukan lagi jika tidak ada upload dokumen

  // Fungsi _pickDocument() sudah dihapus karena tidak digunakan lagi

  Future<void> _submitApplication() async {
    if (_formKey.currentState!.validate()) {
      // Validasi untuk keterangan dokumen
      if (_keteranganDokumenController.text.trim().isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Keterangan dokumen tidak boleh kosong.')),
          );
        }
        return;
      }

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Anda harus login untuk mengajukan bantuan.')),
          );
        }
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        final newSubmission = SubmissionModel(
          id: '', // ID akan digenerate oleh Firestore
          userId: currentUser.uid,
          alamat: _alamatController.text,
          jenisBantuan: _jenisBantuanController.text,
          jumlahPengajuan: int.parse(_jumlahPengajuanController.text),
          noRekening: _noRekeningController.text,
          documentUrl: null, // Set ke null karena tidak ada lagi upload dokumen
          keteranganDokumen: _keteranganDokumenController
              .text, // <-- Simpan keterangan di sini
          status: AppConstants.statusPending,
          timestamp: DateTime.now(),
        );

        await _firestoreService.addSubmission(newSubmission);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pengajuan berhasil diajukan!')),
          );
          Navigator.pop(context); // Kembali ke halaman sebelumnya
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Gagal mengajukan bantuan: ${e.toString()}')),
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
  }

  @override
  void dispose() {
    _alamatController.dispose();
    _jenisBantuanController.dispose();
    _jumlahPengajuanController.dispose();
    _noRekeningController.dispose();
    _keteranganDokumenController.dispose(); // <-- Dispose controller baru
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  'PENGAJUAN\nBANTUAN USAHA',
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
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Card(
                      color: const Color(
                          0xFFFFF7E7), // Warna krem/kuning muda untuk kartu
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: _alamatController,
                                decoration: _inputDecoration(
                                    'Alamat', Icons.location_on),
                                maxLines: 3,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Alamat tidak boleh kosong';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _jenisBantuanController,
                                decoration: _inputDecoration(
                                    'Jenis Bantuan', Icons.category),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Jenis bantuan tidak boleh kosong';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _jumlahPengajuanController,
                                decoration: _inputDecoration(
                                    'Pengajuan Jumlah', Icons.attach_money),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Jumlah pengajuan tidak boleh kosong';
                                  }
                                  if (int.tryParse(value) == null ||
                                      int.parse(value) <= 0) {
                                    return 'Jumlah harus angka positif';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _noRekeningController,
                                decoration: _inputDecoration(
                                    'No. Rekening', Icons.credit_card),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Nomor rekening tidak boleh kosong';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              // Ganti bagian "Upload Dokumen" dengan "Keterangan Dokumen"
                              TextFormField(
                                // <-- INI PENGGANTI TOMBOL UPLOAD DOKUMEN
                                controller: _keteranganDokumenController,
                                decoration: _inputDecoration(
                                    'Keterangan Dokumen', Icons.description),
                                maxLines: 3, // Izinkan multi-baris
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Keterangan dokumen tidak boleh kosong';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 30),
                              _isLoading
                                  ? const CircularProgressIndicator(
                                      color: Color(
                                          0xFF28A745)) // Warna hijau untuk loading
                                  : ElevatedButton(
                                      onPressed: _submitApplication,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                            0xFF28A745), // Warna hijau dari desain
                                        foregroundColor: Colors.white,
                                        minimumSize:
                                            const Size(double.infinity, 60),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        elevation: 5,
                                        textStyle: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      child: const Text('AJUKAN'),
                                    ),
                            ],
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

  // Helper method untuk InputDecoration yang konsisten
  InputDecoration _inputDecoration(String labelText, IconData icon) {
    return InputDecoration(
      labelText: labelText,
      prefixIcon: Icon(icon, color: Colors.grey),
      filled: true,
      fillColor: Colors.white, // Background putih di dalam field
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10), // Sudut membulat
        borderSide: BorderSide.none, // Hilangkan border default
      ),
      enabledBorder: OutlineInputBorder(
        // Border saat tidak fokus
        borderRadius: BorderRadius.circular(10),
        borderSide:
            BorderSide(color: Colors.grey[300]!, width: 1.0), // Border tipis
      ),
      focusedBorder: OutlineInputBorder(
        // Border saat fokus
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
            color: Color(0xFF28A745), width: 2.0), // Warna hijau untuk fokus
      ),
      labelStyle: const TextStyle(color: Colors.black54),
      contentPadding: const EdgeInsets.symmetric(
          vertical: 15.0, horizontal: 10.0), // Padding internal
    );
  }
}
