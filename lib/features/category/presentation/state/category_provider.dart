import 'package:flutter/material.dart';
import 'package:nhom2_thecoffeehouse/features/category/domain/entities/category.dart';
import 'package:nhom2_thecoffeehouse/features/product/domain/entities/product.dart';
import 'package:nhom2_thecoffeehouse/features/category/domain/usecases/get_categories.dart';
import 'package:nhom2_thecoffeehouse/features/product/domain/usecases/get_products.dart';

class CategoryProvider extends ChangeNotifier {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetAllProductsUseCase getProductsUseCase;

  CategoryProvider({
    required this.getCategoriesUseCase,
    required this.getProductsUseCase,
  });

  List<Category> categories = [];
  Map<int, List<Product>> productsByCategory = {};
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadCategories() async {
    isLoading = true;
    notifyListeners();

    try {
      categories = await getCategoriesUseCase();
      for (var cat in categories) {
        final products = await getProductsUseCase();
        productsByCategory[cat.id] = products;
      }
      errorMessage = null;
    } catch (e) {
      categories = [];
      productsByCategory = {};
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<Product> getProductsByCategory(int categoryId) {
    return productsByCategory[categoryId] ?? [];
  }
}
