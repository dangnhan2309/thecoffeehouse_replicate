import 'package:nhom2_thecoffeehouse/features/product/domain/entities/product.dart';

abstract class AddToCartUseCase {
  Future<void> execute(Product product);
}
