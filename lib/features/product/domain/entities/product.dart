import 'package:nhom2_thecoffeehouse/core/constants/enum.dart';

class Product {
  final int id;
  final String name;
  final double? price;
  final double? priceSmall;
  final double? priceMedium;
  final double? priceLarge;
  final int? categoryId;
  final String? imageUrl;
  final String? description;
  final bool isBestSeller;

  const Product({
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

  bool hasSizeOptions() =>
      priceSmall != null || priceMedium != null || priceLarge != null;

  double? priceBySize(SizeOption? size) {
    if (size == null) return price;

    switch (size) {
      case SizeOption.small:
        return priceSmall ?? price;
      case SizeOption.medium:
        return priceMedium ?? price;
      case SizeOption.large:
        return priceLarge ?? price;
    }
  }
}
