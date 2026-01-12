import 'package:nhom2_thecoffeehouse/features/product/domain/entities/product.dart';
import 'package:nhom2_thecoffeehouse/features/product/domain/usecases/add_to_cart.dart';

class CartRepositoryImpl implements AddToCartUseCase {
  @override
  Future<void> execute(Product product) async {
    print('Added ${product.name} to cart');
  }
}
