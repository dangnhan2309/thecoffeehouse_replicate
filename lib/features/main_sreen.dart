import 'package:flutter/material.dart';
import 'package:nhom2_thecoffeehouse/features/home/presentation/screens/home_screen.dart';
import 'package:nhom2_thecoffeehouse/features/home/presentation/widgets/bottom_navigation.dart';
import 'package:nhom2_thecoffeehouse/features/order/presentation/screens/order_screen.dart';
import 'package:nhom2_thecoffeehouse/features/auth/presentation/screens/profile_screen.dart';
import 'package:nhom2_thecoffeehouse/features/store/presentation/store_screen.dart';
import 'package:nhom2_thecoffeehouse/features/vourcher/presentation/screens/voucher_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(key: PageStorageKey('HomePage')),
    const OrderScreen(key: PageStorageKey('OrderPage')),
    const StoreScreen(key: PageStorageKey('StorePage')),
    const VoucherScreen(key: PageStorageKey('PromoPage')),
    const ProfileScreen(key: PageStorageKey('ProfilePage')),
  ];

  final PageStorageBucket _bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        bucket: _bucket,
        child: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
