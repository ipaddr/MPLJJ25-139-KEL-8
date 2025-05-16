import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Panduan'),
      ],
      currentIndex: 0,
      onTap: (index) {
        // Belum diisi, bisa tambahkan navigasi jika dibutuhkan
      },
    );
  }
}
