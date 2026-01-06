// lib/models/banner.dart

class BannerModel {
  final int id;
  final String imageUrl;      // tương ứng với image_url trong backend
  final int sortOrder;        // thứ tự sắp xếp
  final DateTime createdAt;   // thời gian tạo

  BannerModel({
    required this.id,
    required this.imageUrl,
    required this.sortOrder,
    required this.createdAt,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] as int,
      imageUrl: json['image_url'] as String,
      sortOrder: json['sort_order'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_url': imageUrl,
      'sort_order': sortOrder,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'BannerModel(id: $id, imageUrl: $imageUrl, sortOrder: $sortOrder, createdAt: $createdAt)';
  }
}