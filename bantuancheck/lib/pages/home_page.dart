import 'package:flutter/material.dart';
import 'pengajuan_page.dart';
import 'cek_status_page.dart';
import 'edukasi_page.dart';
import 'riwayat_page.dart';
import 'chat_page.dart';
import 'panduan_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _mainPages = [
    MainMenuPage(),
    ChatPage(),
    PanduanPage(),
    RiwayatPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _mainPages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Panduan'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
        ],
      ),
    );
  }
}

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BantuanCheck"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildMenuItem(
              context,
              icon: Icons.assignment,
              title: "Pengajuan",
              targetPage: const PengajuanPage(),
            ),
            _buildMenuItem(
              context,
              icon: Icons.search,
              title: "Cek Status",
              targetPage: const CekStatusPage(),
            ),
            _buildMenuItem(
              context,
              icon: Icons.school,
              title: "Edukasi",
              targetPage: const EdukasiPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context,
      {required IconData icon,
      required String title,
      required Widget targetPage}) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => targetPage)),
      child: Card(
        elevation: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.blue),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
