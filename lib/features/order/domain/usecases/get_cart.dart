import 'package:nhom2_thecoffeehouse/features/order/domain/entities/order.dart';
import 'package:nhom2_thecoffeehouse/features/order/domain/repositories/order_repository.dart';

class GetCartUseCase {
  final OrderRepository repository;

  GetCartUseCase(this.repository);

  Future<Order> call() {
    return repository.getCart();
  }
}