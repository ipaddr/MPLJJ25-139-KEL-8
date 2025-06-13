class UserModel {
  final int id;
  final String nik;
  final String name;
  final String email;
  final String role;

  UserModel({
    required this.id,
    required this.nik,
    required this.name,
    required this.email,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      nik: json['nik'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nik': nik,
      'name': name,
      'email': email,
      'role': role,
    };
  }
}
