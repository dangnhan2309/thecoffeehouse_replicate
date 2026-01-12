import 'package:nhom2_thecoffeehouse/features/order/data/datasources/remote/order_remote_datasource.dart';
import 'package:nhom2_thecoffeehouse/features/order/domain/entities/order.dart';
import 'package:nhom2_thecoffeehouse/features/order/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDatasource remote;

  OrderRepositoryImpl(this.remote);

  @override
  Future<void> addToCart(int productId) {
    return remote.addToCart(productId);
  }

  @override
  Future<void> removeFromCart(int productId) {
    return remote.removeFromCart(productId);
  }

  @override
  Future<Order> getCart() {
    return remote.getCart();
  }
}
