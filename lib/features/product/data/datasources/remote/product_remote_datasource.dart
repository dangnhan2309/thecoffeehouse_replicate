import 'package:nhom2_thecoffeehouse/appconfig.dart';
import 'package:nhom2_thecoffeehouse/features/product/data/models/product_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class ProductRemoteDatasource {
  Future<List<ProductModel>> getAllProducts();
  Future<ProductModel> getProductById(int id);
  Future<List<ProductModel>> getProductsByIds(List<int> ids);
  Future<List<ProductModel>> getProductsByCategory(int categoryId);
}

class ProductRemoteDatasourceImpl extends ProductRemoteDatasource{
  @override
  Future<List<ProductModel>> getAllProducts() async {
    final response = await http.get(Uri.parse("${AppConfig.baseUrl}/products"));
    final List data = jsonDecode(response.body);
    return data.map((json) => ProductModel.fromJson(json)).toList();
  }

  // Lấy 1 product theo id
  @override
  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await http.post(
        Uri.parse("${AppConfig.baseUrl}/products/by-id"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': id}), // đúng
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return ProductModel.fromJson(data);
      } else {
        throw Exception(
            'Failed to fetch product: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching product by id: $e');
    }
  }

// Lấy nhiều product theo list id
  @override
  Future<List<ProductModel>> getProductsByIds(List<int> ids) async {
    try {
      final response = await http.post(
        Uri.parse("${AppConfig.baseUrl}/products/by-ids"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'ids': ids}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        return data
            .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
            'Failed to fetch products: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching products by ids: $e');
    }
  }
  @override
  Future<List<ProductModel>> getProductsByCategory(int categoryId) async {
    final response = await http.get(
      Uri.parse("${AppConfig.baseUrl}/products/category/$categoryId"),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch products by category');
    }
  }

}
