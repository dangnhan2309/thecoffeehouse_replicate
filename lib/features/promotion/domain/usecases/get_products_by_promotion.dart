import 'package:nhom2_thecoffeehouse/features/product/domain/entities/product.dart';
import 'package:nhom2_thecoffeehouse/features/promotion/domain/repositories/promotion_repository.dart';

class GetProductsByPromotionUseCase {
  final PromotionRepository repository;

  GetProductsByPromotionUseCase(this.repository);

  Future<List<Product>> call({required int promotionId}) async {
    return await repository.getProductsByPromotion(promotionId);
  }
}
