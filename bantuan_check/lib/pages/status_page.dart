import 'package:flutter/material.dart';

class StatusPage extends StatelessWidget {
  final List<Map<String, dynamic>> data = [
    {'jenis': 'Modal Usaha', 'status': 'Diterima'},
    {'jenis': 'Alat Produksi', 'status': 'Ditolak'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Status Pengajuan')),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (_, i) {
          return ListTile(
            title: Text(data[i]['jenis']),
            subtitle: Text('Status: ${data[i]['status']}'),
          );
        },
      ),
    );
  }
}
