import 'package:flutter/material.dart';

class CekStatusPage extends StatelessWidget {
  const CekStatusPage({super.key});

  // Contoh data dummy (nantinya diganti dari backend)
  final List<Map<String, String>> pengajuanList = const [
    {
      "jenis": "Modal Usaha",
      "jumlah": "5.000.000",
      "status": "diproses",
      "tanggal": "2025-04-01"
    },
    {
      "jenis": "Pelatihan Kewirausahaan",
      "jumlah": "0",
      "status": "disetujui",
      "tanggal": "2025-03-18"
    },
    {
      "jenis": "Alat Produksi",
      "jumlah": "3.000.000",
      "status": "ditolak",
      "tanggal": "2025-02-10"
    },
  ];

  Color _statusColor(String status) {
    switch (status) {
      case 'disetujui':
        return Colors.green;
      case 'diproses':
        return Colors.orange;
      case 'ditolak':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'disetujui':
        return Icons.check_circle;
      case 'diproses':
        return Icons.hourglass_bottom;
      case 'ditolak':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cek Status Pengajuan")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: pengajuanList.length,
        itemBuilder: (context, index) {
          final item = pengajuanList[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(_statusIcon(item['status']!),
                  color: _statusColor(item['status']!)),
              title: Text(item['jenis'] ?? '-'),
              subtitle: Text(
                  "Jumlah: Rp ${item['jumlah']}\nTanggal: ${item['tanggal']}"),
              trailing: Text(
                item['status']!.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _statusColor(item['status']!),
                ),
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}
