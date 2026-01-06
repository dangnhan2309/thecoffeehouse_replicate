class OrderResponse {
  final int id;
  final int userId;
  final String status;
  final String createdAt;
  final List<OrderItem> items;

  OrderResponse({
    required this.id,
    required this.userId,
    required this.status,
    required this.createdAt,
    required this.items,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      id: json['id'],
      userId: json['user_id'],
      status: json['status'],
      createdAt: json['created_at'],
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItem.fromJson(e))
          .toList(),
    );
  }
}

class OrderItem {
  final int productId;
  final String productName;
  final int quantity;
  final double price;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['product_id'],
      productName: json['product_name'],
      quantity: json['quantity'],
      price: (json['price'] as num).toDouble(),
    );
  }
}
