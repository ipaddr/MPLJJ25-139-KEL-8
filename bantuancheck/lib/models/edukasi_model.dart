class Edukasi {
  final int id;
  final String judul;
  final String konten;
  final String kategori;

  Edukasi({
    required this.id,
    required this.judul,
    required this.konten,
    required this.kategori,
  });

  factory Edukasi.fromJson(Map<String, dynamic> json) {
    return Edukasi(
      id: json['id'],
      judul: json['judul'],
      konten: json['konten'],
      kategori: json['kategori'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul': judul,
      'konten': konten,
      'kategori': kategori,
    };
  }
}
