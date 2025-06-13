import 'package:flutter/material.dart';
import 'package:bantuancheck/pages/edukasi_page.dart';
import 'package:bantuancheck/pages/riwayat_page.dart';

class NavbarFooter extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const NavbarFooter({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book),
          label: 'Panduan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'Riwayat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: 'Edukasi',
        ),
      ],
    );
  }
}
