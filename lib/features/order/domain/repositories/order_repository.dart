import 'package:nhom2_thecoffeehouse/features/order/domain/entities/order.dart';

abstract class OrderRepository {
  Future<void> addToCart(int productId);
  Future<void> removeFromCart(int productId);
  Future<Order> getCart();
}
