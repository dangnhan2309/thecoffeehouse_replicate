import 'package:nhom2_thecoffeehouse/features/order/domain/entities/order.dart';
import 'package:nhom2_thecoffeehouse/features/order/domain/repositories/order_repository.dart';

class CheckoutCashUseCase {
  final OrderRepository repository;

  CheckoutCashUseCase(this.repository);

  Future<Order> call() {
    return repository.checkoutCash();
  }
}