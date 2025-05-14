import 'package:flutter/material.dart';

class PengajuanPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController alamatCtrl = TextEditingController();
  final TextEditingController jumlahCtrl = TextEditingController();
  final TextEditingController rekeningCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pengajuan Bantuan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: alamatCtrl,
                decoration: InputDecoration(labelText: 'Alamat'),
              ),
              DropdownButtonFormField<String>(
                items:
                    ['Modal Usaha', 'Alat Produksi']
                        .map((e) => DropdownMenuItem(child: Text(e), value: e))
                        .toList(),
                onChanged: (_) {},
                decoration: InputDecoration(labelText: 'Jenis Bantuan'),
              ),
              TextFormField(
                controller: jumlahCtrl,
                decoration: InputDecoration(labelText: 'Jumlah Pengajuan'),
              ),
              TextFormField(
                controller: rekeningCtrl,
                decoration: InputDecoration(labelText: 'No. Rekening'),
              ),
              SizedBox(height: 10),
              ElevatedButton(onPressed: () {}, child: Text('Upload Dokumen')),
              SizedBox(height: 20),
              ElevatedButton(onPressed: () {}, child: Text('Ajukan')),
            ],
          ),
        ),
      ),
    );
  }
}
