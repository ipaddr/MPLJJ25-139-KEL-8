class Pengajuan {
  final int id;
  final int userId;
  final int bantuanId;
  final String status;
  final String tanggalPengajuan;
  final String keterangan;

  Pengajuan({
    required this.id,
    required this.userId,
    required this.bantuanId,
    required this.status,
    required this.tanggalPengajuan,
    required this.keterangan,
  });

  factory Pengajuan.fromJson(Map<String, dynamic> json) {
    return Pengajuan(
      id: json['id'],
      userId: json['user_id'],
      bantuanId: json['bantuan_id'],
      status: json['status'],
      tanggalPengajuan: json['tanggal_pengajuan'],
      keterangan: json['keterangan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'bantuan_id': bantuanId,
      'status': status,
      'tanggal_pengajuan': tanggalPengajuan,
      'keterangan': keterangan,
    };
  }
}
