import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nhom2_thecoffeehouse/features/product/presentation/state/favorite_provider.dart';
import 'package:nhom2_thecoffeehouse/features/home/presentation/state/home_provider.dart';
import 'package:nhom2_thecoffeehouse/features/product/presentation/widgets/product_list.dart';
import 'package:nhom2_thecoffeehouse/features/order/presentation/state/order_provider.dart';

class FavoriteProductsScreen extends StatelessWidget {
  const FavoriteProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sản phẩm yêu thích', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Color(0xFFF26522),
        foregroundColor: Colors.white,
      ),
      body: Consumer2<FavoriteProvider, HomeProvider>(
        builder: (context, favoriteProvider, homeProvider, _) {
          final favoriteIds = favoriteProvider.favoriteProductIds;
          
          if (favoriteIds.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text('Chưa có sản phẩm yêu thích nào', 
                    style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                ],
              ),
            );
          }

          // Lấy danh sách sản phẩm từ homeProvider dựa trên IDs
          final allProducts = homeProvider.categories.expand((cat) => homeProvider.productsByCategory(cat.id)).toList();
          final favoriteProducts = allProducts.where((p) => favoriteIds.contains(p.id)).toSet().toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favoriteProducts.length,
            itemBuilder: (context, index) {
              final product = favoriteProducts[index];
              return ProductListItem(
                product: product,
                onAddToCart: () async {
                  await context.read<OrderProvider>().addProduct(product);
                  if (!context.mounted) return;
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
          );
        },
      ),
    );
  }
}
