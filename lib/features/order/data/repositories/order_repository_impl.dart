import 'package:nhom2_thecoffeehouse/core/constants/enum.dart';
import 'package:nhom2_thecoffeehouse/features/order/data/datasources/remote/order_remote_datasource.dart';
import 'package:nhom2_thecoffeehouse/features/order/data/models/order_item_model.dart';
import 'package:nhom2_thecoffeehouse/features/order/domain/entities/order.dart';
import 'package:nhom2_thecoffeehouse/features/order/domain/entities/order_item.dart';
import 'package:nhom2_thecoffeehouse/features/order/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDatasource remote;

  OrderRepositoryImpl(this.remote);

  @override
  Future<void> addToCart(OrderItem item) {
    return remote.addToCart(
      OrderItemModel(
        id: item.id,
        productId: item.productId,
        productName: item.productName,
        quantity: item.quantity,
        price: item.price,
        size: item.size,
        ice: item.ice,
        sugar: item.sugar,
        toppings: item.toppings,
        note: item.note,
        productImage: item.productImage,
      ),
    );
  }
  @override
  Future<List<Order>> getOrderHistory() {
    return remote.getOrderHistory();
  }

  @override
  Future<Order> getCart() async {
    try {
      final cart = await remote.getCart();
      if (cart == null) {
        return Order(
          id: 0,
          userId: 0,
          status: 'empty',
          createdAt: DateTime.now(),
          items: [],
        );
      }
      return cart;
    } catch (e) {
      return Order(
        id: 0,
        userId: 0,
        status: 'error',
        createdAt: DateTime.now(),
        items: [],
      );
    }
  }

  @override
  Future<void> removeFromCart(int productId) {
    return remote.removeFromCart(productId);
  }

  @override
  Future<void> updateCartItem(
    int productId, {
    int? quantity,
    SizeOption? size,
    IceOption? ice,
    SugarOption? sugar,
    List<String>? toppings,
    String? note,
  }) {
    return remote.updateCartItem(
      productId,
      quantity: quantity,
      size: size,
      ice: ice,
      sugar: sugar,
      toppings: toppings,
      note: note,
    );
  }

  @override
  Future<Order> checkoutCash() async {
    return await remote.checkoutCash();
  }

}
