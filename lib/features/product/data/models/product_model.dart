import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    super.price,
    super.priceSmall,
    super.priceMedium,
    super.priceLarge,
    super.categoryId,
    super.imageUrl,
    super.description,
    super.isBestSeller,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num?)?.toDouble(),
      priceSmall: (json['price_small'] as num?)?.toDouble(),
      priceMedium: (json['price_medium'] as num?)?.toDouble(),
      priceLarge: (json['price_large'] as num?)?.toDouble(),
      imageUrl: json['image_url'],
      description: json['description'],
      isBestSeller: json['is_best_seller'] ?? false,
      categoryId: json['category_id'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'price_small': priceSmall,
      'price_medium': priceMedium,
      'price_large': priceLarge,
      'image_url': imageUrl,
      'description': description,
      'is_best_seller': isBestSeller,
      'category_id': categoryId,
    };
  }
}
