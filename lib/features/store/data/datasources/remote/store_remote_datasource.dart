import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:nhom2_thecoffeehouse/appconfig.dart';
import 'package:nhom2_thecoffeehouse/core/constants/enum.dart';
import 'package:nhom2_thecoffeehouse/features/store/data/model/store_model.dart';
import 'package:nhom2_thecoffeehouse/features/store/presentation/utils/city_enum_extension.dart';

abstract class StoreRemoteDataSource {
  Future<List<StoreModel>> getStores();
  Future<List<StoreModel>> getStoresByCity(CityEnum city);
  Future<List<StoreModel>> getNearestStores(double lat, double lng);
}

class StoreRemoteDataSourceImpl implements StoreRemoteDataSource {
  final client = http.Client();

  @override
  Future<List<StoreModel>> getStores() async {
    final response = await client.get(Uri.parse('${AppConfig.baseUrl}/stores'));
    final List data = json.decode(response.body);
    return data.map((e) => StoreModel.fromJson(e)).toList();
  }

  @override
  Future<List<StoreModel>> getStoresByCity(CityEnum city) async {
    final response = await client.get(
      Uri.parse('${AppConfig.baseUrl}/stores/by-city?city=${city.apiValue}'),
    );

    debugPrint('Request city: $city');
    debugPrint('Response: ${response.body}');
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => StoreModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load stores');
    }
  }


  @override
  Future<List<StoreModel>> getNearestStores(double lat, double lng) async {
    final response = await client.get(
      Uri.parse('${AppConfig.baseUrl}/stores/nearest?lat=$lat&lng=$lng'),
    );
    final List data = json.decode(response.body);
    return data.map((e) => StoreModel.fromJson(e)).toList();
  }
}
