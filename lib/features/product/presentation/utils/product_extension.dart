import 'package:nhom2_thecoffeehouse/core/constants/enum.dart';
import 'package:nhom2_thecoffeehouse/features/product/domain/entities/product.dart';
import 'package:nhom2_thecoffeehouse/core/utils/currency_formatter.dart';

extension ProductExtension on Product {
  String formattedPrice({SizeOption? size}) {
    final p = priceBySize(size);

    if (p == null) return "Liên hệ";

    return CurrencyFormatter.formatVND(p);
  }
}
