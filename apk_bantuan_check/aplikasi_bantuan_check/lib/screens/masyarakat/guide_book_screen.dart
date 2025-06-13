import 'package:flutter/material.dart';

class GuideBookScreen extends StatelessWidget {
  const GuideBookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF0C72C3), // Warna biru latar belakang utama
      body: Stack(
        children: [
          Column(
            children: [
              // Header Kustom
              Container(
                padding: const EdgeInsets.only(
                    top: 60, bottom: 30, left: 20, right: 20),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF9800), // Warna oranye untuk header
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: const Text(
                  'BUKU PANDUAN',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Card(
                      color: const Color(
                          0xFFFFF7E7), // Warna krem/kuning muda untuk kartu
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Selamat Datang di Aplikasi Bantuan Usaha!',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Aplikasi ini dirancang untuk memudahkan masyarakat dalam mengajukan dan memantau status bantuan usaha, serta mendapatkan informasi edukasi yang relevan secara efisien dan transparan.',
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black87),
                            ),
                            SizedBox(height: 24),
                            Text(
                              'Bagian-bagian Aplikasi:',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87),
                            ),
                            SizedBox(height: 12),
                            _GuideSection(
                              title: '1. Login & Registrasi:',
                              content:
                                  'Lakukan registrasi untuk membuat akun masyarakat baru atau login jika sudah memiliki akun. Pastikan data yang dimasukkan akurat.',
                            ),
                            _GuideSection(
                              title: '2. Halaman Utama Masyarakat:',
                              content:
                                  'Dari sini Anda dapat mengakses menu Pengajuan, Cek Status, dan Edukasi. Ini adalah pusat navigasi utama untuk pengguna masyarakat.',
                            ),
                            _GuideSection(
                              title: '3. Pengajuan Bantuan:',
                              content:
                                  'Isi formulir pengajuan dengan lengkap dan benar (alamat, jenis bantuan, jumlah, nomor rekening). Jangan lupa untuk mengunggah dokumen pendukung yang diperlukan. Klik "AJUKAN" setelah selesai.',
                            ),
                            _GuideSection(
                              title: '4. Cek Status Pengajuan:',
                              content:
                                  'Pantau status pengajuan bantuan Anda secara real-time. Anda akan melihat apakah pengajuan Anda sedang "Menunggu Verifikasi", "Diterima", atau "Ditolak" oleh pihak pemerintah.',
                            ),
                            _GuideSection(
                              title: '5. Edukasi Tips:',
                              content:
                                  'Akses berbagai video dan materi edukasi yang dirancang untuk membantu pengembangan usaha Anda. Materi ini akan membantu meningkatkan pengetahuan dan keterampilan bisnis Anda.',
                            ),
                            _GuideSection(
                              title: '6. Chat Bot (AI):',
                              content:
                                  'Manfaatkan fitur Chatbot untuk mendapatkan jawaban atas pertanyaan umum terkait bantuan usaha atau penggunaan aplikasi. Chatbot akan memberikan respons cepat dan informatif.',
                            ),
                            _GuideSection(
                              title: '7. Riwayat Usaha:',
                              content:
                                  'Lihat daftar lengkap riwayat pengajuan bantuan usaha yang pernah Anda ajukan, termasuk status dan detail penting lainnya. Ini berfungsi sebagai catatan pribadi Anda.',
                            ),
                            SizedBox(height: 24),
                            Text(
                              'Penting untuk Diketahui:',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87),
                            ),
                            SizedBox(height: 12),
                            _GuideSection(
                              title: '• Keamanan Data:',
                              content:
                                  'Selalu jaga kerahasiaan informasi akun Anda. Jangan pernah bagikan password Anda kepada siapapun.',
                            ),
                            _GuideSection(
                              title: '• Koneksi Internet:',
                              content:
                                  'Pastikan koneksi internet stabil untuk pengalaman terbaik dalam menggunakan aplikasi, terutama saat mengunggah dokumen atau berinteraksi dengan database.',
                            ),
                            _GuideSection(
                              title: '• Peran Admin Pemerintah:',
                              content:
                                  'Admin memiliki akses ke dashboard khusus untuk memantau data penerima, melakukan verifikasi, dan melihat statistik program. Fitur ini tidak tersedia untuk masyarakat umum.',
                            ),
                            SizedBox(height: 24),
                            Text(
                              'Terima kasih telah memilih Aplikasi Bantuan Usaha!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Tombol Kembali di kiri bawah
          Positioned(
            bottom: 30,
            left: 24,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Kembali'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFF7E7), // Warna kuning muda
                foregroundColor: Colors.black87, // Teks hitam
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget Helper untuk bagian panduan
class _GuideSection extends StatelessWidget {
  final String title;
  final String content;

  const _GuideSection({
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
