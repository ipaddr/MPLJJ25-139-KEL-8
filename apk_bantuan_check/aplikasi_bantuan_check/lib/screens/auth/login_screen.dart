import 'package:aplikasi_bantuan_check/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import ini tetap diperlukan untuk penanganan error

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController =
      TextEditingController(); // Akan menjadi NIK/Email
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        // Asumsi input NIK/Email di sini akan digunakan sebagai email login Firebase
        UserCredential? userCredential =
            await _authService.signInWithEmailAndPassword(
          _emailController.text, // NIK/Email digunakan sebagai email
          _passwordController.text,
        );

        if (userCredential != null && mounted) {
          // Tambahkan mounted check
          final userModel =
              await _authService.getUserData(userCredential.user!.uid);
          if (mounted && userModel != null) {
            // Tambahkan mounted check
            if (userModel.role == 'admin') {
              // Gunakan string literal 'admin' atau import AppConstants
              Navigator.pushReplacementNamed(context, '/admin_home');
            } else {
              Navigator.pushReplacementNamed(context, '/masyarakat_home');
            }
          } else if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Data pengguna tidak ditemukan.')),
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        String message;
        if (e.code == 'user-not-found') {
          message = 'Pengguna tidak ditemukan.';
        } else if (e.code == 'wrong-password') {
          message = 'Password salah.';
        } else {
          message = 'Login gagal: ${e.message}';
        }
        if (mounted) {
          // Tambahkan mounted check
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        }
      } catch (e) {
        if (mounted) {
          // Tambahkan mounted check
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Terjadi kesalahan: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) {
          // Tambahkan mounted check
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C72C3), // Warna biru dari desain
      body: Center(
        child: SingleChildScrollView(
          // Agar bisa di-scroll jika keyboard muncul
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo_garuda.png', // Ganti dengan path logo Anda
                height: 100, // Sesuaikan ukuran logo
                width: 100,
              ),
              const SizedBox(height: 30),
              Card(
                color: const Color(
                    0xFFFFF7E7), // Warna krem/kuning muda dari desain
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Sudut membulat
                ),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize:
                          MainAxisSize.min, // Agar card tidak terlalu besar
                      children: [
                        const Text(
                          'SILAHKAN MASUK',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'NIK / Email',
                            hintText: 'Masukkan NIK atau Email Anda',
                            prefixIcon:
                                const Icon(Icons.person, color: Colors.grey),
                            enabledBorder: UnderlineInputBorder(
                              // Garis bawah saat tidak fokus
                              borderSide: BorderSide(color: Colors.grey[400]!),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              // Garis bawah saat fokus
                              borderSide: BorderSide(
                                  color: Color(0xFF28A745),
                                  width: 2.0), // Warna hijau untuk fokus
                            ),
                            labelStyle: const TextStyle(color: Colors.black54),
                          ),
                          keyboardType: TextInputType
                              .emailAddress, // Atau TextInputType.text
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'NIK / Email tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Masukkan Password Anda',
                            prefixIcon:
                                const Icon(Icons.lock, color: Colors.grey),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[400]!),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFF28A745), width: 2.0),
                            ),
                            labelStyle: const TextStyle(color: Colors.black54),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // TODO: Implementasi lupa password
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Fitur lupa password belum diimplementasikan.')),
                              );
                            },
                            child: const Text(
                              'Lupa password?',
                              style: TextStyle(color: Colors.blueGrey),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        _isLoading
                            ? const CircularProgressIndicator(
                                color: Color(
                                    0xFF28A745)) // Warna hijau untuk loading
                            : ElevatedButton(
                                onPressed: _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(
                                      0xFF28A745), // Warna hijau dari desain
                                  foregroundColor:
                                      Colors.white, // Warna teks putih
                                  minimumSize: const Size(
                                      double.infinity, 50), // Lebar penuh
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10), // Sudut tombol membulat
                                  ),
                                  elevation: 5,
                                  textStyle: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                child: const Text('MASUK'),
                              ),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: const Text(
                            'Belum punya akun? Daftar disini',
                            style:
                                TextStyle(color: Colors.blueGrey, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
