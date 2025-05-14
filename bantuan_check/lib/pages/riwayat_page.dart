import 'package:flutter/material.dart';

class RiwayatPage extends StatelessWidget {
  final List<Map<String, dynamic>> riwayat = [
    {
      'no': 1,
      'jenis': 'Modal Usaha',
      'jumlah': '5 juta',
      'tanggal': '2024-08-01',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Riwayat Bantuan')),
      body: DataTable(
        columns: [
          DataColumn(label: Text('No')),
          DataColumn(label: Text('Jenis')),
          DataColumn(label: Text('Jumlah')),
          DataColumn(label: Text('Tanggal')),
        ],
        rows:
            riwayat.map((item) {
              return DataRow(
                cells: [
                  DataCell(Text(item['no'].toString())),
                  DataCell(Text(item['jenis'])),
                  DataCell(Text(item['jumlah'])),
                  DataCell(Text(item['tanggal'])),
                ],
              );
            }).toList(),
      ),
    );
  }
}
