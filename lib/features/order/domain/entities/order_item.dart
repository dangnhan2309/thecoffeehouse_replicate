
class OrderItem {
  final int productId;
  final String productName;
  final int quantity;
  final double price;

  const OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
  });
}