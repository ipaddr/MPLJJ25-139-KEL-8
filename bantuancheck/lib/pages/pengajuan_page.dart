import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PengajuanPage extends StatefulWidget {
  const PengajuanPage({super.key});

  @override
  State<PengajuanPage> createState() => _PengajuanPageState();
}

class _PengajuanPageState extends State<PengajuanPage> {
  final _formKey = GlobalKey<FormState>();
  final _alamatController = TextEditingController();
  final _jumlahController = TextEditingController();
  final _rekeningController = TextEditingController();
  String? _jenisBantuan;
  File? _dokumen;

  Future<void> _pickDokumen() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _dokumen = File(picked.path));
    }
  }

  void _ajukanForm() {
    if (_formKey.currentState!.validate() && _dokumen != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pengajuan berhasil dikirim!')),
      );
      // TODO: Kirim data ke backend
    } else {
      ScaffoldMessenger.of(context).showS
