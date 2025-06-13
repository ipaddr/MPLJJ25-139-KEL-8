import 'package:flutter/material.dart';

class PengajuanPage extends StatefulWidget {
  const PengajuanPage({super.key});

  @override
  State<PengajuanPage> createState() => _PengajuanPageState();
}

class _PengajuanPageState extends State<PengajuanPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _nikController = TextEditingController();
  final _alasanController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    _nikController.dispose();
    _alasanController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Simulasi kirim data
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Berhasil"),
          content: Text("Pengajuan berhasil dikirim!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Tutup"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pengajuan Bantuan"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(labelText: 'Nama Lengkap'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Nama wajib diisi' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _nikController,
                decoration: InputDecoration(labelText: 'NIK'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.length != 16
                    ? 'NIK harus 16 digit'
                    : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _alasanController,
                decoration: InputDecoration(labelText: 'Alasan Pengajuan'),
                maxLines: 3,
                validator: (value) => value == null || value.isEmpty
                    ? 'Alasan harus diisi'
                    : null,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Kirim Pengajuan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
