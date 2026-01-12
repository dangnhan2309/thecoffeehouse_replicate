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

  ScrollController? scrollController;
  final Map<int, GlobalKey> sectionKeys = {}; 
  final Map<int, GlobalKey> titleKeys = {};   

  int? _currentCategoryId;
  int? get currentCategoryId => _currentCategoryId;

  Category? get currentCategory {
    if (_currentCategoryId == null) return null;
    try {
      return categories.firstWhere((c) => c.id == _currentCategoryId);
    } catch (_) {
      return null;
    }
  }

  void setupScrollListener(ScrollController controller, Map<int, GlobalKey> sKeys, Map<int, GlobalKey> tKeys) {
    scrollController?.removeListener(_onScroll);
    scrollController = controller;
    sectionKeys.clear();
    sectionKeys.addAll(sKeys);
    titleKeys.clear();
    titleKeys.addAll(tKeys);
    scrollController?.addListener(_onScroll);
    notifyListeners();
  }

  void _onScroll() {
    if (scrollController == null) return;
    
    final scrollOffset = scrollController!.offset;
    
    // Nếu đang ở gần đầu trang (Banner/Promo), luôn hiện lời chào
    if (scrollOffset < 150) {
      if (_currentCategoryId != null) {
        _currentCategoryId = null;
        notifyListeners();
      }
      return;
    }

    int? activeCategoryId;
    
    // Duyệt qua các tiêu đề để tìm danh mục đang được hiển thị ở nửa trên màn hình
    for (var category in categories) {
      final key = titleKeys[category.id];
      final context = key?.currentContext;
      
      if (context != null) {
        final box = context.findRenderObject() as RenderBox;
        final positionY = box.localToGlobal(Offset.zero).dy;
        
        // Nếu tiêu đề danh mục đã cuộn lên nửa trên màn hình (< 450px)
        if (positionY < 450) {
          activeCategoryId = category.id;
        }
      }
    }

    if (activeCategoryId != _currentCategoryId) {
      _currentCategoryId = activeCategoryId;
      notifyListeners();
    }
  }

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

  void scrollToCategory(int categoryId) {
    final key = sectionKeys[categoryId];
    if (key == null) return;
    final ctx = key.currentContext;
    if (ctx == null) return;

    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      alignment: 0.0,
    );
  }

  @override
  void dispose() {
    scrollController?.removeListener(_onScroll);
    super.dispose();
  }
}
