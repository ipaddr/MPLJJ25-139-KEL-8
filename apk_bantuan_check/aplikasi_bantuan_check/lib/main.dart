import 'package:aplikasi_bantuan_check/screens/admin/home_admin_screen.dart';
import 'package:aplikasi_bantuan_check/screens/auth/login_screen.dart';
import 'package:aplikasi_bantuan_check/screens/auth/register_screen.dart'; // Pastikan ini sudah benar
import 'package:aplikasi_bantuan_check/screens/masyarakat/home_masyarakat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:aplikasi_bantuan_check/services/auth_service.dart';
import 'package:aplikasi_bantuan_check/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService _authService = AuthService();
  User? _currentUser;
  String? _userRole;

  @override
  void initState() {
    super.initState();
    _authService.user.listen((user) async {
      setState(() {
        _currentUser = user;
      });
      if (user != null) {
        final userModel = await _authService.getUserData(user.uid);
        if (mounted) {
          // Tambahkan pengecekan mounted
          setState(() {
            _userRole = userModel?.role;
          });
        }
      } else {
        if (mounted) {
          // Tambahkan pengecekan mounted
          setState(() {
            _userRole = null;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget homeScreen;
    if (_currentUser == null) {
      homeScreen =
          const LoginScreen(); // Ini boleh const karena LoginScreen itu sendiri Stateless, tapi konstruktornya tidak const.
    } else {
      if (_userRole == null) {
        homeScreen = const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      } else if (_userRole == AppConstants.roleAdmin) {
        homeScreen = HomeAdminScreen(); // <-- HAPUS CONST DI SINI
      } else {
        homeScreen = HomeMasyarakatScreen(); // <-- HAPUS CONST DI SINI
      }
    }

    return MaterialApp(
      title: 'Aplikasi Bantuan Usaha',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: homeScreen,
      routes: {
        '/login': (context) => const LoginScreen(), // Ini boleh const
        '/register': (context) =>
            const RegisterScreen(), // <-- Ini juga harus dipertimbangkan
        '/masyarakat_home': (context) =>
            HomeMasyarakatScreen(), // <-- HAPUS CONST
        '/admin_home': (context) => HomeAdminScreen(), // <-- HAPUS CONST
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
