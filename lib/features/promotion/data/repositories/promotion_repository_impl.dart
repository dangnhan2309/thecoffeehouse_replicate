import 'package:nhom2_thecoffeehouse/features/product/data/datasources/remote/product_remote_datasource.dart';
import 'package:nhom2_thecoffeehouse/features/product/domain/entities/product.dart';
import 'package:nhom2_thecoffeehouse/features/promotion/data/datasources/remote/promotion_remote_datasource.dart';
import 'package:nhom2_thecoffeehouse/features/promotion/domain/entities/promotion.dart';
import 'package:nhom2_thecoffeehouse/features/promotion/domain/repositories/promotion_repository.dart';

class PromotionRepositoryImpl implements PromotionRepository {
  final PromotionRemoteDatasource promoRemote;
  final ProductRemoteDatasource productRemote;

  PromotionRepositoryImpl({
    required this.promoRemote,
    required this.productRemote,
  });

  @override
  Future<List<Promotion>> getPromotions() async {
    final models = await promoRemote.getPromotions();
    return models;
  }

  @override
  Future<List<Product>> getProductsByPromotion(int promotionId) async {
    final ids = await promoRemote.getProductIdsByPromotion(promotionId);
    return await productRemote.getProductsByIds(ids);
  }
}
