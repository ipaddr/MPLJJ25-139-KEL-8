import 'package:flutter/material.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Statistik Efektivitas Program')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Grafik Statistik Program Bantuan',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // Ini adalah placeholder gambar grafik.
              // Anda perlu menempatkan gambar grafik di folder `assets/images/`
              // dan mendeklarasikannya di `pubspec.yaml`
              Image.asset(
                'assets/images/sample_chart.png', // Ganti dengan path gambar Anda
                fit: BoxFit.contain,
                height: 300,
              ),
              const SizedBox(height: 30),
              const Text(
                'Catatan: Grafik ini adalah contoh visual. Untuk data real-time, implementasi lanjutan dengan pustaka charting (seperti `fl_chart`) dan agregasi data diperlukan.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey),
              ),
              const SizedBox(height: 20),
              // Contoh informasi statistik lainnya (bisa statis atau diambil dari Firestore)
              _buildStatisticCard('Total Pengajuan', '150 Pengajuan'),
              _buildStatisticCard('Pengajuan Diterima', '100 (66.7%)'),
              _buildStatisticCard('Pengajuan Ditolak', '30 (20%)'),
              _buildStatisticCard('Sedang Diverifikasi', '20 (13.3%)'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticCard(String title, String value) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Text(
              value,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple),
            ),
          ],
        ),
      ),
    );
  }
}
