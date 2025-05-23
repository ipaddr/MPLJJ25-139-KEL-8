import 'package:flutter/material.dart';
import 'pengajuan_page.dart';
import 'status_page.dart';
import 'edukasi_page.dart';
import '../widgets/bottom_nav.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> menu = [
    {'title': 'Pengajuan', 'page': PengajuanPage(), 'icon': Icons.assignment},
    {'title': 'Cek Status', 'page': StatusPage(), 'icon': Icons.verified},
    {'title': 'Edukasi', 'page': EdukasiPage(), 'icon': Icons.school},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda Masyarakat'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: menu.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              leading: CircleAvatar(
                backgroundColor: Colors.teal.shade100,
                child: Icon(menu[index]['icon'], color: Colors.teal.shade800),
              ),
              title: Text(
                menu[index]['title'],
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => menu[index]['page']),
                );
              },
            ),
          );
        },
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
