import 'package:flutter/material.dart';
import 'package:nhom2_thecoffeehouse/features/auth/presentation/state/auth_provider.dart';
import 'package:nhom2_thecoffeehouse/features/product/presentation/widgets/product_detail_item.dart';
import 'package:nhom2_thecoffeehouse/features/product/presentation/widgets/product_grid.dart';
import 'package:provider/provider.dart';
import 'package:nhom2_thecoffeehouse/features/banner/presentation/widgets/banner_carousel.dart';
import 'package:nhom2_thecoffeehouse/features/category/presentation/widgets/category_section.dart';
import 'package:nhom2_thecoffeehouse/features/category/presentation/widgets/category_grid_modal.dart';
import 'package:nhom2_thecoffeehouse/features/exploreTopic/presentation/widgets/explore_horizontal.dart';
import 'package:nhom2_thecoffeehouse/features/home/presentation/state/home_provider.dart';
import 'package:nhom2_thecoffeehouse/features/home/presentation/widgets/dynamic_appbar.dart';
import 'package:nhom2_thecoffeehouse/features/order/presentation/state/order_provider.dart';
import 'package:nhom2_thecoffeehouse/features/product/domain/usecases/get_products_by_category.dart';
import 'package:nhom2_thecoffeehouse/features/promotion/presentation/widgets/promotion_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<HomeProvider>().loadHomeData();
        context.read<OrderProvider>().loadCart();
      }
    });
  }

  void _showCategoryModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CategoryGridModal(
        onCategoryTap: (categoryId) {
          Navigator.pop(context);
          // Tính năng scrollToCategory đã bị xóa
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userName = context.select<AuthProvider, String>((p) => p.currentUser?.name ?? 'Bạn');
    final getProductsByCategory = context.read<GetProductsByCategoryUseCase>();

    return Consumer<HomeProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator(color: Color(0xFFF26522))));
        }

        return Scaffold(
          backgroundColor: Colors.white,
          body: RefreshIndicator(
            onRefresh: () => provider.loadHomeData(),
            child: CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: DynamicHomeAppBar(
                    userName: userName,
                    context: context,
                    onCategoryModalToggle: _showCategoryModal,
                  ),
                ),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: BannerCarousel(),
                  ),
                ),
                /// ================= PROMOTION SECTION =================
                SliverToBoxAdapter(
                  child: provider.promotions.isEmpty
                    ? const SizedBox.shrink()
                    : PromotionSection(
                        promotions: provider.promotions,
                        provider: provider,
                      ),
                ),

                /// ================= EXPLORE =================
                if (provider.exploreTopics.isNotEmpty)
                  SliverToBoxAdapter(
                    child: ExploreHorizontal(topics: provider.exploreTopics),
                  ),

                /// ================= CATEGORY SECTION =================
                if (provider.categories.isNotEmpty)
                  SliverToBoxAdapter(
                    child: CategorySection(
                      categories: provider.categories,
                      onCategoryTap: (categoryId) {
                        // Tính năng scrollToCategory đã bị xóa
                      },
                    ),
                  ),

                /// ================= PRODUCT SECTIONS =================
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final category = provider.categories[index];
                        final products = provider.productsByCategory(category.id);
                        if (products.isEmpty) return const SizedBox.shrink();

                        return Container(
                          padding: const EdgeInsets.only(top: 24, bottom: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category.name,
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: products.length,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing: 16,
                                  childAspectRatio: 0.62,
                                ),
                                itemBuilder: (context, productIndex) {
                                  final product = products[productIndex];
                                  return ProductGridItem(
                                    product: product,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProductDetailPage(
                                            product: product,
                                            getProductsByCategory: getProductsByCategory,
                                          ),
                                        ),
                                      );
                                    },
                                    onAddToCart: () async {
                                      final orderProvider = context.read<OrderProvider>();
                                      await orderProvider.addProduct(product, quantity: 1);
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Đã thêm ${product.name} vào giỏ'),
                                            backgroundColor: const Color(0xFFF26522),
                                            duration: const Duration(seconds: 1),
                                          ),
                                        );
                                      }
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      childCount: provider.categories.length,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),
        );
      },
    );
  }
}
