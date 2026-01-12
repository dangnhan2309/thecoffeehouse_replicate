import 'package:nhom2_thecoffeehouse/features/product/data/datasources/remote/product_remote_datasource.dart';
import 'package:nhom2_thecoffeehouse/features/product/data/models/product_model.dart';
import 'package:nhom2_thecoffeehouse/features/product/domain/entities/product.dart';
import 'package:nhom2_thecoffeehouse/features/product/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource remote;

  ProductRepositoryImpl(this.remote);

  @override
  Future<List<Product>> getAllProducts() async {
    final models = await remote.getAllProducts();
    return models;
  }
  @override
  Future<Product> getProductById(int id) async {
    final models = await remote.getProductById(id);
    return models;
  }

  @override
  Future<List<Product>> getProductsByCategory({int? categoryId}) async {
    final List<ProductModel> models;
    if (categoryId == null) {
      models = await remote.getAllProducts();
    } else {
      models = await remote.getProductsByCategory(categoryId);
    }

    return models;
  }

  @override
  Future<List<Product>> getProductsByIds(List<int> ids) async {
    final models = await remote.getProductsByIds(ids);
    return models;
  }
}
