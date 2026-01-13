import 'package:flutter/material.dart';
import 'package:nhom2_thecoffeehouse/appconfig.dart';
import 'package:provider/provider.dart';
import 'package:nhom2_thecoffeehouse/features/auth/presentation/state/auth_provider.dart';
import 'package:nhom2_thecoffeehouse/features/auth/presentation/screens/login_screen.dart';
import 'package:nhom2_thecoffeehouse/features/auth/presentation/screens/edit_profile_screen.dart';
import 'package:nhom2_thecoffeehouse/features/order/presentation/screens/order_history_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tài khoản',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final user = authProvider.currentUser;

          if (!authProvider.isAuthenticated) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.account_circle_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text('Đăng nhập để trải nghiệm tốt hơn'),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                      if (result == true) {
                        authProvider.checkLoginStatus();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF26522),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('ĐĂNG NHẬP'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                /// USER INFO CARD
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.orange[100],
                        backgroundImage: (user?.avatarUrl != null)
                            ? NetworkImage(
                                "${AppConfig.baseUrl}/static/${user!.avatarUrl}",
                              )
                            : null,
                        child: (user?.avatarUrl == null)
                            ? const Icon(Icons.person, size: 40, color: Colors.orange)
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.name ?? 'Người dùng',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user?.email ?? '',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const EditProfileScreen(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.edit_outlined,
                          color: Color(0xFFF26522),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                /// MENU LIST
                _buildMenuItem(
                  Icons.person_outline,
                  'Chỉnh sửa thông tin cá nhân',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EditProfileScreen(),
                      ),
                    );
                  },
                ),
                _buildMenuItem(Icons.history, 'Lịch sử đơn hàng', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const OrderHistoryScreen(),
                    ),
                  );
                }),

                const SizedBox(height: 32),

                /// LOGOUT BUTTON
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => authProvider.logout(),
                    icon: const Icon(Icons.logout),
                    label: const Text('ĐĂNG XUẤT'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
