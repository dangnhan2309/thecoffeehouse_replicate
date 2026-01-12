import 'package:flutter/material.dart';
import 'package:nhom2_thecoffeehouse/features/category/presentation/widgets/category_section.dart';
import 'package:nhom2_thecoffeehouse/features/order/presentation/state/order_provider.dart';
import 'package:nhom2_thecoffeehouse/features/product/presentation/widgets/product_list.dart';
import 'package:nhom2_thecoffeehouse/features/home/presentation/widgets/search_bar.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _sectionKeys = {};

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrderProvider>();

    return Material(
      color: Colors.white,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: SearchAppBar(),
          ),

          SliverToBoxAdapter(
            child: provider.categories.isNotEmpty
                ? CategorySection(categories: provider.categories)
                : const SizedBox.shrink(),
          ),

          if (provider.isLoading)
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
                    final category = provider.categories[index];
                    final productsInCat =
                    provider.getProductsByCategory(category.id);

                    if (productsInCat.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    _sectionKeys.putIfAbsent(
                      category.id,
                          () => GlobalKey(),
                    );

                    return Container(
                      key: _sectionKeys[category.id],
                      margin: const EdgeInsets.only(top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
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
                                onAddToCart: () {
                                  // chỉ gọi CartProvider (không gọi repo)
                                },
                              );
                            },
                          ),

                          const SizedBox(height: 16),
                        ],
                      ),
                    );
                  },
                  childCount: provider.categories.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
