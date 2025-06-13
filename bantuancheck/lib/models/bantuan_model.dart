class Bantuan {
  final int id;
  final String namaBantuan;
  final String deskripsi;
  final String syarat;
  final bool aktif;

  Bantuan({
    required this.id,
    required this.namaBantuan,
    required this.deskripsi,
    required this.syarat,
    required this.aktif,
  });

  factory Bantuan.fromJson(Map<String, dynamic> json) {
    return Bantuan(
      id: json['id'],
      namaBantuan: json['nama_bantuan'],
      deskripsi: json['deskripsi'],
      syarat: json['syarat'],
      aktif: json['aktif'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_bantuan': namaBantuan,
      'deskripsi': deskripsi,
      'syarat': syarat,
      'aktif': aktif,
    };
  }
}
