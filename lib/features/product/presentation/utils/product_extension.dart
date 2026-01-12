import 'package:nhom2_thecoffeehouse/core/constants/enum.dart';
import 'package:nhom2_thecoffeehouse/features/product/domain/entities/product.dart';

extension ProductExtension on Product {
  String formattedPrice({SizeOption? size}) {
    final p = priceBySize(size);

    if (p == null) return "Liên hệ";

    return '${p.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
    )}đ';
  }
}
