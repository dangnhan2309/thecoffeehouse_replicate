import 'package:nhom2_thecoffeehouse/core/constants/enum.dart';
import 'package:nhom2_thecoffeehouse/features/order/domain/entities/order.dart';
import 'package:nhom2_thecoffeehouse/features/order/domain/entities/order_item.dart';

abstract class OrderRepository {
  Future<Order> getCart();
  Future<void> addToCart(OrderItem item);
  Future<void> removeFromCart(int productId);
  Future<void> updateCartItem(
      int productId, {
        int? quantity,
        SizeOption? size,
        IceOption? ice,
        SugarOption? sugar,
        List<String>? toppings,
        String? note,
      });
  Future<Order> checkoutCash();
  Future<List<Order>> getOrderHistory();

}
