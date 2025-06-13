import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/login_page.dart'; // Pastikan file ini ada dan class LoginPage tersedia

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const BantuanCheckApp());
}

class BantuanCheckApp extends StatelessWidget {
  const BantuanCheckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BantuanCheck',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Langsung tampilkan halaman login
      home: const LoginPage(),
    );
  }
}
