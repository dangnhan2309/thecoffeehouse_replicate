import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:nhom2_thecoffeehouse/features/auth/domain/repositories/auth_repository.dart';
import 'package:nhom2_thecoffeehouse/features/user/domain/entities/user.dart';
import 'package:nhom2_thecoffeehouse/features/user/data/models/user_model.dart'; 
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nhom2_thecoffeehouse/appconfig.dart';
import 'package:http_parser/http_parser.dart';

class AuthRepositoryImpl implements AuthRepository {
  final http.Client client;
  final SharedPreferences sharedPreferences;

  AuthRepositoryImpl({required this.client, required this.sharedPreferences});

  @override
  Future<String> login(String email, String password) async {
    final response = await client.post(
      Uri.parse('${AppConfig.baseUrl}/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final String? token = data['token'] ?? data['access_token'];
      if (token == null) throw Exception('Không tìm thấy mã xác thực');
      await sharedPreferences.setString('token', token);
      return token;
    } else {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'Đăng nhập thất bại');
    }
  }

  @override
  Future<void> register(String name, String email, String password) async {
    final response = await client.post(
      Uri.parse('${AppConfig.baseUrl}/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'full_name': name, 'email': email, 'password': password}),
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'Registration failed');
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    final token = await getToken();
    if (token == null) return null;
    try {
      final response = await client.get(
        Uri.parse('${AppConfig.baseUrl}/auth/me'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        return UserModel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print('Error getting current user: $e');
    }
    return null;
  }

  @override
  Future<String?> getToken() async {
    return sharedPreferences.getString('token');
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  @override
  Future<void> logout() async {
    await sharedPreferences.remove('token');
  }

  @override
  Future<User> updateProfile({
    String? name,
    String? phone,
    String? email,
    String? currentPassword,
    String? newPassword,
    File? avatar,
  }) async {
    final token = await getToken();
    final uri = Uri.parse('${AppConfig.baseUrl}/auth/update-profile');
    
    var request = http.MultipartRequest('PUT', uri);
    request.headers['Authorization'] = 'Bearer $token';

    if (name != null) request.fields['full_name'] = name;
    if (email != null) request.fields['email'] = email;
    if (currentPassword != null) request.fields['current_password'] = currentPassword;
    if (newPassword != null) request.fields['new_password'] = newPassword;
    
    if (avatar != null) {
      String fileName = avatar.path.split('/').last;
      request.files.add(await http.MultipartFile.fromPath(
        'avatar', 
        avatar.path,
        contentType: MediaType('image', 'jpeg'),
      ));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Backend FastAPI thường trả về user trực tiếp hoặc trong field 'user'
      final updatedData = data['user'] ?? data;
      
      return UserModel.fromJson(updatedData);
    } else {
      final data = jsonDecode(response.body);
      throw Exception(data['detail'] ?? data['message'] ?? 'Cập nhật thất bại');
    }
  }
}
