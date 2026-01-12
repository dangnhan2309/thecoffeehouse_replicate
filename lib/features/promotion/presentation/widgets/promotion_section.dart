// import 'package:flutter/material.dart';
// import 'package:nhom2_thecoffeehouse/appconfig.dart';
// import 'package:nhom2_thecoffeehouse/features/home/presentation/state/home_provider.dart';
// import 'package:nhom2_thecoffeehouse/features/promotion/domain/entities/promotion.dart';
// import 'package:nhom2_thecoffeehouse/features/product/domain/entities/product.dart';
//
// /// =======================
// /// PROMO PRODUCT CARD
// /// =======================
// class PromoProductCard extends StatelessWidget {
//   final Product product;
//
//   const PromoProductCard({
//     super.key,
//     required this.product,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 160,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           AspectRatio(
//             aspectRatio: 1,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: Image.network(
//                 "${AppConfig.baseUrl}/static/${product.imageUrl}",
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             product.name,
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//             style: const TextStyle(
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             '${product.price ?? 0}đ',
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// /// =======================
// /// PROMOTION SECTION
// /// =======================
// class PromotionSection extends StatelessWidget {
//   final List<Promotion> promotions;
//   final HomeProvider provider;
//
//   const PromotionSection({
//     super.key,
//     required this.promotions,
//     required this.provider,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     if (promotions.isEmpty) {
//       return const SizedBox.shrink();
//     }
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: promotions.map((promo) {
//         final products = provider.productsByIds(promo.id);
//
//         if (products.isEmpty) {
//           return const SizedBox.shrink();
//         }
//
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// TITLE
//             Text(
//               promo.name,
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 12),
//
//             /// PRODUCT LIST
//             SizedBox(
//               height: 240,
//               child: ListView.separated(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: products.length,
//                 separatorBuilder: (_, __) =>
//                 const SizedBox(width: 16),
//                 itemBuilder: (context, index) {
//                   return PromoProductCard(
//                     product: products[index],
//                   );
//                 },
//               ),
//             ),
//
//             const SizedBox(height: 32),
//           ],
//         );
//       }).toList(),
//     );
//   }
// }
