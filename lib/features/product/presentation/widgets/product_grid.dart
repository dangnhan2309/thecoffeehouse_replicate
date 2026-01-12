import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nhom2_thecoffeehouse/appconfig.dart';
import 'package:nhom2_thecoffeehouse/core/constants/enum.dart';
import 'package:nhom2_thecoffeehouse/features/order/presentation/state/order_provider.dart';
import 'package:nhom2_thecoffeehouse/features/product/domain/usecases/get_products_by_category.dart';
import 'package:nhom2_thecoffeehouse/features/product/presentation/utils/product_extension.dart';
import 'package:nhom2_thecoffeehouse/features/product/presentation/widgets/product_detail_item.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/product.dart';

class ProductGridItem extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart; // Đây là Dependency Injection
  final VoidCallback onTap;

  const ProductGridItem({
    super.key,
    required this.product,
    required this.onTap,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = (product.imageUrl != null && product.imageUrl!.isNotEmpty)
        ? "${AppConfig.baseUrl}/static/${product.imageUrl!}"
        : 'https://tse2.mm.bing.net/th/id/OIP.QjcB4e7ldYFhXlMIVDfNEgAAAA?cb=ucfimg2&ucfimg=1&w=328&h=240&rs=1&pid=ImgDetMain&o=7&rm=3';

    return InkWell(
      borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailPage(
                product: product,
                getProductsByCategory:
                context.read<GetProductsByCategoryUseCase>(),
              ),
            ),
          );
        },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(20),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: AspectRatio(
                aspectRatio: 1,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.local_cafe, size: 56),
                  ),
                  fadeInDuration: const Duration(milliseconds: 300),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          product.formattedPrice(size: SizeOption.small),
                          style: TextStyle(
                            color: Colors.orange[700],
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        InkWell(
                          onTap: onAddToCart, // Chỉ callback
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.orange[700],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.add,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
