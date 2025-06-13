import 'package:aplikasi_bantuan_check/services/auth_service.dart';
import 'package:aplikasi_bantuan_check/screens/admin/monitoring_screen.dart';
import 'package:aplikasi_bantuan_check/screens/admin/statistics_screen.dart';
import 'package:aplikasi_bantuan_check/screens/admin/verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aplikasi_bantuan_check/models/user_model.dart';

// TAMBAHKAN IMPORTS YANG HILANG DI SINI
import 'package:aplikasi_bantuan_check/screens/masyarakat/chatbot_screen.dart'; // <--- Tambahkan ini
import 'package:aplikasi_bantuan_check/screens/masyarakat/guide_book_screen.dart'; // <--- Tambahkan ini
import 'package:aplikasi_bantuan_check/screens/masyarakat/history_screen.dart'; // <--- Tambahkan ini

class HomeAdminScreen extends StatefulWidget {
  // Ini harus tetap tanpa 'const' karena _authService bukan const
  HomeAdminScreen({super.key});

  @override
  State<HomeAdminScreen> createState() => _HomeAdminScreenState();
}

class _HomeAdminScreenState extends State<HomeAdminScreen> {
  final AuthService _authService = AuthService();
  UserModel? _currentUserModel;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      UserModel? userModel = await _authService.getUserData(currentUser.uid);
      if (mounted) {
        setState(() {
          _currentUserModel = userModel;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String displayName = _currentUserModel?.name ?? 'Admin';

    return Scaffold(
      backgroundColor: const Color(0xFF0C72C3),
      body: Column(
        children: [
          Container(
            padding:
                const EdgeInsets.only(top: 40, bottom: 20, left: 20, right: 20),
            decoration: const BoxDecoration(
              color: Color(0xFFFFF7E7),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.person, size: 30, color: Colors.black87),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Halo Admin,\n$displayName',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.notifications_active,
                      size: 30, color: Colors.orange),
                  onPressed: () {
                    // TODO: Implementasi notifikasi
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Notifikasi belum diimplementasikan.')),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.red),
                  onPressed: () async {
                    await _authService.signOut();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildAdminFeatureButton(
                      context,
                      'MONITORING DATA PENERIMA',
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MonitoringScreen()),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildAdminFeatureButton(
                      context,
                      'VERIFIKASI DAN VALIDASI',
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const VerificationScreen()),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildAdminFeatureButton(
                      context,
                      'STATISTIK EFEKTIVITAS PROGRAM',
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const StatisticsScreen()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat Bot (AI)',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Buku Panduan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Riwayat Usaha',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: const Color(0xFF28A745),
        unselectedItemColor: Colors.grey[700],
        onTap: (index) {
          switch (index) {
            case 0:
              // Beranda Admin (sudah di sini)
              break;
            case 1:
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const ChatbotScreen())); // <-- Tambahkan 'const' jika memungkinkan
              break;
            case 2:
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const GuideBookScreen())); // <-- Tambahkan 'const' jika memungkinkan
              break;
            case 3:
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const HistoryScreen())); // <-- Tambahkan 'const' jika memungkinkan
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFFFF7E7),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildAdminFeatureButton(
      BuildContext context, String title, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF9800),
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 5,
          textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        child: Text(title),
      ),
    );
  }
}
