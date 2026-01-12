import 'package:flutter/material.dart';
import 'package:nhom2_thecoffeehouse/appconfig.dart';
import 'package:nhom2_thecoffeehouse/core/constants/enum.dart';
import 'package:nhom2_thecoffeehouse/core/utils/currency_formatter.dart';
import 'package:nhom2_thecoffeehouse/features/home/presentation/state/home_provider.dart';
import 'package:nhom2_thecoffeehouse/features/promotion/domain/entities/promotion.dart';
import 'package:nhom2_thecoffeehouse/features/product/domain/entities/product.dart';
import 'package:nhom2_thecoffeehouse/features/product/presentation/widgets/product_detail_item.dart';
import 'package:nhom2_thecoffeehouse/features/product/domain/usecases/get_products_by_category.dart';
import 'package:nhom2_thecoffeehouse/features/order/presentation/state/order_provider.dart';
import 'package:provider/provider.dart';

class PromoProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;

  const PromoProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    // Ưu tiên lấy giá medium nếu là nước (có size), nếu không thì lấy giá mặc định
    final displayPrice = product.priceMedium ?? product.price ?? 0.0;

    return Container(
      width: 155,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1.1,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.network(
                      "${AppConfig.baseUrl}/static/${product.imageUrl}",
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[100],
                        child: const Icon(Icons.image_not_supported),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF26522),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'PROMO',
                      style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        CurrencyFormatter.formatVND(displayPrice),
                        style: const TextStyle(
                          color: Color(0xFFF26522),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: onAddToCart,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF26522).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.add, color: Color(0xFFF26522), size: 18),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PromotionSection extends StatelessWidget {
  final List<Promotion> promotions;
  final HomeProvider provider;

  const PromotionSection({
    super.key,
    required this.promotions,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    if (promotions.isEmpty) return const SizedBox.shrink();

    return Column(
      children: promotions.map((promo) {
        final products = provider.productsByPromotion(promo.id);
        
        if (products.isEmpty) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.only(bottom: 24, top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      promo.name,
                      style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 245,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 14, bottom: 10, top: 4),
                      child: PromoProductCard(
                        product: product,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductDetailPage(
                                product: product,
                                getProductsByCategory: context.read<GetProductsByCategoryUseCase>(),
                              ),
                            ),
                          );
                        },
                        onAddToCart: () {
                          // Xác định size mặc định (ưu tiên Medium) để tránh giá 0đ
                          SizeOption? defaultSize;
                          if (product.priceMedium != null) {
                            defaultSize = SizeOption.medium;
                          } else if (product.priceSmall != null) {
                            defaultSize = SizeOption.small;
                          } else if (product.priceLarge != null) {
                            defaultSize = SizeOption.large;
                          }

                          context.read<OrderProvider>().addProduct(
                            product,
                            size: defaultSize,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Đã thêm ${product.name} vào giỏ'),
                              backgroundColor: const Color(0xFFF26522),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
