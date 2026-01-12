import 'package:nhom2_thecoffeehouse/features/order/data/models/order_item_model.dart';
import 'package:nhom2_thecoffeehouse/features/order/domain/entities/order.dart';

class OrderModel extends Order {
  OrderModel({
    required super.id,
    required super.userId,
    required super.status,
    required super.createdAt,
    required super.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      userId: json['user_id'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      items: (json['items'] as List)
          .map((e) => OrderItemModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'status': status,
    'created_at': createdAt.toIso8601String(),
    'items': items.map((e) => (e as OrderItemModel).toJson()).toList(),
  };
}