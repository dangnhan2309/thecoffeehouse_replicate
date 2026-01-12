import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nhom2_thecoffeehouse/features/category/presentation/widgets/category_section.dart';
import 'package:nhom2_thecoffeehouse/features/order/presentation/screens/cart_screen.dart';
import 'package:provider/provider.dart';
import 'package:nhom2_thecoffeehouse/features/home/presentation/state/home_provider.dart';
import 'package:nhom2_thecoffeehouse/features/order/presentation/state/order_provider.dart';
import 'package:nhom2_thecoffeehouse/features/product/presentation/widgets/product_list.dart';
import 'package:nhom2_thecoffeehouse/features/home/presentation/widgets/search_bar.dart';
import 'package:nhom2_thecoffeehouse/core/utils/currency_formatter.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _sectionKeys = {};
  bool _isFabVisible = true;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().loadHomeData();
      context.read<OrderProvider>().loadCart();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        if (_isFabVisible) {
          setState(() {
            _isFabVisible = false;
          });
        }
      } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
        if (!_isFabVisible) {
          setState(() {
            _isFabVisible = true;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();
    final homeProvider = context.watch<HomeProvider>();

    // Lọc sản phẩm theo tìm kiếm
    final categories = homeProvider.categories;
    
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: SearchAppBar(
              onSearchChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          
          if (_searchQuery.isEmpty && categories.isNotEmpty)
            SliverToBoxAdapter(
              child: CategorySection(
                categories: categories,
                onCategoryTap: (catId) {
                  final key = _sectionKeys[catId];
                  if (key != null && key.currentContext != null) {
                    Scrollable.ensureVisible(
                      key.currentContext!,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
            ),
            
          if (homeProvider.isLoading)
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
                    final category = categories[index];
                    var productsInCat = homeProvider.productsByCategory(category.id);

                    // Apply search filter
                    if (_searchQuery.isNotEmpty) {
                      productsInCat = productsInCat.where((p) => p.name.toLowerCase().contains(_searchQuery)).toList();
                    }

                    if (productsInCat.isEmpty) return const SizedBox.shrink();
                    _sectionKeys.putIfAbsent(category.id, () => GlobalKey());

                    return Container(
                      key: _sectionKeys[category.id],
                      margin: const EdgeInsets.only(top: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category.name,
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: productsInCat.length,
                            itemBuilder: (context, i) {
                              final product = productsInCat[i];
                              return ProductListItem(
                                product: product,
                                onAddToCart: () async {
                                  await orderProvider.addProduct(product);
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Đã thêm ${product.name} vào giỏ hàng!'),
                                      backgroundColor: Colors.green,
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: categories.length,
                ),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
      floatingActionButton: _isFabVisible && orderProvider.cart != null && orderProvider.cart!.items.isNotEmpty
          ? _buildCartFab(orderProvider)
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildCartFab(OrderProvider orderProvider) {
    final cart = orderProvider.cart!;
    final double total = cart.items.fold(0, (sum, item) => sum + (item.price * item.quantity));

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CartScreen()),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFFF26522),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Stack(
                children: [
                  const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 30),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Text(
                        '${orderProvider.cartItemCount}',
                        style: const TextStyle(color: Color(0xFFF26522), fontSize: 10, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Xem giỏ hàng',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Text(
                CurrencyFormatter.formatVND(total),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
