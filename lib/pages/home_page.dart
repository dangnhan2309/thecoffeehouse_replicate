import 'package:flutter/material.dart';
import 'package:nhom2_thecoffeehouse/models/explore_topic.dart';
import 'package:nhom2_thecoffeehouse/models/promotion.dart';
import 'package:nhom2_thecoffeehouse/widgets/category_section.dart';
import 'package:nhom2_thecoffeehouse/widgets/dynamic_home_appbar.dart';
import 'package:nhom2_thecoffeehouse/widgets/product_grid.dart';
import 'package:nhom2_thecoffeehouse/widgets/promotion_section.dart';
import '../models/promotion.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/explore_horizontal.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../data/datasources/remote/api_service.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _apiService = ApiService();
  final ScrollController _scrollController = ScrollController();

  List<Category> _categories = [];
  List<Product> _products = [];
  List<Promotion> _promotions = [];
  List<ExploreTopic> _exploreTopics = [];

  final Map<int, GlobalKey> _sectionKeys = {};
  final Map<int, GlobalKey> _titleKeys = {};

  Category? _currentCategory;
  bool _isAtTop = true;
  bool _isLoading = true;
  bool _showCategoryModal = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final results = await Future.wait([
        _apiService.getCategories().catchError((e) => <Category>[]),
        _apiService.getProducts().catchError((e) => <Product>[]),
        _apiService.getPromotions().catchError((e) => <Promotion>[]),
        _apiService.getExploreTopics().catchError((e) => <ExploreTopic>[]),
      ]);

      if (!mounted) return;

      setState(() {
        _categories = results[0] as List<Category>;
        _products = results[1] as List<Product>;
        _promotions = results[2] as List<Promotion>;
        _exploreTopics = results[3] as List<ExploreTopic>;
        _isLoading = false;

        for (var cat in _categories) {
          _sectionKeys[cat.id] = GlobalKey();
          _titleKeys[cat.id] = GlobalKey();
        }
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
    } catch (e) {
      debugPrint('Fatal error loading data: $e');
      setState(() => _isLoading = false);
    }
  }
  void _onScroll() {
    if (!mounted) return;

    final scrollOffset = _scrollController.offset;

    Category? closestCategory;
    double closestDistance = double.infinity;

    const targetYPosition = 140.0;

    for (final cat in _categories) {
      final titleKey = _titleKeys[cat.id];
      if (titleKey != null && titleKey.currentContext != null) {
        final renderObject = titleKey.currentContext!.findRenderObject();
        if (renderObject is RenderBox && renderObject.hasSize) {
          final titlePosition = renderObject.localToGlobal(Offset.zero);
          final distance = (titlePosition.dy - targetYPosition).abs();

          if (titlePosition.dy <= targetYPosition) {
            if (distance < closestDistance) {
              closestDistance = distance;
              closestCategory = cat;
            }
          }
        }
      }
    }

    bool newIsAtTop;
    Category? newCurrentCategory;

    if (closestCategory != null) {
      newIsAtTop = false;
      newCurrentCategory = closestCategory;
    } else if (scrollOffset < 100) {
      newIsAtTop = true;
      newCurrentCategory = null;
    } else {
      newIsAtTop = _isAtTop;
      newCurrentCategory = _currentCategory;
    }

    if (newIsAtTop != _isAtTop || newCurrentCategory?.id != _currentCategory?.id) {
      setState(() {
        _isAtTop = newIsAtTop;
        _currentCategory = newCurrentCategory;
      });
    }
  }

  void _scrollToCategory(int categoryId) {
    final key = _sectionKeys[categoryId];
    if (key != null && key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.0,
      );
    }
  }

  void _onCategoryTap(int categoryId) {
    _scrollToCategory(categoryId);
    if (_showCategoryModal) {
      _toggleCategoryModal();
    }
  }

  void _toggleCategoryModal() {
    setState(() {
      _showCategoryModal = !_showCategoryModal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: DynamicHomeAppBar(
                  currentCategory: _currentCategory,
                  isAtTop: _isAtTop,
                  userName: "Jess",
                  categories: _categories,
                  onCategoryTap: _onCategoryTap,
                  onCategoryModalToggle: _toggleCategoryModal,
                ),
              ),

              SliverToBoxAdapter(child: BannerCarousel()),

              if (_promotions.isNotEmpty)
                SliverToBoxAdapter(
                  child: PromotionSection(
                    promotions: _promotions,
                    allProducts: _products,
                  ),
                ),
              if (_exploreTopics.isNotEmpty)
                SliverToBoxAdapter(
                  child: ExploreHorizontal(topics: _exploreTopics),
                ),

              if (_categories.isNotEmpty)
                SliverToBoxAdapter(
                  child: CategorySection(
                    categories: _categories,
                    onCategoryTap: _onCategoryTap,
                  ),
                ),

              if (_isLoading)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.orange),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final category = _categories[index];
                        final productsInCat = _products
                            .where((p) => p.categoryId == category.id)
                            .toList();

                        if (productsInCat.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        return Container(
                          key: _sectionKeys[category.id],
                          margin: const EdgeInsets.only(top: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Tiêu đề category
                              Container(
                                key: _titleKeys[category.id],
                                child: Text(
                                  category.name,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Grid 2 cột cho sản phẩm
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: productsInCat.length,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing: 16,
                                  childAspectRatio: 0.62, // Điều chỉnh nếu cần
                                ),
                                itemBuilder: (context, i) {
                                  return ProductGridItem(
                                    product: productsInCat[i],
                                    onAddToCart: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Đã thêm ${productsInCat[i].name} vào giỏ',
                                          ),
                                          backgroundColor: Colors.orange[700],
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),

                              const SizedBox(height: 32),
                            ],
                          ),
                        );
                      },
                      childCount: _categories.length,
                    ),
                  ),
                ),
            ],
          ),

          // Modal category (giữ nguyên)
          if (_showCategoryModal && _categories.isNotEmpty)
            Positioned.fill(
              top: 100,
              child: GestureDetector(
                onTap: _toggleCategoryModal,
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Danh mục',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: _toggleCategoryModal,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Wrap(
                                spacing: 16,
                                runSpacing: 16,
                                children: _categories.map((category) {
                                  return InkWell(
                                    onTap: () => _onCategoryTap(category.id),
                                    borderRadius: BorderRadius.circular(12),
                                    child: SizedBox(
                                      width: 80,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Icon(
                                              Icons.category,
                                              color: Colors.orange[700],
                                              size: 30,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            category.name,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }
}