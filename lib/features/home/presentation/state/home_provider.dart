import 'package:flutter/material.dart';
import 'package:nhom2_thecoffeehouse/features/exploreTopic/domain/entities/explore_topic.dart';
import 'package:nhom2_thecoffeehouse/features/exploreTopic/domain/usecases/get_explore_topics.dart';
import 'package:nhom2_thecoffeehouse/features/category/domain/usecases/get_categories.dart';
import 'package:nhom2_thecoffeehouse/features/product/domain/entities/product.dart';
import 'package:nhom2_thecoffeehouse/features/category/domain/entities/category.dart';
import 'package:nhom2_thecoffeehouse/features/product/domain/usecases/get_products_by_category.dart';


class HomeProvider extends ChangeNotifier {
  final GetProductsByCategoryUseCase getProducts;
  final GetCategoriesUseCase getCategories;
  // final GetPromotionsUseCase getPromotions;
  final GetExploreTopicsUseCase getExploreTopics;
  Category? currentCategory;
  HomeProvider({
    required this.getProducts,
    required this.getCategories,
    // required this.getPromotions,
    required this.getExploreTopics,
  });

  List<Product> products = [];
  List<Category> categories = [];
  // List<Promotion> promotions = [];
  List<ExploreTopic> exploreTopics = [];

  // UI state
  bool isLoading = true;
  String? error;
  bool showCategoryModal = false;

  // Scroll & keys
  Map<int, GlobalKey> sectionKeys = {};
  Map<int, GlobalKey> titleKeys = {};

  Future<void> loadHomeData() async {
    isLoading = true;
    notifyListeners();

    try {
      categories = await getCategories();
      exploreTopics = await getExploreTopics();

      // Khởi tạo keys
      for (var category in categories) {
        sectionKeys[category.id] = GlobalKey();
        titleKeys[category.id] = GlobalKey();
      }

      // Load products cho từng category
      for (var category in categories) {
        final products = await getProducts(categoryId: category.id);
        productsByCategoryMap[category.id] = products;
      }

      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  void toggleCategoryModal() {
    showCategoryModal = !showCategoryModal;
    notifyListeners();
  }

  void handleScroll(ScrollController controller) {
    for (final category in categories) {
      final key = sectionKeys[category.id];
      if (key == null) continue;

      final context = key.currentContext;
      if (context == null) continue;

      final box = context.findRenderObject() as RenderBox;
      final position = box.localToGlobal(Offset.zero).dy;

      /// 120 = chiều cao AppBar
      if (position <= 120 && position >= -box.size.height / 2) {
        if (currentCategory?.id != category.id) {
          currentCategory = category;
          notifyListeners();
        }
        return;
      }
    }

    /// Nếu chưa tới section category nào ➜ greeting
    if (currentCategory != null) {
      currentCategory = null;
      notifyListeners();
    }
  }

  void updateCurrentCategoryOnScroll() {
    for (final category in categories) {
      final key = sectionKeys[category.id];
      if (key == null) continue;

      final context = key.currentContext;
      if (context == null) continue;

      final box = context.findRenderObject() as RenderBox;
      final position = box.localToGlobal(Offset.zero).dy;

      /// 120 = chiều cao AppBar
      if (position <= 120 && position >= -box.size.height / 2) {
        if (currentCategory?.id != category.id) {
          currentCategory = category;
          notifyListeners();
        }
        return;
      }
    }

    /// Chưa tới section category nào → greeting
    if (currentCategory != null) {
      currentCategory = null;
      notifyListeners();
    }
  }


  void scrollToCategory(int categoryId) {
    final key = sectionKeys[categoryId];
    if (key != null && key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
  List<Product> productsByCategory(int categoryId) {
    return productsByCategoryMap[categoryId] ?? [];
  }

  Map<int, List<Product>> productsByCategoryMap = {};


}
