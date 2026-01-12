import 'package:nhom2_thecoffeehouse/features/product/domain/entities/product.dart';
import 'package:nhom2_thecoffeehouse/features/promotion/domain/entities/promotion.dart';

abstract class PromotionRepository {
  Future<List<Promotion>> getPromotions();
  Future<List<Product>> getProductsByPromotion(int promotionId);
}