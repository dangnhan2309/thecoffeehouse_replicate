import 'package:http/http.dart' as http;
import 'package:nhom2_thecoffeehouse/appconfig.dart';
import 'package:nhom2_thecoffeehouse/features/banner/data/models/banner_model.dart';
import 'dart:convert';

abstract class BannerRemoteDatasource {
  Future<List<BannerModel>> getBanners();
}

class BannerRemoteDatasourceImpl implements BannerRemoteDatasource {
  @override
  Future<List<BannerModel>> getBanners() async {
    final response = await http.get(
      Uri.parse('${AppConfig.baseUrl}/banners/'),
    );
    final List data = jsonDecode(response.body);
    return data.map((e) => BannerModel.fromJson(e)).toList();
  }
}
