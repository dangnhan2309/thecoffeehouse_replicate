import 'package:nhom2_thecoffeehouse/features/order/domain/entities/order_item.dart';

class Order{
  final int id;
  final int userId;
  final String status;
  final DateTime createdAt;
  final List<OrderItem> items;

  const Order({
    required this.id,
    required this.userId,
    required this.status,
    required this.createdAt,
    required this.items,
  });
}

