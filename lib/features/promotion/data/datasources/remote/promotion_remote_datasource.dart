import 'dart:convert';
import 'package:nhom2_thecoffeehouse/appconfig.dart';
import 'package:http/http.dart' as http;
import 'package:nhom2_thecoffeehouse/features/promotion/data/models/promotion_model.dart';

abstract class PromotionRemoteDatasource{
  Future<List<PromotionModel>> getPromotions();
  Future<List<int>> getProductIdsByPromotion(int promotionId);
}

class PromotionRemoteDatasourceImpl implements PromotionRemoteDatasource {
  @override
  Future<List<PromotionModel>> getPromotions() async {
    final response = await http.get(
      Uri.parse('${AppConfig.baseUrl}/promotions/'),
    );

    final List data = jsonDecode(response.body);
    return data.map((e) => PromotionModel.fromJson(e)).toList();
  }

  @override
  Future<List<int>> getProductIdsByPromotion(int promotionId) async {
    final res = await http.get(
      Uri.parse('${AppConfig.baseUrl}/promotions/$promotionId/full/'),
    );
    final data = jsonDecode(res.body) as List;

    return data.map<int>((e) => e['product_id'] as int).toList();
  }
}
