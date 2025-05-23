import 'package:flutter/material.dart';

class RiwayatPage extends StatelessWidget {
  const RiwayatPage({super.key});

  // Data dummy (nanti diganti dengan data dari backend/API)
  final List<Map<String, String>> riwayatList = const [
    {
      "jenis": "Modal Usaha",
      "jumlah": "5.000.000",
      "tanggal": "2025-04-01",
    },
    {
      "jenis": "Pelatihan Usaha",
      "jumlah": "0",
      "tanggal": "2025-03-20",
    },
    {
      "jenis": "Alat Produksi",
      "jumlah": "3.000.000",
      "tanggal": "2025-01-25",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Riwayat Bantuan Usaha")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Riwayat Pengajuan Bantuan",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: riwayatList.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final item = riwayatList[index];
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text("${index + 1}"),
                    ),
                    title: Text(item['jenis'] ?? ''),
                    subtitle: Text("Tanggal: ${item['tanggal']}"),
                    trailing: Text(
                      "Rp ${item['jumlah']}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
