import 'package:flutter/material.dart';
import 'package:nhom2_thecoffeehouse/features/category/domain/entities/category.dart';

class HomeScrollProvider extends ChangeNotifier {
  int? _currentCategoryId;

  int? get currentCategoryId => _currentCategoryId;

  void selectCategory(Category category) {
    _currentCategoryId = category.id;
    notifyListeners();
  }

  void clear() {
    _currentCategoryId = null;
    notifyListeners();
  }
}
