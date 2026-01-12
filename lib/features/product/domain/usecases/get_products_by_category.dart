import 'package:nhom2_thecoffeehouse/features/product/domain/entities/product.dart';
import 'package:nhom2_thecoffeehouse/features/product/domain/repositories/product_repository.dart';

class GetProductsByCategoryUseCase {
  final ProductRepository repository;

  GetProductsByCategoryUseCase(this.repository);

  // categoryId optional
  Future<List<Product>> call({int? categoryId}) async {
    return await repository.getProductsByCategory(categoryId: categoryId);
  }
}