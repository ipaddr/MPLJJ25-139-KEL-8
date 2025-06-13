import 'package:aplikasi_bantuan_check/app_constants.dart';
import 'package:aplikasi_bantuan_check/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // <--- TAMBAHKAN ATAU PASTIKAN BARIS INI ADA DAN TIDAK DIKOMENTARI

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _agreeToTerms = false;

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password tidak cocok!')),
          );
        }
        return;
      }
      if (!_agreeToTerms) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Anda harus menyetujui syarat dan ketentuan.')),
          );
        }
        return;
      }

      setState(() {
        _isLoading = true;
      });
      try {
        await _authService.registerWithEmailAndPassword(
          _emailController.text,
          _passwordController.text,
          AppConstants.roleMasyarakat,
          name: _nameController.text,
          nik: _nikController.text,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Registrasi berhasil! Silakan login.')),
          );
          Navigator.pop(context);
        }
      } on FirebaseAuthException catch (e) {
        // <--- Ini baris yang error, butuh import
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Registrasi gagal: ${e.message}')), // Gunakan e.message
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Terjadi kesalahan: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _nikController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C72C3),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo_garuda.png',
                height: 100,
                width: 100,
              ),
              const SizedBox(height: 30),
              Card(
                color: const Color(0xFFFFF7E7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'DAFTAR AKUN',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Nama',
                            hintText: 'Masukkan Nama Lengkap Anda',
                            prefixIcon:
                                const Icon(Icons.person, color: Colors.grey),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[400]!),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFF28A745), width: 2.0),
                            ),
                            labelStyle: const TextStyle(color: Colors.black54),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Nama tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'Masukkan Email Anda',
                            prefixIcon:
                                const Icon(Icons.email, color: Colors.grey),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[400]!),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFF28A745), width: 2.0),
                            ),
                            labelStyle: const TextStyle(color: Colors.black54),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _nikController,
                          decoration: InputDecoration(
                            labelText: 'NIK',
                            hintText: 'Masukkan Nomor Induk Kependudukan Anda',
                            prefixIcon: const Icon(Icons.credit_card,
                                color: Colors.grey),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[400]!),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFF28A745), width: 2.0),
                            ),
                            labelStyle: const TextStyle(color: Colors.black54),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'NIK tidak boleh kosong';
                            }
                            if (value.length != 16) {
                              return 'NIK harus 16 digit';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Buat Password Anda',
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
                            if (value == null ||
                                value.isEmpty ||
                                value.length < 6) {
                              return 'Password minimal 6 karakter';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            labelText: 'Konfirmasi Password',
                            hintText: 'Ketik ulang Password Anda',
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
                              return 'Konfirmasi password tidak boleh kosong';
                            }
                            if (value != _passwordController.text) {
                              return 'Password tidak cocok';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Checkbox(
                              value: _agreeToTerms,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _agreeToTerms = newValue ?? false;
                                });
                              },
                              activeColor: const Color(0xFF28A745),
                            ),
                            const Expanded(
                              child: Text(
                                'Dengan ini saya menyetujui syarat dan ketentuan yang berlaku',
                                style: TextStyle(
                                    fontSize: 13, color: Colors.black87),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        _isLoading
                            ? const CircularProgressIndicator(
                                color: Color(0xFF28A745))
                            : ElevatedButton(
                                onPressed: _register,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF28A745),
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 5,
                                  textStyle: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                child: const Text('DAFTAR'),
                              ),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Sudah mendaftar? Masuk disini',
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
