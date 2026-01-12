import 'package:nhom2_thecoffeehouse/features/product/domain/entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getAllProducts();
  Future<Product> getProductById(int id);
  Future<List<Product>> getProductsByIds(List<int> ids);
  Future<List<Product>> getProductsByCategory({int? categoryId});
}
