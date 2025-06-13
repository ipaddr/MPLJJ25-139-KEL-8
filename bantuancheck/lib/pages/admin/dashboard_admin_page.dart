import 'package:flutter/material.dart';

class DashboardAdminPage extends StatefulWidget {
  const DashboardAdminPage({Key? key}) : super(key: key);

  @override
  State<DashboardAdminPage> createState() => _DashboardAdminPageState();
}

class _DashboardAdminPageState extends State<DashboardAdminPage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    MonitoringPage(),
    VerifikasiPage(),
    StatistikPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Admin'),
        backgroundColor: Colors.green,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.people), label: 'Monitoring'),
          BottomNavigationBarItem(
              icon: Icon(Icons.verified_user), label: 'Verifikasi'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart), label: 'Statistik'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        onTap: _onItemTapped,
      ),
    );
  }
}

class MonitoringPage extends StatelessWidget {
  const MonitoringPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy data pengguna penerima
    final List<Map<String, String>> data = [
      {"nama": "Ahmad", "nik": "1234567890", "status": "Disetujui"},
      {"nama": "Siti", "nik": "0987654321", "status": "Ditolak"},
    ];

    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.person),
          title: Text(data[index]['nama']!),
          subtitle: Text("NIK: ${data[index]['nik']}"),
          trailing: Text(data[index]['status']!,
              style: TextStyle(
                  color: data[index]['status'] == 'Disetujui'
                      ? Colors.green
                      : Colors.red)),
        );
      },
    );
  }
}

class VerifikasiPage extends StatelessWidget {
  const VerifikasiPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Simulasi data verifikasi
    final List<Map<String, dynamic>> pengajuan = [
      {
        "nama": "Budi",
        "dokumen": "KTP.pdf",
        "status": "diajukan",
      },
    ];

    return ListView.builder(
      itemCount: pengajuan.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text(pengajuan[index]["nama"]),
            subtitle: Text("Dokumen: ${pengajuan[index]["dokumen"]}"),
            trailing: ElevatedButton(
              onPressed: () {
                // Logika validasi atau buka detail verifikasi
              },
              child: const Text("Validasi"),
            ),
          ),
        );
      },
    );
  }
}

class StatistikPage extends StatelessWidget {
  const StatistikPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Simulasi data statistik
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.insert_chart, size: 80, color: Colors.green),
          SizedBox(height: 10),
          Text("50 Pengajuan Disetujui"),
          Text("20 Pengajuan Ditolak"),
          Text("30 Pengajuan Diproses"),
        ],
      ),
    );
  }
}
