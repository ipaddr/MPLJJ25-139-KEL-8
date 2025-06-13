import 'package:flutter/material.dart';

class StatistikPage extends StatelessWidget {
  const StatistikPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Contoh data statistik dummy
    final int totalPengajuan = 100;
    final int disetujui = 60;
    final int ditolak = 20;
    final int diproses = 20;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistik Program'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Rekapitulasi Pengajuan Bantuan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            StatistikBar(
                label: "Disetujui",
                value: disetujui,
                total: totalPengajuan,
                color: Colors.green),
            StatistikBar(
                label: "Ditolak",
                value: ditolak,
                total: totalPengajuan,
                color: Colors.red),
            StatistikBar(
                label: "Diproses",
                value: diproses,
                total: totalPengajuan,
                color: Colors.orange),
            const SizedBox(height: 30),
            Text(
              'Total Pengajuan: $totalPengajuan',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class StatistikBar extends StatelessWidget {
  final String label;
  final int value;
  final int total;
  final Color color;

  const StatistikBar({
    Key? key,
    required this.label,
    required this.value,
    required this.total,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double persen = value / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$label: $value",
            style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 5),
        LinearProgressIndicator(
          value: persen,
          color: color,
          backgroundColor: color.withOpacity(0.2),
          minHeight: 16,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
