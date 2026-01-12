import 'package:flutter/material.dart';
import 'package:nhom2_thecoffeehouse/features/category/domain/entities/category.dart';
import 'package:nhom2_thecoffeehouse/features/category/domain/usecases/get_categories.dart';
import 'package:nhom2_thecoffeehouse/features/product/domain/entities/product.dart';
import 'package:nhom2_thecoffeehouse/features/product/domain/usecases/get_products_by_category.dart';
import 'package:nhom2_thecoffeehouse/features/exploreTopic/domain/entities/explore_topic.dart';
import 'package:nhom2_thecoffeehouse/features/exploreTopic/domain/usecases/get_explore_topics.dart';
import 'package:nhom2_thecoffeehouse/features/promotion/domain/entities/promotion.dart';
import 'package:nhom2_thecoffeehouse/features/promotion/domain/usecases/get_promotions.dart';
import 'package:nhom2_thecoffeehouse/features/promotion/domain/usecases/get_products_by_promotion.dart';

class HomeProvider extends ChangeNotifier {
  final GetProductsByCategoryUseCase getProducts;
  final GetCategoriesUseCase getCategories;
  final GetExploreTopicsUseCase getExploreTopics;
  final GetPromotionsUseCase getPromotions;
  final GetProductsByPromotionUseCase getPromoProducts;

  HomeProvider({
    required this.getProducts,
    required this.getCategories,
    required this.getExploreTopics,
    required this.getPromotions,
    required this.getPromoProducts,
  });

  List<Category> categories = [];
  List<ExploreTopic> exploreTopics = [];
  List<Promotion> promotions = [];
  final Map<int, List<Product>> _productsByCategory = {};
  final Map<int, List<Product>> _productsByPromotion = {};

  bool isLoading = false;
  String? error;

  Future<void> loadHomeData() async {
    if (isLoading) return;
    isLoading = true;
    notifyListeners();

    try {
      categories = await getCategories();
      final results = await Future.wait([
        getExploreTopics().catchError((e) => <ExploreTopic>[]),
        getPromotions().catchError((e) => <Promotion>[]),
      ]);

      exploreTopics = results[0] as List<ExploreTopic>;
      promotions = results[1] as List<Promotion>;

      for (final category in categories) {
        _productsByCategory[category.id] = await getProducts(categoryId: category.id);
      }

      for (final promo in promotions) {
        _productsByPromotion[promo.id] = await getPromoProducts(promotionId: promo.id);
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<Product> productsByCategory(int categoryId) => _productsByCategory[categoryId] ?? [];
  List<Product> productsByPromotion(int promoId) => _productsByPromotion[promoId] ?? [];
  
  // Getter giả để không làm lỗi code ở các UI đang gọi tới nó
  int? get currentCategoryId => null;
}
