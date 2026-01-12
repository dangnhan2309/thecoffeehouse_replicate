import 'package:flutter/material.dart';
import 'package:nhom2_thecoffeehouse/features/category/domain/entities/category.dart';
import 'package:nhom2_thecoffeehouse/features/category/domain/usecases/get_categories.dart';

class CategoryProvider extends ChangeNotifier {
  final GetCategoriesUseCase getCategoriesUseCase;

  CategoryProvider({required this.getCategoriesUseCase});

  List<Category> categories = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadCategories() async {
    isLoading = true;
    notifyListeners();

    try {
      categories = await getCategoriesUseCase();
      errorMessage = null;
    } catch (e) {
      categories = [];
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

