import 'package:nhom2_thecoffeehouse/core/constants/enum.dart';
import 'package:nhom2_thecoffeehouse/features/order/domain/repositories/order_repository.dart';

class UpdateCartItemUseCase {
  final OrderRepository repository;

  UpdateCartItemUseCase({required this.repository});

  Future<void> call(
      int productId, {
        int? quantity,
        SizeOption? size,
        IceOption? ice,
        SugarOption? sugar,
        List<String>? toppings,
        String? note,
      }) async {
    return await repository.updateCartItem(
      productId,
      quantity: quantity,
      size: size,
      ice: ice,
      sugar: sugar,
      toppings: toppings,
      note: note,
    );
  }
}