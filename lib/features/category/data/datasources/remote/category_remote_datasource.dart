import 'dart:convert';
import 'package:nhom2_thecoffeehouse/appconfig.dart';
import 'package:nhom2_thecoffeehouse/features/category/data/models/category_model.dart';
import 'package:http/http.dart' as http;

abstract class CategoryRemoteDatasource {
  Future<List<CategoryModel>> getCategories();
}

class CategoryRemoteDatasourceImpl implements CategoryRemoteDatasource {
  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/categories/'),
      );
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((e) => CategoryModel.fromJson(e)).toList();
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print("GetCategories Error: $e tại địa chỉ ${AppConfig.baseUrl}");
      rethrow;
    }
  }
}
