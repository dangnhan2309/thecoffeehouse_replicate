import 'dart:convert';
import 'package:nhom2_thecoffeehouse/appconfig.dart';
import 'package:http/http.dart' as http;
import 'package:nhom2_thecoffeehouse/features/order/data/models/order_model.dart';
import 'package:nhom2_thecoffeehouse/features/order/domain/entities/order.dart';

abstract class OrderRemoteDatasource {
  Future<Order> getCart();
  Future<void> addToCart(int productId);
  Future<void> removeFromCart(int productId);
}

class OrderRemoteDatasourceImpl extends OrderRemoteDatasource {
  @override
  Future<Order> getCart() async {
    final response = await http.get(
      Uri.parse("${AppConfig.baseUrl}/orders/cart"),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to load cart");
    }

    final data = jsonDecode(response.body);
    return OrderModel.fromJson(data);
  }

  @override
  Future<void> addToCart(int productId) async {
    final response = await http.post(
      Uri.parse("${AppConfig.baseUrl}/orders/cart/items"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"product_id": productId}),
    );

    if (response.statusCode != 200) {
      throw Exception("Add to cart failed");
    }
  }

  @override
  Future<void> removeFromCart(int productId) async {
    final response = await http.delete(
      Uri.parse("${AppConfig.baseUrl}/orders/cart/items/$productId"),
    );

    if (response.statusCode != 200) {
      throw Exception("Remove from cart failed");
    }
  }
}
