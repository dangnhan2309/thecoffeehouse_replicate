class User {
  final int id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? avatarUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.avatarUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      // Ép kiểu ID về int đề phòng server trả về string hoặc int
      id: json['id'] is String ? int.parse(json['id']) : (json['id'] ?? 0),
      // Lấy từ 'full_name' (đúng với backend FastAPI) hoặc 'name'
      name: json['full_name'] ?? json['name'] ?? 'Người dùng',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'],
      avatarUrl: json['avatar_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': name,
      'email': email,
      'phone_number': phoneNumber,
      'avatar_url': avatarUrl,
    };
  }
}
