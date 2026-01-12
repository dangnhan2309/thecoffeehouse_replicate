import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nhom2_thecoffeehouse/appconfig.dart';
import 'package:nhom2_thecoffeehouse/core/constants/enum.dart';
import 'package:nhom2_thecoffeehouse/features/product/domain/entities/product.dart';
import 'package:nhom2_thecoffeehouse/features/product/domain/usecases/get_products_by_category.dart';
import 'package:nhom2_thecoffeehouse/features/product/presentation/state/product_detail_provider.dart';
import 'package:nhom2_thecoffeehouse/features/product/presentation/widgets/product_customization_widgets.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;
  final GetProductsByCategoryUseCase getProductsByCategory;

  const ProductDetailPage({
    super.key,
    required this.product,
    required this.getProductsByCategory,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
      ProductDetailProvider(getProductsByCategory: getProductsByCategory)
        ..init(product),
      child: const _View(),
    );
  }
}

class _View extends StatelessWidget {
  const _View();

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductDetailProvider>(
      builder: (_, provider, __) {
        if (provider.isLoading) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        final imageUrl =
            "${AppConfig.baseUrl}/static/${provider.baseProduct!.imageUrl}";

        return Scaffold(
          body: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 300,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      background:
                      Image.network(imageUrl, fit: BoxFit.cover),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding:
                      const EdgeInsets.fromLTRB(24, 24, 24, 140),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(provider.baseProduct!.name,
                              style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text(provider.formatPrice(provider.totalPrice),
                              style: const TextStyle(
                                  fontSize: 28,
                                  color: Colors.deepOrange,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          Text(provider.formatDescription(
                              provider.baseProduct!.description)),
                          const SizedBox(height: 32),

                          buildSectionTitle("Topping"),
                          const SizedBox(height: 12),
                          InkWell(
                            onTap: () => provider
                                .showToppingsBottomSheet(context),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border:
                                Border.all(color: Colors.grey.shade300),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(provider.selectedToppingIds.isEmpty
                                      ? "Chọn topping"
                                      : "${provider.selectedToppingIds.length} topping"),
                                  Text(
                                    provider.selectedToppingPrice > 0
                                        ? "+${provider.formatPrice(provider.selectedToppingPrice)}"
                                        : "",
                                    style: const TextStyle(
                                        color: Colors.deepOrange,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),

              /// BOTTOM BAR
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: provider.decrement,
                          icon: const Icon(Icons.remove)),
                      Text("${provider.quantity}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold)),
                      IconButton(
                          onPressed: provider.increment,
                          icon: const Icon(Icons.add)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text(
                              "Thêm • ${provider.formatPrice(provider.totalPrice)}"),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
