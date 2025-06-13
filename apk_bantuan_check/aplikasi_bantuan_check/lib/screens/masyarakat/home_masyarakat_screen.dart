import 'package:aplikasi_bantuan_check/services/auth_service.dart';
import 'package:aplikasi_bantuan_check/screens/masyarakat/check_status_screen.dart';
import 'package:aplikasi_bantuan_check/screens/masyarakat/education_screen.dart';
import 'package:aplikasi_bantuan_check/screens/masyarakat/submission_form_screen.dart';
import 'package:aplikasi_bantuan_check/screens/masyarakat/chatbot_screen.dart';
import 'package:aplikasi_bantuan_check/screens/masyarakat/guide_book_screen.dart';
import 'package:aplikasi_bantuan_check/screens/masyarakat/history_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aplikasi_bantuan_check/models/user_model.dart'; // Import UserModel

class HomeMasyarakatScreen extends StatefulWidget {
  const HomeMasyarakatScreen({super.key});

  @override
  State<HomeMasyarakatScreen> createState() => _HomeMasyarakatScreenState();
}

class _HomeMasyarakatScreenState extends State<HomeMasyarakatScreen> {
  int _selectedIndex = 0;
  final AuthService _authService = AuthService();
  UserModel? _currentUserModel; // Untuk menyimpan data user dari Firestore

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

  // List widget untuk body BottomNavigationBar
  late final List<Widget> _widgetOptions = <Widget>[
    _HomeContentMasyarakat(currentUserModel: _currentUserModel),
    const ChatbotScreen(),
    const GuideBookScreen(),
    const HistoryScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // String nama ditampilkan dari _currentUserModel, default ke 'Warga'
    final String displayName = _currentUserModel?.name ?? 'Warga';

    return Scaffold(
      backgroundColor:
          const Color(0xFF0C72C3), // Warna biru latar belakang utama
      body: Column(
        children: [
          // Header Kustom
          Container(
            padding:
                const EdgeInsets.only(top: 40, bottom: 20, left: 20, right: 20),
            decoration: const BoxDecoration(
              color: Color(0xFFFFF7E7), // Warna krem untuk header
              borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30)), // Sudut membulat di bawah
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
                    'Halo Warga,\n$displayName',
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
                // Tombol Logout di Header
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.red),
                  onPressed: () async {
                    await _authService.signOut();
                    // Navigasi otomatis ke login screen setelah logout (ditangani di main.dart)
                  },
                ),
              ],
            ),
          ),
          // Body utama aplikasi
          Expanded(
            child: IndexedStack(
              // Menggunakan IndexedStack agar state widget tidak hilang
              index: _selectedIndex,
              children: _widgetOptions,
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
            label: 'Chat Bot (AI)', // Sesuai desain
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Buku Panduan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons
                .history), // Atau ikon yang lebih sesuai untuk Riwayat Usaha
            label: 'Riwayat Usaha', // Sesuai desain
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor:
            const Color(0xFF28A745), // Warna hijau terang untuk yang dipilih
        unselectedItemColor:
            Colors.grey[700], // Warna abu-abu gelap untuk yang tidak dipilih
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Penting agar semua item terlihat
        backgroundColor: const Color(
            0xFFFFF7E7), // Warna krem untuk background bottom navbar
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

// Widget terpisah untuk konten utama halaman Home (tombol-tombol navigasi)
class _HomeContentMasyarakat extends StatelessWidget {
  final UserModel? currentUserModel; // Menerima UserModel dari parent

  const _HomeContentMasyarakat({Key? key, required this.currentUserModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment
              .start, // Atur ke start untuk memberi ruang di atas
          children: [
            const SizedBox(height: 20), // Spasi di bawah header
            // Kartu Bantuan Usaha (sesuai desain)
            Container(
              width: double.infinity,
              height: 200, // Tinggi kartu
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  // Gradient atau warna solid jika itu maksudnya
                  colors: [
                    Color(0xFF4C4A8D),
                    Color(0xFF6A67B1)
                  ], // Contoh warna ungu/biru tua
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Stack(
                // Menggunakan Stack untuk menempatkan elemen di atas kartu
                children: [
                  Positioned(
                    top: 20,
                    left: 20,
                    child: Image.asset(
                      'assets/images/logo_garuda.png', // Logo di kiri atas kartu
                      height: 50,
                      width: 50,
                    ),
                  ),
                  const Positioned(
                    top: 20,
                    right: 20,
                    child: Text(
                      'KARTU BANTUAN\nUSAHA',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(
                            0xFFFFEB3B), // Warna kuning neon untuk status
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        '*Status bantuan usaha AKTIF', // Status dari desain
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30), // Spasi antara kartu dan tombol
            // Tombol-tombol fitur (Pengajuan, Cek Status, Edukasi)
            _buildFeatureButton(
              context,
              'PENGAJUAN',
              () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SubmissionFormScreen()),
              ),
            ),
            const SizedBox(height: 20),
            _buildFeatureButton(
              context,
              'CEK STATUS',
              () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CheckStatusScreen()),
              ),
            ),
            const SizedBox(height: 20),
            _buildFeatureButton(
              context,
              'EDUKASI',
              () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const EducationScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureButton(
      BuildContext context, String title, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF9800), // Warna oranye dari desain
          foregroundColor: Colors.white, // Warna teks putih
          minimumSize: const Size(double.infinity, 60), // Ukuran tombol
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Sudut tombol membulat
          ),
          elevation: 5,
          textStyle: const TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold), // Ukuran font
        ),
        child: Text(title),
      ),
    );
  }
}
