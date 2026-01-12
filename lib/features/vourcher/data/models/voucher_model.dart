import '../../domain/entities/voucher.dart';

class VoucherModel extends Voucher {
  VoucherModel({
    required super.id,
    required super.code,
    required super.title,
    super.description,
    required super.discountAmount,
    required super.minOrderValue,
    required super.expiryDate,
  });

  factory VoucherModel.fromJson(Map<String, dynamic> json) {
    return VoucherModel(
      id: json['id'],
      code: json['code'],
      title: json['title'],
      description: json['description'],
      discountAmount: (json['discount_amount'] as num).toDouble(),
      minOrderValue: (json['min_order_value'] as num).toDouble(),
      expiryDate: DateTime.parse(json['expiry_date']),
    );
  }
}