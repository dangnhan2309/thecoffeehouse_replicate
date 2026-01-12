import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nhom2_thecoffeehouse/features/order/data/models/order_item_model.dart';
import 'package:nhom2_thecoffeehouse/features/order/data/models/order_model.dart';
import 'package:nhom2_thecoffeehouse/core/constants/enum.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class OrderRemoteDatasource {
  Future<OrderModel?> getCart();
  Future<void> addToCart(OrderItemModel item);
  Future<void> removeFromCart(int productId);
  Future<OrderModel> checkoutCash();
  Future<void> updateCartItem(
      int productId, {
        int? quantity,
        SizeOption? size,
        IceOption? ice,
        SugarOption? sugar,
        List<String>? toppings,
        String? note,
      });
  Future<List<OrderModel>> getOrderHistory();
}

class OrderRemoteDatasourceImpl implements OrderRemoteDatasource {
  final http.Client client;
  final String baseUrl;
  final SharedPreferences prefs;

  OrderRemoteDatasourceImpl({
    required this.client, 
    required this.baseUrl,
    required this.prefs,
  });

  Map<String, String> get _headers {
    final token = prefs.getString('token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<List<OrderModel>> getOrderHistory() async {
    final res = await client.get(
      Uri.parse('$baseUrl/orders/history'),
      headers: _headers,
    );
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => OrderModel.fromJson(e)).toList();
    }
    throw Exception('Failed to load order history');
  }
  @override
  Future<void> addToCart(OrderItemModel item) async {
    final res = await client.post(
      Uri.parse('$baseUrl/orders/cart'),
      body: jsonEncode(item.toJson()),
      headers: _headers,
    );
    if (res.statusCode != 200) throw Exception('Add to cart failed');
  }

  @override
  Future<OrderModel?> getCart() async {
    try {
      final res = await client.get(
        Uri.parse('$baseUrl/orders/cart'),
        headers: _headers,
      );
      if (res.statusCode == 200) {
        return OrderModel.fromJson(jsonDecode(res.body));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> removeFromCart(int productId) async {
    final res = await client.delete(
      Uri.parse('$baseUrl/orders/cart/$productId'),
      headers: _headers,
    );
    if (res.statusCode != 200) throw Exception('Remove from cart failed');
  }

  @override
  Future<OrderModel> checkoutCash() async {
    final res = await client.post(
      Uri.parse('$baseUrl/orders/checkout/cash'),
      headers: _headers,
    );
    if (res.statusCode != 200) throw Exception('Checkout failed');
    return OrderModel.fromJson(jsonDecode(res.body));
  }

  @override
  Future<void> updateCartItem(
      int productId, {
        int? quantity,
        SizeOption? size,
        IceOption? ice,
        SugarOption? sugar,
        List<String>? toppings,
        String? note,
      }) async {
    final body = {
      if (quantity != null) 'quantity': quantity,
      if (size != null) 'size': size.toString().split('.').last,
      if (ice != null) 'ice': ice.toString().split('.').last,
      if (sugar != null) 'sugar': sugar.toString().split('.').last,
      if (toppings != null) 'toppings': toppings,
      if (note != null) 'note': note,
    };

    final res = await client.put(
      Uri.parse('$baseUrl/orders/cart/$productId'),
      body: jsonEncode(body),
      headers: _headers,
    );

    if (res.statusCode != 200) throw Exception('Update cart item failed');
  }
}
