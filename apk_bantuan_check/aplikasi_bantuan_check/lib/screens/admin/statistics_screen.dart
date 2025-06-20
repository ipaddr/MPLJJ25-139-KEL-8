import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Pastikan fl_chart sudah di pubspec.yaml dan flutter pub get sudah dijalankan
import 'package:aplikasi_bantuan_check/services/firestore_service.dart';
import 'package:aplikasi_bantuan_check/models/submission_model.dart';
import 'package:aplikasi_bantuan_check/app_constants.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<SubmissionModel> _allSubmissions = [];
  bool _isLoading = true;

  double totalPengajuan = 0;
  double diterima = 0;
  double ditolak = 0;
  double diverifikasi = 0;

  @override
  void initState() {
    super.initState();
    _fetchAndProcessSubmissionData();
  }

  void _fetchAndProcessSubmissionData() {
    _firestoreService.getSubmissions().listen((data) {
      if (mounted) {
        setState(() {
          _allSubmissions = data;
          _processStatistics();
          _isLoading = false;
        });
      }
    }).onError((error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error memuat data statistik: $error')),
        );
      }
    });
  }

  void _processStatistics() {
    totalPengajuan = _allSubmissions.length.toDouble();
    diterima = _allSubmissions
        .where((s) => s.status == AppConstants.statusAccepted)
        .length
        .toDouble();
    ditolak = _allSubmissions
        .where((s) => s.status == AppConstants.statusRejected)
        .length
        .toDouble();
    diverifikasi = _allSubmissions
        .where((s) => s.status == AppConstants.statusPending)
        .length
        .toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C72C3),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.only(
                    top: 60, bottom: 30, left: 20, right: 20),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF9800),
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
                  'STATISTIK\nEFEKTIVITAS PROGRAM',
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
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : SingleChildScrollView(
                          padding: const EdgeInsets.all(24.0),
                          child: Card(
                            color: const Color(0xFFFFF7E7),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 8,
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Grafik Efektivitas Program Bantuan',
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 20),
                                  AspectRatio(
                                    aspectRatio: 1.5,
                                    child: BarChart(
                                      BarChartData(
                                        maxY: totalPengajuan == 0
                                            ? 10
                                            : totalPengajuan * 1.2,
                                        barGroups: [
                                          BarChartGroupData(x: 0, barRods: [
                                            BarChartRodData(
                                              toY: diterima,
                                              color: const Color(0xFF28A745),
                                              width: 25,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ]),
                                          BarChartGroupData(x: 1, barRods: [
                                            BarChartRodData(
                                              toY: ditolak,
                                              color: Colors.red,
                                              width: 25,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ]),
                                          BarChartGroupData(x: 2, barRods: [
                                            BarChartRodData(
                                              toY: diverifikasi,
                                              color: Colors.orange,
                                              width: 25,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ]),
                                        ],
                                        titlesData: FlTitlesData(
                                          show: true,
                                          bottomTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              getTitlesWidget: getTitles,
                                              reservedSize: 40,
                                            ),
                                          ),
                                          leftTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              reservedSize: 40,
                                              interval: totalPengajuan == 0
                                                  ? 1
                                                  : (totalPengajuan / 4)
                                                      .ceilToDouble(),
                                              getTitlesWidget: (value, meta) {
                                                if (value == 0)
                                                  return const Text('');
                                                return Text(
                                                    value.toInt().toString(),
                                                    style: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12));
                                              },
                                            ),
                                          ),
                                          topTitles: const AxisTitles(
                                              sideTitles: SideTitles(
                                                  showTitles: false)),
                                          rightTitles: const AxisTitles(
                                              sideTitles: SideTitles(
                                                  showTitles: false)),
                                        ),
                                        borderData: FlBorderData(
                                          show: false,
                                        ),
                                        gridData: const FlGridData(show: false),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  _buildStatisticCard('Total Pengajuan',
                                      '${totalPengajuan.toInt()} Pengajuan'),
                                  _buildStatisticCard('Pengajuan Diterima',
                                      '${diterima.toInt()} (${(diterima / totalPengajuan * 100).toStringAsFixed(1)}%)'),
                                  _buildStatisticCard('Pengajuan Ditolak',
                                      '${ditolak.toInt()} (${(ditolak / totalPengajuan * 100).toStringAsFixed(1)}%)'),
                                  _buildStatisticCard('Sedang Diverifikasi',
                                      '${diverifikasi.toInt()} (${(diverifikasi / totalPengajuan * 100).toStringAsFixed(1)}%)'),
                                ],
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
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
                backgroundColor: const Color(0xFFFFF7E7),
                foregroundColor: Colors.black87,
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

  // Helper untuk judul sumbu X BarChart
  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Diterima';
        break;
      case 1:
        text = 'Ditolak';
        break;
      case 2:
        text = 'Verifikasi';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: Text(text, style: style),
    );
  }

  Widget _buildStatisticCard(String title, String value) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87),
            ),
            Text(
              value,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple),
            ),
          ],
        ),
      ),
    );
  }
}
