import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nhom2_thecoffeehouse/appconfig.dart';
import 'package:nhom2_thecoffeehouse/core/constants/enum.dart';
import 'package:nhom2_thecoffeehouse/features/product/domain/entities/product.dart';
import 'package:nhom2_thecoffeehouse/features/product/domain/usecases/get_products_by_category.dart';
import 'package:nhom2_thecoffeehouse/features/product/presentation/utils/product_extension.dart';
import 'package:nhom2_thecoffeehouse/features/product/presentation/widgets/product_detail_item.dart';
import 'package:provider/provider.dart';

class ProductListItem extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;

  const ProductListItem({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    // Fallback nếu product.imageUrl null hoặc rỗng
    final imageUrl = (product.imageUrl != null && product.imageUrl!.isNotEmpty)
        ? "${AppConfig.baseUrl}/static/${product.imageUrl!}"
        : 'https://tse2.mm.bing.net/th/id/OIP.QjcB4e7ldYFhXlMIVDfNEgAAAA?cb=ucfimg2&ucfimg=1&w=328&h=240&rs=1&pid=ImgDetMain&o=7&rm=3';

    return InkWell(
      onTap: () {
        final getProductsByCategory =
        context.read<GetProductsByCategoryUseCase>();

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
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(15),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 90,
                height: 90,
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
            const SizedBox(width: 12),

            // INFO
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tên sản phẩm
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Giá + nút thêm
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.formattedPrice(
                          size: SizeOption.small,
                        ), // Dùng domain enum
                        style: TextStyle(
                          color: Colors.orange[700],
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      InkWell(
                        onTap:
                            onAddToCart, // Dependency Injection, widget không biết logic
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.orange[700],
                            borderRadius: BorderRadius.circular(10),
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
          ],
        ),
      ),
    );
  }
}
