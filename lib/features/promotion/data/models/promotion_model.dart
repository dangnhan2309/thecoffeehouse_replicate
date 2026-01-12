import 'package:nhom2_thecoffeehouse/features/promotion/domain/entities/promotion.dart';

class PromotionModel extends Promotion {
  const PromotionModel({
    required super.id,
    required super.name,
    super.description,
    super.discountPercent,
    super.discountAmount,
    required super.startDate,
    required super.endDate,
    required super.productIds,
  });

  factory PromotionModel.fromJson(Map<String, dynamic> json) {
    final productsList = json['promotion_products'] as List<dynamic>? ?? [];
    final productIds = productsList.map<int>((item) {
      final productMap = item['product'] as Map<String, dynamic>?;
      return productMap != null ? productMap['id'] as int : 0;
    }).where((id) => id != 0).toList();

    return PromotionModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      discountPercent: json['discount_percent'] as int?,
      discountAmount: (json['discount_amount'] as num?)?.toDouble(),
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      productIds: productIds,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'discount_percent': discountPercent,
      'discount_amount': discountAmount,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'product_ids': productIds,
    };
  }
}