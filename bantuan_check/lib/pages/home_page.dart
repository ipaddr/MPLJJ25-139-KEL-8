import 'package:flutter/material.dart';
import 'pengajuan_page.dart';
import 'status_page.dart';
import 'riwayat_page.dart';
import 'edukasi_page.dart';
import '../widgets/bottom_nav.dart';

class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> menu = [
    {'title': 'Pengajuan', 'page': PengajuanPage()},
    {'title': 'Cek Status', 'page': StatusPage()},
    {'title': 'Edukasi', 'page': EdukasiPage()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Beranda Masyarakat')),
      body: ListView.builder(
        itemCount: menu.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(menu[index]['title']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => menu[index]['page']),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
