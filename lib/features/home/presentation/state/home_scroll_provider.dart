import 'package:flutter/cupertino.dart';
import 'package:nhom2_thecoffeehouse/features/category/domain/entities/category.dart';

class HomeScrollProvider extends ChangeNotifier {
  String _dynamicTitle = 'Chào bạn 👋';
  int? _currentCategoryId;

  String get dynamicTitle => _dynamicTitle;
  int? get currentCategoryId => _currentCategoryId;

  void showGreeting() {
    _dynamicTitle = 'Chào bạn 👋';
    _currentCategoryId = null;
    notifyListeners();
  }

  void setCategory(Category category) {
    _dynamicTitle = category.name;
    _currentCategoryId = category.id;
    notifyListeners();
  }
}
