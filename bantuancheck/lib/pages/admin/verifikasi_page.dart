import 'package:flutter/material.dart';

class VerifikasiPage extends StatefulWidget {
  const VerifikasiPage({Key? key}) : super(key: key);

  @override
  _VerifikasiPageState createState() => _VerifikasiPageState();
}

class _VerifikasiPageState extends State<VerifikasiPage> {
  // Contoh data dummy
  List<Map<String, dynamic>> daftarPengajuan = [
    {
      'id': 1,
      'nama': 'Ahmad Fauzi',
      'bantuan': 'Modal Usaha Mikro',
      'status': 'diajukan',
    },
    {
      'id': 2,
      'nama': 'Rina Marlina',
      'bantuan': 'Pelatihan UMKM',
      'status': 'diajukan',
    },
  ];

  void _verifikasiDialog(Map<String, dynamic> data) {
    final TextEditingController _catatanController = TextEditingController();
    String statusVerifikasi = 'valid';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Verifikasi Pengajuan - ${data['nama']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: statusVerifikasi,
              items: ['valid', 'tidak valid'].map((status) {
                return DropdownMenuItem(value: status, child: Text(status));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  statusVerifikasi = value;
                }
              },
              decoration: const InputDecoration(labelText: 'Status Verifikasi'),
            ),
            TextField(
              controller: _catatanController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Catatan'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              // Simulasi verifikasi
              setState(() {
                data['status'] =
                    statusVerifikasi == 'valid' ? 'disetujui' : 'ditolak';
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Verifikasi berhasil untuk ${data['nama']}'),
              ));
            },
            child: const Text('Verifikasi'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifikasi Pengajuan'),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: daftarPengajuan.length,
        itemBuilder: (context, index) {
          final data = daftarPengajuan[index];
          return Card(
            child: ListTile(
              title: Text(data['nama']),
              subtitle: Text(data['bantuan']),
              trailing: Text(data['status'],
                  style: TextStyle(
                    color: data['status'] == 'disetujui'
                        ? Colors.green
                        : data['status'] == 'ditolak'
                            ? Colors.red
                            : Colors.grey,
                  )),
              onTap: () {
                if (data['status'] == 'diajukan') {
                  _verifikasiDialog(data);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
