import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nhom2_thecoffeehouse/core/appconfig.dart';
import 'package:nhom2_thecoffeehouse/models/explore_topic.dart';

import 'package:nhom2_thecoffeehouse/models/product.dart';
import 'package:nhom2_thecoffeehouse/models/category.dart';
import 'package:nhom2_thecoffeehouse/models/banner.dart';
import 'package:nhom2_thecoffeehouse/models/order.dart';
import 'package:nhom2_thecoffeehouse/models/promotion.dart';

class ApiService {
  // Singleton
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String _baseUrl = AppConfig.baseUrl;

  // Helper: thêm token vào header nếu có
  Future<Map<String, String>> _getHeaders({bool withAuth = false}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (withAuth) {
      final token = await _storage.read(key: 'token');
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  // Helper: xử lý response chung
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    } else {
      final errorBody = response.body.isNotEmpty ? jsonDecode(response.body) : null;
      final message = errorBody?['detail'] ?? errorBody?['message'] ?? 'Có lỗi xảy ra';
      throw ApiException(message, response.statusCode);
    }
  }

  // ===== TEST CONNECTION =====
  Future<String> testConnection() async {
    final response = await http.get(Uri.parse('$_baseUrl/'));
    final data = _handleResponse(response);
    return data['message'] ?? 'Connected successfully';
  }

  // ===== AUTH =====
  Future<void> register(String fullName, String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/register'),
      headers: await _getHeaders(),
      body: jsonEncode({
        "full_name": fullName,
        "email": email,
        "password": password,
      }),
    );
    _handleResponse(response);
  }

  Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: await _getHeaders(),
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode != 200) {
      throw Exception("Đăng nhập thất bại: ${response.body}");
    }

    final data = jsonDecode(response.body);

    final token = data['token']; // giả sử API trả về token
    if (token == null) throw Exception("Token không tồn tại");

    return token; // trả token về cho LoginPage
  }

  Future<void> logout() async {
    await _storage.delete(key: 'token');
  }

  // ===== PRODUCTS =====
  Future<List<Product>> getProducts() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/products/'),
      headers: await _getHeaders(),
    );
    final List data = _handleResponse(response);
    return data.map((json) => Product.fromJson(json)).toList();
  }

  Future<List<Product>> getProductsByCategory(int categoryId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/products/category/$categoryId'),
      headers: await _getHeaders(),
    );
    final List data = _handleResponse(response);
    return data.map((json) => Product.fromJson(json)).toList();
  }


  // ===== CATEGORIES =====
  Future<List<Category>> getCategories() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/categories/'),
      headers: await _getHeaders(),
    );
    final List data = _handleResponse(response);
    return data.map((json) => Category.fromJson(json)).toList();
  }

  // ===== BANNERS =====
  Future<List<BannerModel>> getBanners() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/banners/'),
      headers: await _getHeaders(),
    );
    final List data = _handleResponse(response);
    return data.map((json) => BannerModel.fromJson(json)).toList();
  }

  // ===== PROMOTIONS =====
  Future<List<Promotion>> getPromotions() async {
    final response = await http.get(Uri.parse('$_baseUrl/promotions/'), headers: await _getHeaders());
    final List data = _handleResponse(response);
    return data.map((json) => Promotion.fromJson(json)).toList();
  }

  Future<List<int>> getProductIdsByPromotion(int promotionId) async {
    final res = await http.get(
      Uri.parse('$_baseUrl/promotions/$promotionId/full/'),
      headers: await _getHeaders(),
    );

    final data = _handleResponse(res) as List;

    return data.map<int>((e) => e['product_id'] as int).toList();
  }
  Future<List<Product>> getProductsByIds(List<int> ids) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/products/by-ids'),
      headers: await _getHeaders(),
      body: jsonEncode({'ids': ids}),
    );

    final List data = _handleResponse(response);
    return data.map((e) => Product.fromJson(e)).toList();
  }


  // ===== ORDERS =====
  Future<List<OrderResponse>> getOrders() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/orders/'),
      headers: await _getHeaders(withAuth: true), // yêu cầu token
    );
    final List data = _handleResponse(response);
    return data.map((json) => OrderResponse.fromJson(json)).toList();
  }
  // ===== EXPLORE TOPICS =====
  Future<List<ExploreTopic>> getExploreTopics() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/explore/'),
      headers: await _getHeaders(),
    );

    final data = _handleResponse(response);
    return (data as List).map((json) => ExploreTopic.fromJson(json)).toList();
  }

}

// Exception tùy chỉnh để dễ catch ở UI
class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException(this.message, this.statusCode);

  @override
  String toString() => 'ApiException($statusCode): $message';
}