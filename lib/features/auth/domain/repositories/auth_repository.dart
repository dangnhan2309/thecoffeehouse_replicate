import 'package:nhom2_thecoffeehouse/features/user/domain/entities/user.dart';
import 'dart:io';

abstract class AuthRepository {
  Future<String> login(String email, String password);
  Future<void> register(String name, String email, String password);
  Future<void> logout();
  Future<User?> getCurrentUser();
  Future<String?> getToken();
  Future<bool> isLoggedIn();
  Future<User> updateProfile({
    String? name,
    String? phone,
    String? email,
    String? currentPassword,
    String? newPassword,
    File? avatar,
  });
}
