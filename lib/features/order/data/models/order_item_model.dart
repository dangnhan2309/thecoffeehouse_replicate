import 'package:nhom2_thecoffeehouse/features/order/domain/entities/order_item.dart';

class OrderItemModel extends OrderItem {
  OrderItemModel({
    required super.productId,
    required super.productName,
    required super.quantity,
    required super.price,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productId: json['product_id'],
      productName: json['productName'],
      quantity: json['quantity'],
      price: json['price'].toDouble(),
    );
  }
}
