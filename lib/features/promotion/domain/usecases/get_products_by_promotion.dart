// import 'package:nhom2_thecoffeehouse/features/product/domain/entities/product.dart';
// import 'package:nhom2_thecoffeehouse/features/product/domain/repositories/product_repository.dart';
// import 'package:nhom2_thecoffeehouse/features/promotion/domain/entities/promotion.dart';
// import 'package:nhom2_thecoffeehouse/features/promotion/domain/repositories/promotion_repository.dart';
//
//
// class PromotionWithProducts {
//   final Promotion promotion;
//   final List<Product> products;
//
//   PromotionWithProducts({
//     required this.promotion,
//     required this.products,
//   });
// }
//
// class GetProductsByPromotionUseCase {
//   final PromotionRepository repository;
//   final ProductRepository productRepository;
//
//   GetProductsByPromotionUseCase({
//     required this.repository,
//     required this.productRepository,
//   });
//
//   Future<List<PromotionWithProducts>> call() async {
//     final promotions = await repository.getPromotions();
//     final result = <PromotionWithProducts>[];
//
//     for (final promo in promotions) {
//       final productIds = await repository.getProductsByPromotion(promo.id);
//       // Lấy chi tiết product từ ProductRepository theo id
//       final products = <Product>[];
//       for (final id in productIds) {
//         final product = await productRepository.getProductBy(id);
//         products.add(product);
//       }
//
//       result.add(PromotionWithProducts(
//         promotion: promo,
//         products: products,
//       ));
//     }
//
//     return result;
//   }
// }
