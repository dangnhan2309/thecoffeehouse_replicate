import 'package:nhom2_thecoffeehouse/features/promotion/domain/entities/promotion.dart';
import 'package:nhom2_thecoffeehouse/features/promotion/domain/repositories/promotion_repository.dart';

class GetPromotionsUseCase {
  final PromotionRepository repository;

  GetPromotionsUseCase(this.repository);

  Future<List<Promotion>> call() async {
    return await repository.getPromotions();
  }
}