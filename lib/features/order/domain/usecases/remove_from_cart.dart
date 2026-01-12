import 'package:nhom2_thecoffeehouse/features/order/domain/repositories/order_repository.dart';

class RemoveFromCartUseCase {
  final OrderRepository repository;

  RemoveFromCartUseCase({required this.repository});

  Future<void> call(int productId) async {
    return await repository.removeFromCart(productId);
  }
}