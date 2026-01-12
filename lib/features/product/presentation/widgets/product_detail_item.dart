import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nhom2_thecoffeehouse/appconfig.dart';
import 'package:nhom2_thecoffeehouse/core/constants/enum.dart';
import 'package:nhom2_thecoffeehouse/features/product/domain/entities/product.dart';
import 'package:nhom2_thecoffeehouse/features/product/domain/usecases/get_products_by_category.dart';
import 'package:nhom2_thecoffeehouse/features/product/presentation/state/product_detail_provider.dart';
import 'package:nhom2_thecoffeehouse/features/product/presentation/widgets/product_customization_widgets.dart';
import 'package:nhom2_thecoffeehouse/features/order/presentation/state/order_provider.dart';
import 'package:nhom2_thecoffeehouse/features/product/presentation/state/favorite_provider.dart';

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
    final TextEditingController noteController = TextEditingController();
    final Set<int> drinkCategoryIds = {3, 4, 5, 6, 7, 8, 9, 10, 11};

    return Consumer2<ProductDetailProvider, FavoriteProvider>(
      builder: (_, provider, favoriteProvider, __) {
        if (provider.isLoading) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        final product = provider.baseProduct!;
        final imageUrl = "${AppConfig.baseUrl}/static/${product.imageUrl}";
        final isDrink = drinkCategoryIds.contains(product.categoryId);
        final isFavorite = favoriteProvider.isFavorite(product.id);

        return Scaffold(
          body: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 280,
                    pinned: true,
                    leading: IconButton(
                      icon: const Icon(Icons.close, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withAlpha(80),
                      ),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Image.network(imageUrl, fit: BoxFit.cover),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 140),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(product.name,
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold)),
                              ),
                              IconButton(
                                icon: Icon(
                                  isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: isFavorite ? Colors.red : Colors.grey,
                                ),
                                onPressed: () => favoriteProvider.toggleFavorite(product.id),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(provider.formatPrice(provider.totalPrice),
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFFF26522),
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          Text(
                            provider.formatDescription(product.description),
                            style: TextStyle(color: Colors.grey[600], fontSize: 14),
                          ),
                          const SizedBox(height: 32),

                          if (isDrink) ...[
                            /// SIZE SELECTION
                            if (product.hasSizeOptions()) ...[
                              buildSectionTitle("Chọn size (bắt buộc)"),
                              const SizedBox(height: 12),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    if (product.priceSmall != null)
                                      buildSizeButton(
                                          provider,
                                          "Nhỏ",
                                          product.priceSmall!,
                                          SizeOption.small),
                                    if (product.priceMedium != null)
                                      buildSizeButton(
                                          provider,
                                          "Vừa",
                                          product.priceMedium!,
                                          SizeOption.medium),
                                    if (product.priceLarge != null)
                                      buildSizeButton(
                                          provider,
                                          "Lớn",
                                          product.priceLarge!,
                                          SizeOption.large),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 32),
                            ],

                            /// SUGAR & ICE
                            buildOptionSection(
                              title: "Yêu cầu đường",
                              labels: ["70%", "100%", "0%", "30%", "50%"],
                              selected: provider.selectedSugar,
                              onTap: (val) => provider.setSugar(val as SugarOption),
                            ),
                            const SizedBox(height: 32),

                            buildOptionSection(
                              title: "Yêu cầu đá",
                              labels: ["70%", "100%", "0%", "30%", "50%"],
                              selected: provider.selectedIce,
                              onTap: (val) => provider.setIce(val as IceOption),
                            ),
                            const SizedBox(height: 32),

                            /// TOPPING
                            buildSectionTitle("Topping"),
                            const SizedBox(height: 12),
                            InkWell(
                              onTap: () => provider.showToppingsBottomSheet(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(provider.selectedToppingIds.isEmpty
                                        ? "Chọn topping"
                                        : "${provider.selectedToppingIds.length} topping đã chọn"),
                                    Row(
                                      children: [
                                        Text(
                                          provider.selectedToppingPrice > 0
                                              ? "+${provider.formatPrice(provider.selectedToppingPrice)}"
                                              : "",
                                          style: const TextStyle(
                                              color: Color(0xFFF26522),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Icon(Icons.keyboard_arrow_right,
                                            color: Colors.grey),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                          ],

                          /// NOTE
                          buildSectionTitle("Ghi chú"),
                          const SizedBox(height: 12),
                          TextField(
                            controller: noteController,
                            decoration: InputDecoration(
                              hintText: "Thêm ghi chú cho món này",
                              hintStyle: const TextStyle(fontSize: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                            maxLines: 2,
                          ),
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
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(5),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: provider.decrement,
                                icon: const Icon(Icons.remove)),
                            Text("${provider.quantity}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            IconButton(
                                onPressed: provider.increment,
                                icon: const Icon(Icons.add)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            final orderProvider = context.read<OrderProvider>();
                            final selectedToppingNames = provider.toppings
                                .where((t) => provider.selectedToppingIds.contains(t.id))
                                .map((t) => t.name)
                                .toList();

                            orderProvider.addProduct(
                              provider.baseProduct!,
                              quantity: provider.quantity,
                              size: isDrink ? provider.selectedSize : null,
                              ice: isDrink ? provider.selectedIce : null,
                              sugar: isDrink ? provider.selectedSugar : null,
                              toppings: isDrink ? selectedToppingNames : [],
                              toppingPrice: provider.selectedToppingPrice, // Truyền giá topping
                              note: noteController.text,
                            );

                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Đã thêm ${provider.baseProduct!.name} vào giỏ hàng'),
                                duration: const Duration(seconds: 2),
                                backgroundColor: const Color(0xFFF26522),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF26522),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "Chọn • ${provider.formatPrice(provider.totalPrice)}",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
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
