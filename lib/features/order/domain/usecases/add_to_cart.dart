import 'package:nhom2_thecoffeehouse/features/order/domain/entities/order_item.dart';
import 'package:nhom2_thecoffeehouse/features/order/domain/repositories/order_repository.dart';

class AddToCartUseCase {
  final OrderRepository repository;

  AddToCartUseCase(this.repository);

  Future<void> call(OrderItem item) {
    return repository.addToCart(item);
  }
}

