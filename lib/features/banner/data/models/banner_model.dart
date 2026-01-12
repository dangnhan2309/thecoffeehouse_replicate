import 'package:nhom2_thecoffeehouse/features/banner/domain/entities/banner.dart';

class BannerModel extends BannerItem{
  const BannerModel({
    required super.id,
    required super.imageUrl,
    required super.sortOrder,
    required super.createdAt,
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
}
