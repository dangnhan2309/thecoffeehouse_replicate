import 'dart:convert';
import 'package:nhom2_thecoffeehouse/appconfig.dart';
import 'package:http/http.dart' as http;
import 'package:nhom2_thecoffeehouse/features/promotion/data/models/promotion_model.dart';
import 'package:nhom2_thecoffeehouse/features/product/data/models/product_model.dart';

abstract class PromotionRemoteDatasource{
  Future<List<PromotionModel>> getPromotions();
  Future<List<ProductModel>> getProductsByPromotion(int promotionId);
}

class PromotionRemoteDatasourceImpl implements PromotionRemoteDatasource {
  @override
  Future<List<PromotionModel>> getPromotions() async {
    final response = await http.get(
      Uri.parse('${AppConfig.baseUrl}/promotions/'),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => PromotionModel.fromJson(e)).toList();
    }
    return [];
  }

  @override
  Future<List<ProductModel>> getProductsByPromotion(int promotionId) async {
    // Sử dụng API /full để lấy toàn bộ thông tin sản phẩm
    final res = await http.get(
      Uri.parse('${AppConfig.baseUrl}/promotions/$promotionId/products/full'),
    );
    
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => ProductModel.fromJson(e)).toList();
    }
    return [];
  }
}
