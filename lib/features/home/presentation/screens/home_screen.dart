import 'package:flutter/material.dart';
import 'package:nhom2_thecoffeehouse/features/banner/presentation/widgets/banner_carousel.dart';
import 'package:nhom2_thecoffeehouse/features/category/presentation/widgets/category_section.dart';
import 'package:nhom2_thecoffeehouse/features/exploreTopic/presentation/widgets/explore_horizontal.dart';
import 'package:nhom2_thecoffeehouse/features/home/presentation/state/home_provider.dart';
import 'package:nhom2_thecoffeehouse/features/home/presentation/widgets/dynamic_appbar.dart';
import 'package:nhom2_thecoffeehouse/features/product/presentation/widgets/product_grid.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ScrollController _scrollController;
  void _onScroll() {
    context.read<HomeProvider>().handleScroll(_scrollController);
  }
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().loadHomeData();
      _scrollController.addListener(_onScroll);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(builder: (context, provider, _) {
      if (provider.isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

      if (provider.error != null) return Scaffold(body: Center(child: Text(provider.error!)));

      return Scaffold(
        body: Stack(
          children: [
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: DynamicHomeAppBar(
                    userName: 'Jess',
                    onCategoryModalToggle: provider.toggleCategoryModal,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: BannerCarousel(),
                  ),
                ),
                // if (provider.promotions.isNotEmpty)
                //   SliverToBoxAdapter(
                //     child: Padding(
                //       padding: const EdgeInsets.symmetric(horizontal: 16),
                //       child: PromotionSection(promotions: provider.promotions, provider: provider),
                //     ),
                //   ),
                if (provider.exploreTopics.isNotEmpty)
                  SliverToBoxAdapter(child: ExploreHorizontal(topics: provider.exploreTopics)),
                if (provider.categories.isNotEmpty)
                  SliverToBoxAdapter(
                      child: CategorySection(
                        categories: provider.categories,
                        onCategoryTap: provider.scrollToCategory,
                      )),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final category = provider.categories[index];
                        final products = provider.productsByCategory(category.id);

                        if (products.isEmpty) return const SizedBox.shrink();

                        return Column(
                          key: provider.sectionKeys[category.id],
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category.name,
                              key: provider.titleKeys[category.id],
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
                              itemBuilder: (context, i) {
                                return ProductGridItem(
                                  product: products[i],
                                  onTap: () {},
                                  onAddToCart: () {},
                                );
                              },
                            ),
                            const SizedBox(height: 32),
                          ],
                        );
                      },
                      childCount: provider.categories.length,
                    ),
                  ),
                ),
              ],
            ),
            if (provider.showCategoryModal)
              Positioned.fill(
                top: 100,
                child: GestureDetector(
                  onTap: provider.toggleCategoryModal,
                  child: Container(color: Colors.black.withAlpha(30)),
                ),
              ),
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }
}
