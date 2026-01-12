import '../entities/order.dart';
import '../repositories/order_repository.dart';

class GetOrderHistoryUseCase {
  final OrderRepository repository;
  GetOrderHistoryUseCase(this.repository);

  Future<List<Order>> call() => repository.getOrderHistory();
}