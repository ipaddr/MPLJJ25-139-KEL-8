import 'package:flutter/material.dart';
import 'pengajuan_page.dart';
import 'status_page.dart';
import 'riwayat_page.dart';
import 'edukasi_page.dart';

class HomePage extends StatelessWidget {
  final String userName;

  const HomePage({Key? key, this.userName = "Warga"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selamat Datang, $userName 👋'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildMenuItem(
              context,
              title: 'Ajukan Bantuan',
              icon: Icons.edit_note_rounded,
              color: Colors.orange,
              page: PengajuanPage(),
            ),
            _buildMenuItem(
              context,
              title: 'Cek Status',
              icon: Icons.assignment_turned_in_outlined,
              color: Colors.blue,
              page: CekStatusPage(),
            ),
            _buildMenuItem(
              context,
              title: 'Riwayat',
              icon: Icons.history,
              color: Colors.purple,
              page: RiwayatPage(),
            ),
            _buildMenuItem(
              context,
              title: 'Edukasi',
              icon: Icons.school_rounded,
              color: Colors.teal,
              page: EdukasiPage(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[100],
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                icon: Icon(Icons.chat), onPressed: () {/* fitur chat */}),
            IconButton(
                icon: Icon(Icons.menu_book),
                onPressed: () {/* fitur buku panduan */}),
            IconButton(
                icon: Icon(Icons.analytics),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RiwayatPage()),
                  );
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context,
      {required String title,
      required IconData icon,
      required Color color,
      required Widget page}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
      child: Card(
        color: color.withOpacity(0.8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 50, color: Colors.white),
              const SizedBox(height: 10),
              Text(title,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
