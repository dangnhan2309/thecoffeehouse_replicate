enum SizeOption { small, medium, large }
enum IceOption { normal, much, less }
enum SugarOption { normal, less, more }

class Product {
  final int id;
  final String name;
  final double? price; // món ăn
  final double? priceSmall;
  final double? priceMedium;
  final double? priceLarge;
  final int? categoryId;
  final String? imageUrl;
  final String? description;
  final bool isBestSeller;

  Product({
    required this.id,
    required this.name,
    this.price,
    this.priceSmall,
    this.priceMedium,
    this.priceLarge,
    this.categoryId,
    this.imageUrl,
    this.description,
    this.isBestSeller = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num?)?.toDouble(),
      priceSmall: (json['price_small'] as num?)?.toDouble(),
      priceMedium: (json['price_medium'] as num?)?.toDouble(),
      priceLarge: (json['price_large'] as num?)?.toDouble(),
      imageUrl: json['image_url'],
      description: json['description'],
      isBestSeller: json['is_best_seller'] ?? false,
      categoryId: (json['category_id'] as int?) ?? 0,
    );
  }

  String formattedPrice({SizeOption? size}) {
    double? p;

    if (size != null) {
      switch (size) {
        case SizeOption.small:
          p = priceSmall ?? price;
          break;
        case SizeOption.medium:
          p = priceMedium ?? price;
          break;
        case SizeOption.large:
          p = priceLarge ?? price;
          break;
      }
    } else {
      p = price;
    }

    if (p == null) return "Liên hệ";
    return '${p.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}đ';
  }
}
extension ProductExtension on Product {
  bool hasSizeOptions() => priceSmall != null || priceMedium != null || priceLarge != null;
}


