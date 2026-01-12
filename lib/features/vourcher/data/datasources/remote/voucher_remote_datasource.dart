import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nhom2_thecoffeehouse/appconfig.dart';
import '../../models/voucher_model.dart';

abstract class VoucherRemoteDataSource {
  Future<List<VoucherModel>> getVouchers();
}

class VoucherRemoteDataSourceImpl implements VoucherRemoteDataSource {
  final http.Client client;

  VoucherRemoteDataSourceImpl({required this.client});

  @override
  Future<List<VoucherModel>> getVouchers() async {
    final response = await client.get(Uri.parse('${AppConfig.baseUrl}/vouchers/'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => VoucherModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load vouchers');
    }
  }
}
