import 'package:nhom2_thecoffeehouse/features/category/domain/entities/category.dart';

class CategoryModel extends Category{
  const CategoryModel({
    required super.id,
    required super.name,
    super.icon,
    super.imageUrl,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      imageUrl: json['image_url'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'image_url': imageUrl,
    };
  }
}
