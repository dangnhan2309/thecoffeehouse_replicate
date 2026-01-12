import 'package:flutter/material.dart';
import 'package:nhom2_thecoffeehouse/features/category/domain/entities/category.dart';
import 'package:nhom2_thecoffeehouse/features/category/domain/usecases/get_categories.dart';

class HomeAppBarProvider extends ChangeNotifier {
  final GetCategoriesUseCase getCategoriesUseCase;

  HomeAppBarProvider({required this.getCategoriesUseCase});

  List<Category> categories = [];
  Category? currentCategory;
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadCategories() async {
    isLoading = true;
    notifyListeners();

    try {
      categories = await getCategoriesUseCase();
      if (categories.isNotEmpty) currentCategory = categories.first;
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
      categories = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void selectCategory(Category category) {
    currentCategory = category;
    notifyListeners();
  }
}
