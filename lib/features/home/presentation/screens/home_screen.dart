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
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final homeProvider = context.read<HomeProvider>();
      homeProvider.loadHomeData().then((_) {
        if (mounted) {
          // Khởi tạo cả sectionKeys (để cuộn) và titleKeys (để nhận diện tiêu đề)
          final Map<int, GlobalKey> sKeys = {
            for (var c in homeProvider.categories) c.id: GlobalKey()
          };
          final Map<int, GlobalKey> tKeys = {
            for (var c in homeProvider.categories) c.id: GlobalKey()
          };
          homeProvider.setupScrollListener(_scrollController, sKeys, tKeys);
        }
      });
      context.read<OrderProvider>().loadCart();
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
          context.read<HomeProvider>().scrollToCategory(categoryId);
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
              controller: _scrollController,
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
                    padding:  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                        context.read<HomeProvider>().scrollToCategory(categoryId);
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

                        // Key cho cả khối section (để scroll tới)
                        final sectionKey = provider.sectionKeys[category.id];
                        // Key cho Text tiêu đề (để nhận diện vị trí)
                        final titleKey = provider.titleKeys[category.id];

                        return Container(
                          key: sectionKey,
                          padding: const EdgeInsets.only(top: 24, bottom: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Gán Key vào Text tiêu đề
                              Text(
                                key: titleKey,
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
                                      if (mounted) {
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
