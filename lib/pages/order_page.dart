// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:nhom2_thecoffeehouse/widgets/category_section.dart';
import 'package:nhom2_thecoffeehouse/widgets/product_list.dart';
import '../widgets/search_bar.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../data/datasources/remote/api_service.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final ApiService _apiService = ApiService();
  final ScrollController _scrollController = ScrollController();

  List<Category> _categories = [];
  List<Product> _products = [];
  bool _isLoading = true;
  final Map<int, GlobalKey> _sectionKeys = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final results = await Future.wait([
        _apiService.getCategories(),
        _apiService.getProducts(),
      ]);

      final categories = results[0] as List<Category>;
      final products = results[1] as List<Product>;

      print('Số category: ${categories.length}');
      print('Số product: ${products.length}');

      // In thử vài category và product để so sánh id
      if (categories.isNotEmpty) {
        print('Category đầu tiên: id = ${categories.first.id} - ${categories.first.name}');
      }

      if (products.isNotEmpty) {
        print('Product đầu tiên: categoryId = ${products.first.categoryId} - ${products.first.name}');
      }

      // Kiểm tra xem có bao nhiêu product có categoryId hợp lệ
      final validProducts = products.where((p) => p.categoryId != null).length;
      print('Số product có categoryId không null: $validProducts');

      setState(() {
        _categories = categories;
        _products = products;
        _isLoading = false;

        for (var cat in _categories) {
          _sectionKeys[cat.id] = GlobalKey();
        }
      });
      // Sau khi build xong, attach listener để update category khi scroll
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.addListener(_onScrollUpdateCategory);
      });
    } catch (e) {
      print('Error: $e');
      setState(() => _isLoading = false);
    }
  }

  void _onScrollUpdateCategory() {
    if (_categories.isEmpty) return;

    int? currentCategoryId;
    double minDistance = double.infinity;

    for (var entry in _sectionKeys.entries) {
      final RenderBox? box =
      entry.value.currentContext?.findRenderObject() as RenderBox?;
      if (box != null && box.hasSize) {
        final offset = box.localToGlobal(
          Offset.zero,
          ancestor: context.findRenderObject(),
        );
        final distance = (offset.dy - 150)
            .abs(); // 150 là khoảng cách từ top + appbar
        if (distance < minDistance) {
          minDistance = distance;
          currentCategoryId = entry.key;
        }
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollUpdateCategory);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverPersistentHeader(pinned: true, delegate: SearchAppBar()),
          SliverToBoxAdapter(
            child: _categories.isNotEmpty
                ? CategorySection(categories: _categories)
                : const SizedBox.shrink(),
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
                      margin: const EdgeInsets.only(top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ===== CATEGORY TITLE =====
                          Text(
                            category.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),

                          const SizedBox(height: 12),

                          // ===== PRODUCT LIST =====
                          ListView.builder(
                            itemCount: productsInCat.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, i) {
                              return ProductListItem(
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

                          const SizedBox(height: 16),
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
    );
  }
}
