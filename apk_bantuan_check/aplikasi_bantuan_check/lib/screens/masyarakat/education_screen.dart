import 'package:aplikasi_bantuan_check/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EducationScreen extends StatelessWidget {
  const EducationScreen({super.key});

  Future<void> _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

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
                  'EDUKASI TIPS',
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
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                    stream: FirestoreService().getEducationLinks(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(
                            color: Colors.white);
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error: ${snapshot.error}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text(
                          'Belum ada materi edukasi tersedia.',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          textAlign: TextAlign.center,
                        );
                      }

                      final educationLinks = snapshot.data!;
                      return ListView.builder(
                        padding: const EdgeInsets.all(24.0),
                        itemCount: educationLinks.length,
                        itemBuilder: (context, index) {
                          final link = educationLinks[index];
                          return Card(
                            color: const Color(
                                0xFFFFF7E7), // Warna krem/kuning muda untuk kartu
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(15), // Sudut membulat
                            ),
                            elevation: 5,
                            margin: const EdgeInsets.only(
                                bottom: 20), // Spasi antar kartu
                            child: InkWell(
                              // Menggunakan InkWell agar kartu bisa diklik
                              onTap: () => _launchURL(link['url'] ?? ''),
                              borderRadius: BorderRadius.circular(15),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  children: [
                                    // Placeholder untuk Thumbnail
                                    Container(
                                      width: 80,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(Icons.play_circle_fill,
                                          size: 40, color: Colors.grey),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            link['title'] ?? 'Video Edukasi',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                            maxLines: 2, // Batasi 2 baris
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            link['description'] ??
                                                'Tonton video ini untuk informasi lebih lanjut.',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                            maxLines: 1, // Batasi 1 baris
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    // Durasi/Tanggal (placeholder)
                                    Text(
                                      link['duration'] ??
                                          '10.41', // Ganti dengan field durasi jika ada, atau tanggal
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
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
