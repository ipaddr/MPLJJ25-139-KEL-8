import 'package:flutter/material.dart';
import '../pages/riwayat_page.dart';

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(icon: Icon(Icons.chat), onPressed: () {}),
          IconButton(icon: Icon(Icons.book), onPressed: () {}),
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => RiwayatPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
