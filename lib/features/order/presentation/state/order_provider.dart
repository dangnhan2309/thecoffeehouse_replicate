import 'package:flutter/cupertino.dart';
import 'package:nhom2_thecoffeehouse/features/category/domain/entities/category.dart';
import 'package:nhom2_thecoffeehouse/features/category/domain/repositories/category_repository.dart';
import 'package:nhom2_thecoffeehouse/features/product/domain/entities/product.dart';
import 'package:nhom2_thecoffeehouse/features/product/domain/repositories/product_repository.dart';

class OrderProvider extends ChangeNotifier {
  final CategoryRepository categoryRepo;
  final ProductRepository productRepo;

  OrderProvider({
    required this.categoryRepo,
    required this.productRepo,
  });

  List<Category> categories = [];
  List<Product> products = [];
  bool isLoading = false;

  Future<void> loadData() async {
    isLoading = true;
    notifyListeners();

    categories = await categoryRepo.getCategories();
    // products = await productRepo.getProducts();

    isLoading = false;
    notifyListeners();
  }

  List<Product> productsByCategory(int categoryId) {
    return products.where((p) => p.categoryId == categoryId).toList();
  }
  List<Product> getProductsByCategory(int categoryId) {
    return products.where((p) => p.categoryId == categoryId).toList();
  }
}
